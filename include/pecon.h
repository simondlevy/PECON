/**
* @file    pecon.h
* @author  Simon D. Levy <levys@wlu.edu>
*
* @section LICENSE
*
*  This program is free software. You can redistribute it and/or modify it under 
*  the terms of the Gnu Lesser General Public License as published by the 
*  Free Software Foundation either version 3 of the License, or (at your 
*  option) any later version. 
*
* @section DESCRIPTION
*
* Function headers for Mex version of PECON.
*
*/

#include <stdlib.h>
#include <stdio.h>

/**
 * A hack to simulate C++ objects.
 */
typedef void * Pecon;

/**
 * Creates a PECON client object with fully specified parameters.
 * @param execname full (direct) path name to server executable
 * @param init_data initialization data to send to server
 * @param init_data_size size of initialization data in bytes
 * @param eval_input_size size of data to receive from server on each function evaluation
 * @param eval_output_size size of data to send to server on each function evaluation
 * @param servers list of server names
 * @param nservers count of servers
 * @param port first port to attempt on servers
 * @param verbose flag for verbosity (nonzero = verbose; zero = quiet)
 * @param tolerant flag for error tolerances (nonzero = tolerant; zero = strict)
 * @return pointer to PECON client object
 */
Pecon * pecon_client(const char *execname, void * init_data, size_t init_data_size,
        size_t eval_input_size, size_t eval_output_size,      
        char ** servers, int nservers, int port, int verbose, int tolerant);
    
/**
 * Creates a PECON client object with fully specified parameters. This is useful on a cluster or network where
 * you need to specify the identities of each server.
 * @param execname full (direct) path name to server executable
 * @param init_data initialization data to send to server
 * @param init_data_size size of initialization data in bytes
 * @param eval_input_size size of data to receive from server on each function evaluation
 * @param eval_output_size size of data to send to server on each function evaluation
 * @param servers list of server names
 * @param nservers count of servers
 * @param port first port to attempt on servers
 * @param verbose flag for verbosity (nonzero = verbose; zero = quiet)
 * @param tolerant flag for error tolerances (nonzero = tolerant; zero = strict)
 * @return pointer to PECON client object
 */
Pecon * pecon_client_dflt(const char * execname, void * init_data, size_t init_data_size,
        size_t eval_input_size, size_t eval_output_size);

/**
 * Creates a PECON client object on local host with default parameters.  This is useful on multicore machines.
 * Defaults to localhost server(s), port 28000, quiet and tolerant.
 * @param execname full (direct) path name to server executable
 * @param init_data initialization data to send to server
 * @param init_data_size size of initialization data in bytes
 * @param eval_input_size size of data to receive from server on each function evaluation
 * @param eval_output_size size of data to send to server on each function evaluation
 * @return pointer to PECON client object
 */
void    pecon_client_eval(Pecon * pecon, void ** input, void ** output, int nitems);

/**
 * Shuts down PECON servers.
 * @param pecon pointer to PECON client object.
 */
void    pecon_client_halt(Pecon * pecon);

/**
 * Sets PECON to be error-tolerant.
 * @param pecon pointer to PECON client object.
 */
void    pecon_client_set_tolerant(Pecon * pecon);

/**
 * Sets PECON to be strict (error-intolerant).
 * @param pecon pointer to PECON client object.
 */
void    pecon_client_set_strict(Pecon * pecon);

/**
 * Sets PECON to be verbose (report how many bytes are being sent to/from client).  Helpful in debugging.
 * @param pecon pointer to PECON client object.
 */
void    pecon_client_set_verbose(Pecon * pecon);

/**
 * Sets PECON to be quiet.
 * @param pecon pointer to PECON client object.
 */
void    pecon_client_set_quiet(Pecon * pecon);



/**
 * Called automatically by pecon server on initialization.  
 * You must implement this function for each application.
 * @param input pointer to input data for initialization.
 * @param logfp pointer to log file maintained by PECON (you can write to this for debugging).
 */
void    pecon_server_init(void * input, FILE * logfp);

/**
 * Called automatically by pecon server on initialization.  
 * You must implement this function for each application.
 * @param input pointer to input data for function evaluation.
 * @param output pointer to output data for function evaluation.
 * @param logfp pointer to log file maintained by PECON (you can write to this for debugging).
 */
void    pecon_server_eval(void * input, void * output, FILE * logfp);

/**
 * Called automatically by pecon server after client calls pecon_halt().
 * You must implement this function for each application.
 * @param logfp pointer to log file maintained by PECON (you can write to this for debugging).
 */
void    pecon_server_close(FILE * logfp);


