/*
  pecon_io.h: Headers for general input/ouput functions for Mex version of PECON.
*/

size_t _pecon_read(int fildes, void *buf, size_t nbyte);

size_t _pecon_write(int fildes, const void *buf, size_t nbyte);
