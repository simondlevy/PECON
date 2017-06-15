/*
 Client code for PECON standalone example

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
#include <string.h>
#include <stdlib.h>

#include <pecon.h>

static const int PORT     = 28000;;
static const int VERBOSE  = 1;
static const int TOLERANT = 1;
static const int N        = 10;

static double ** newvec() {
    
    double ** a = (double **)malloc(N*sizeof(double *));
    
    int k;
    for (k=0; k<N; ++k) {
        a[k] = malloc(sizeof(double));
    }
    
    return a;
}

static void freevec(double ** a) {
    
    int k;
    
    for (k=0; k<N; ++k) {
        free(a[k]);
    }
    
    free(a);
}

int main(int argc, char ** argv) {
    
    double **a = newvec();;
    double **b = newvec();
    size_t dsize = sizeof(double);
    double two = 2;
    
    /* build server executable name from current directory (NB: this will not work in Mex!) */
    char execname[256];
    sprintf(execname, "%s/twice_server", getenv("PWD"));
    
    /* use servers if specified; otherwise default to localhost */
    Pecon * p = argc > 1 ?
        pecon_client(execname, &two, dsize, dsize, dsize, &argv[1], argc-1, PORT, VERBOSE, TOLERANT) :
        pecon_client_dflt(execname, &two, dsize, dsize, dsize);
        
        if (!p) {
            exit(1);
        }
        
        pecon_client_set_verbose(p);
        
        int k;
        for (k=0; k<N; ++k) {
            (*a[k]) = k;
        }
        
        pecon_client_eval(p, (void **)a, (void **)b, N);
        
        for (k=0; k<N; ++k) {
            printf("%f\n", *(b[k]));
        }
        
        pecon_client_halt(p);
        
        freevec(a);
        freevec(b);
        
        return 0;
}
