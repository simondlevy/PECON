# This should be where you installed Pecon
PECON_DIR = /Users/levys/pecon/

# User these for 64-bit OS X
ARCH = maci64
EXT = maci64
CFLAGS_ARCH = -fno-common -no-cpp-precomp -arch x86_64 -isysroot /Developer/SDKs/MacOSX10.6.sdk \
    -mmacosx-version-min=10.5 -fexceptions -O2 
LFLAGS_ARCH = -Wl,-twolevel_namespace -undefined error -arch x86_64 \
              -Wl,-syslibroot,/Developer/SDKs/MacOSX10.6.sdk \
              -mmacosx-version-min=10.5 -bundle \
              -Wl,-exported_symbols_list,$(MATLAB)/extern/lib/$(ARCH)/mexFunction.map


# Use these for 64-bit Linux
#ARCH = glnxa64
#EXT = a64
#CFLAGS_ARCH = -ansi -D_GNU_SOURCE  -fexceptions -fPIC -fno-omit-frame-pointer -pthread -O
#LFLAGS_ARCH = -pthread -shared \
              -Wl,--version-script,$(MATLAB)/extern/lib/$(ARCH)/mexFunction.map \
              -Wl,--no-undefined \
              -Wl,-rpath-link,$(MATLAB)/bin/$(ARCH) 

MEX =  twice_client.mex$(EXT)
CFLAGS = -Wall -I$(MATLAB)/extern/include -DMATLAB_MEX_FILE -DNDEBUG  -DMX_COMPAT_32 $(CFLAGS_ARCH)
LFLAGS = -O $(LFLAGS_ARCH)

ALL = twice_client.mex$(EXT) twice_server

all: $(ALL)

twice_client.mex$(EXT): twice_client.o
	gcc $(LFLAGS) -o twice_client.mex$(EXT) twice_client.o -L$(PECON_DIR)/lib -lpecon_client \
          -L$(MATLAB)/bin/$(ARCH) -lmx -lmex -lmat -lm -lstdc++

twice_client.o: twice_client.c
	gcc -c -I$(PECON_DIR)/include $(CFLAGS) -DPECON_DIR=\"$(PECON_DIR)\" twice_client.c

twice_server: twice_server.o
	gcc -o twice_server twice_server.o -L$(PECON_DIR)/lib -lpecon_server

twice_server.o: twice_server.c
	gcc -I$(PECON_DIR)/include -c $(CFLAGS) twice_server.c

clean:
	rm -f $(ALL) *.o *.asv *.mex* *.log *.*~ *~

nolog:
	rm -f *.log

kill:
	pkill twice_server

backup:
	cp *.m bak
	cp *.c bak
	cp Makefile bak
