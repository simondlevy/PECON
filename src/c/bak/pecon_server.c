#include <stdio.h>
#include <stdlib.h>
#include <sys/utsname.h>
#include <unistd.h>
#include <pecon.h>

#include "sockettome.h"
#include "pecon_io.h"

int main(int argc, char ** argv) {
    
    /* serve a socket on the port indicated in the command line */
    int port = atoi(argv[1]);        
    int sock = serve_socket(port);
    int fd = accept_connection(sock);

    /* open log file for writing */
    struct utsname utsbuf;
    FILE * logfp = NULL;
    char logfilename[100];
    uname(&utsbuf);
    sprintf(logfilename, "%s-%s-%d.log", argv[0], utsbuf.nodename, getpid());
    logfp = fopen(logfilename, "w");

    /* get buffer sizes from client */
    size_t inoutsize[3];
    read(fd, &inoutsize, 3*sizeof(size_t));
    size_t init_size = inoutsize[0];
    size_t eval_insize = inoutsize[1];
    size_t eval_outsize = inoutsize[2];

    /* allocate input buffers */
    void * init_buf = malloc(init_size);
    void * eval_inbuf = malloc(eval_insize);
    void * eval_outbuf = malloc(eval_outsize);
    
    /* get initialization data from client and run custom initialization */
    _pecon_read(fd, init_buf, init_size);
    pecon_server_init(init_buf, logfp);
    fflush(logfp);
    
    /* read from client, evaluate, and send back to client, until client
       halts server via close() */
    while (1) {
        
        _pecon_read(fd, eval_inbuf, eval_insize);
        
        pecon_server_eval(eval_inbuf, eval_outbuf, logfp);
        fflush(logfp);
    
        _pecon_write(fd, eval_outbuf, eval_outsize);
    }
      
    /* clean up */
    free(init_buf);
    free(eval_inbuf);
    free(eval_outbuf);
    pecon_server_close(logfp);
    fflush(logfp);
    fclose(logfp);
        
    /* indicate success to OS */
    return 0;
}
