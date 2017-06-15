ALL =  standalone_client twice_server
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
