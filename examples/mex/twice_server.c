/*
 Mex code for server test function

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
