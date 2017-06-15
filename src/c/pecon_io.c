/*
 pecon_io.c: General input/ouput functions for Mex version of PECON.

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
