#include <unistd.h>
#include <stdio.h>

#include "sockettome.h"
#include "pecon_io.h"

static size_t _tranceive(ssize_t (*fun)(int, void *, size_t),
        int fildes, void * buf, size_t nbyte) {
    
    size_t completed = 0;
    
    while (completed < nbyte) {
        
        size_t current = fun(fildes, buf, nbyte);
        
        if (current < 1) {
            break;
        }
        
        completed += current;
        buf += completed;
        
    }
    
    return completed;
}

size_t _pecon_read(int fildes, void * buf, size_t nbyte) {
    
    return _tranceive(read, fildes, buf, nbyte);
}

size_t _pecon_write(int fildes, const void *buf, size_t nbyte) {
    
    /* ugly casts support non-redundant code */
    return _tranceive((ssize_t (*)(int, void *, size_t))write, fildes, (void *)buf, nbyte);
}
