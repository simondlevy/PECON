/*
  Sockets support for Mex version of PECON. Adapted from Jim Plank's sockettome library.
*/

extern int serve_socket(int port);
extern int accept_connection(int s);
extern int request_connection(char *hn, int port);
