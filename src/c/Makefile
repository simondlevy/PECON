# Makefile for PECON mex code
#
# Copyright (C) 2017 Simon D. Levy
#
# This file is part of PECON.
#
# PECON is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# PECON is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with PECON.  If not, see <http://www.gnu.org/licenses/>.

# User these for 64-bit OS X
CFLAGS_ARCH = -fno-common -no-cpp-precomp -arch x86_64 -isysroot /Developer/SDKs/MacOSX10.6.sdk \
    -mmacosx-version-min=10.5 -fexceptions -O2 

# Use these for 64-bit Linux
#CFLAGS_ARCH = -ansi -D_GNU_SOURCE  -fexceptions -fPIC -fno-omit-frame-pointer -pthread -O

# Comment-out the following line for standalone (non-Matlab) operations
MEXFLAGS = -I$(MATLAB)/extern/include -DMATLAB_MEX_FILE -DNDEBUG  -DMX_COMPAT_32 

CLIENT = libpecon_client.a
SERVER = libpecon_server.a
ALL = $(CLIENT) $(SERVER)
CFLAGS = -Wall $(CFLAGS_ARCH) $(MEXFLAGS)
DSTDIR = ../../lib
INCDIR = ../../include

all: $(ALL)

libpecon_server.a: pecon_server.o pecon_io.o sockettome.o
	ar rcs $(DSTDIR)/libpecon_server.a pecon_server.o pecon_io.o sockettome.o

pecon_server.o: pecon_server.c
	gcc -I$(INCDIR) -c $(CFLAGS) pecon_server.c

libpecon_client.a: pecon_client.o pecon_io.o sockettome.o
	ar rcs $(DSTDIR)/libpecon_client.a pecon_client.o pecon_io.o sockettome.o

pecon_client.o: pecon_client.c
	gcc -I$(INCDIR) -c $(CFLAGS) pecon_client.c

pecon_io.o: pecon_io.c
	gcc -I$(INCDIR) -c $(CFLAGS) pecon_io.c

sockettome.o: sockettome.c
	gcc -c $(CFLAGS) sockettome.c

clean:
	rm -f $(ALL) $(DSTDIR)/$(CLIENT) $(DSTDIR)/$(SERVER) *.o *.mex* *.*~

backup:
	cp *.c bak
	cp *.h bak
	cp Makefile bak
