# Makefile for PECON standalone example
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

#ALL =  standalone_client twice_server
CFLAGS = -Wall
INCDIR = ../../include
LIBDIR = ../../lib

all: $(ALL)

test: $(ALL)
	./standalone_client

standalone_client: standalone_client.o
	gcc -o standalone_client standalone_client.o -L$(LIBDIR) -lpecon_client

standalone_client.o: standalone_client.c
	gcc -I$(INCDIR) -c $(CFLAGS) standalone_client.c

twice_server: twice_server.o
	gcc -o twice_server twice_server.o -L$(LIBDIR) -lpecon_server

twice_server.o: twice_server.c
	gcc -I$(INCDIR) -c $(CFLAGS) twice_server.c

clean:
	rm -f $(ALL) *.o *.log *.*~

nolog:
	rm -f *.log

kill:
	pkill twice_server

backup:
	cp *.c bak
	cp Makefile bak
	cp README bak
