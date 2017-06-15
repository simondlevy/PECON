#include <pecon.h>

static double * factor;

void pecon_server_init(void * input, FILE *logfp) {
    
    factor = (double *)malloc(sizeof(double));
    
    *factor = *(double *)input;
}

void pecon_server_eval(void * input, void * output, FILE * logfp) {
 
  double a = *((double *)input);
  double b = *factor * a;

  fprintf(logfp, "%f -> %f\n", a, b);

  *(double *)output = b;
}

void pecon_server_close(FILE * logpf) {
    
    free(factor);
}
