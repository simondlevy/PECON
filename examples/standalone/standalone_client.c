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
