/*
 pecon_client.c: Client code for Mex version of PECON. 

 Copyright (C) 2017 Simon D. Levy

 This file is part of PECON.

 PECON is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 PECON is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 You should have received a copy of the GNU General Public License
 along with PECON.  If not, see <http://www.gnu.org/licenses/>.
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <netdb.h>
#include <unistd.h>

#include <pecon.h>

#include "pecon_io.h"
#include "sockettome.h"

#ifdef MATLAB_MEX_FILE
#include <mex.h>
#define PRINTF mexPrintf
#else
#define PRINTF printf
#endif

/* default params settable in call to pecon() */
static const int PORT     = 28000; /* default port */
static const int VERBOSE  = 0;     /* default to quiet */
static const int TOLERANT = 1;     /* default to tolerant */

/* maximum number of ports to try if tolerant */
static const int MAX_TRY_PORTS = 100;

/* private data structure */
typedef struct {
    
    char ** servernames;
    int nservers;
    int port;
    int verbose;
    int tolerant;
    void * inbuf;
    size_t insize;
    void * outbuf;
    size_t outsize;
    int * fds;
    
} Pecon_struct;


static void * connectfail() {
    fprintf(stderr, "Connection failed\n");
    return NULL;
}

static Pecon_struct * _pecon_client(const char *execname, void * init_data, size_t init_data_size,
        size_t eval_input_size, size_t eval_output_size,
        char ** servers, int nservers,
        int port, int verbose, int tolerant) {
    
    Pecon_struct * p = (Pecon_struct *)malloc(sizeof(Pecon_struct));
    
    p->fds = (int *)malloc(nservers*sizeof(int));
    
    p->servernames = (char **)malloc(nservers*sizeof(char *));
    
    int k;     /* index of server to which connection is attempted */
    int j = 0; /* index of server to which connection is successful */
    for (k=0; k<nservers; ++k) {
        
        /* check host availability via ping */
        char cmd[256];
        char * hostname = servers ? servers[k] : "localhost";
        sprintf(cmd, "ping -c 1 %s > /dev/null", hostname);
        if (system(cmd)) { /* system() returns nonzero on failure */
            
            /* ignore failure if we're tolerant */
            if (tolerant) {
                continue;
            }
            
            return connectfail();
        }
        
        /* keep trying ports until success, so long as we're tolerant */
        int newport = port;;
        while (newport-port < MAX_TRY_PORTS) {
            
            PRINTF("Attempting to connect to host %s on port %d... ", hostname, newport);
            fflush(stdout);
            
            /* attempt to start remote process on host*/
            sprintf(cmd, "ssh %s '%s %d' &", hostname, execname, newport);
            system(cmd);
            
            /* a hack to wait for server startup */
            sleep(1);
            
            /* request_connection is in socketfun */
            p->fds[j] = request_connection(hostname, newport);
            
            /* success */
            if (p->fds[j]) {
                break;
            }
            
            if (!tolerant) {
                return connectfail();
            }
            
            /* keep tryin'! */
            newport++;
            
        } /* attempts loop */
        
        if (!p->fds[j]) {
            return connectfail();
        }
        
        PRINTF("connected\n");
        
        /* store server name for reporting later */
        p->servernames[j] = strdup(hostname);
        
        /* tell server how much data to expect in each message */
        size_t inoutsize[3];
        inoutsize[0] = init_data_size;
        inoutsize[1] = eval_input_size;
        inoutsize[2] = eval_output_size;
        _pecon_write(p->fds[j], inoutsize, 3*sizeof(size_t));
        
        /* send initialization data to server */
        _pecon_write(p->fds[j], init_data, init_data_size);
        
        /* success */
        j++;
        
        /* for multicore, always look at next port */
        if (!servers) {
            port++;
        }
        
    } /* loop over requested servers */
    
    p->nservers = j;
    p->inbuf = malloc(eval_input_size);
    p->insize = eval_input_size;
    
    p->outbuf = malloc(eval_output_size);
    p->outsize = eval_output_size;
    
    p->port = port;
    p->verbose = verbose;
    p->tolerant = tolerant;
    
    return p;
}

static void _set_tolerance(Pecon * pecon, int tolerant) {
    Pecon_struct * p = (Pecon_struct *)pecon;
    p->tolerant = tolerant;
}

static void _set_verbosity(Pecon * pecon, int verbose) {
    Pecon_struct * p = (Pecon_struct *)pecon;
    p->verbose = verbose;
}

Pecon * pecon_client(const char *execname, void * init_data, size_t init_data_size,
        size_t eval_input_size, size_t eval_output_size,      
        char ** servers, int nservers, int port, int verbose, int tolerant) {
    
    return (Pecon *)_pecon_client(execname, init_data, init_data_size,
            eval_input_size, eval_output_size, servers, nservers,
            port, verbose, tolerant);
}

Pecon * pecon_client_dflt(const char * execname, void * init_data, size_t init_data_size,
        size_t eval_input_size, size_t eval_output_size) {
    
    
    /* determine number of cores on localhost */
    int ncores = sysconf( _SC_NPROCESSORS_ONLN);
    
    /* null servers list indicates localhost */
    return (Pecon *)_pecon_client(execname, init_data, init_data_size,
            eval_input_size, eval_output_size, NULL, ncores,
            PORT, VERBOSE, TOLERANT);
}

void   pecon_client_eval(Pecon * pecon, void ** input, void ** output, int nitems) {
    
    Pecon_struct * p = (Pecon_struct *)pecon;
    
    /* round-robin i/o to/from servers */
    int k;
    for (k=0; k<nitems; ++k) {
        
        int j = k % p->nservers;
        
        int fd = p->fds[j];
        
        char * servername = p->servernames[j];
        
        if (p->verbose) {
            PRINTF("Sending  %-6ld bytes for argument %4d to server %s\n",
                    p->insize, k, servername);
            fflush(stdout);
        }
        
        _pecon_write(fd, input[k], p->insize);
        
        size_t nread = _pecon_read(fd, output[k], p->outsize);
        
        if (p->verbose) {
            PRINTF("Received %-6ld bytes for argument %4d from server %s\n",
                    nread, k, servername);
        }
    }
    
}

void pecon_client_halt(Pecon * pecon) {

    Pecon_struct * p = (Pecon_struct *)pecon;
    int k;
    for (k=0; k<p->nservers; ++k) {
        close(p->fds[k]);
        free(p->servernames[k]);
    }
    free(p->servernames);
    free(p->fds);
    free(p->inbuf);
    free(p->outbuf);
    free(pecon);
}

void  pecon_client_set_tolerant(Pecon * pecon) {
    _set_tolerance(pecon, 1);
}

void  pecon_client_set_strict(Pecon * pecon) {
    _set_tolerance(pecon, 0);
}

void  pecon_client_set_verbose(Pecon * pecon) {
    _set_verbosity(pecon, 1);
}

void  pecon_client_set_quiet(Pecon * pecon) {
    _set_verbosity(pecon, 0);
}


