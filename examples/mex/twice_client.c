/*
 Mex code for client test function

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

#include <mex.h>
#include <stdio.h>
#include <pecon.h>

static double ** newvec(int n) {

    double ** a = (double **)mxCalloc(n, sizeof(double *));

    int k;
    for (k=0; k<n; ++k) {
        a[k] = mxCalloc(1, sizeof(double));
    }

    return a;
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[] ) {

    int k;
    
    /* initialize PECON -- PECON_DIR is defined in Makefile */
    char execname[256];
    sprintf(execname, "%s/examples/mex/twice_server", PECON_DIR);
    double two = 2;
    Pecon * p = pecon_client_dflt(execname, &two, sizeof(double), sizeof(double), sizeof(double));
    
    /* report what's going on */
    pecon_client_set_verbose(p);
    
    /* get input vector from Matlab call */
    double * rhs = (double *)mxGetPr(prhs[0]);
    int n = mxGetN(prhs[0]); 

    /* allocate source, destination buffers for PECON */
    double ** a = newvec(n);
    double ** b = newvec(n);

    /* fill source buffer with values from input vector */
    for (k=0; k<n; ++k) {
        *(a[k]) = rhs[k];
    }

    /* evaluate remote function */
    pecon_client_eval(p, (void **)a, (void **)b, n);

    /* fill output vector with values from destination  buffer */
    plhs[0] = mxCreateDoubleMatrix(1, n, mxREAL);
    double * output = (double *)mxGetPr(plhs[0]);
    for (k=0; k<n; ++k) {
        output[k] = *(b[k]);
    }

    /* clean up */
    pecon_client_halt(p);
}
