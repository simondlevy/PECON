ALL  = Client.class Server.class

ALL = ClientServer.jar

PUB_SRC = Client.java Server.java

CFLAGS = -deprecation

all: $(ALL)

ClientServer.jar: Client.class Server.class ClientServer.class
	jar cvf ../../lib/ClientServer.jar *.class *.java

Server.class : Server.java ClientServer.class
	javac $(CFLAGS) Server.java

Client.class : Client.java ClientServer.class
	javac $(CFLAGS) Client.java

ClientServer.class : ClientServer.java
	javac $(CFLAGS) ClientServer.java

clean:
	rm -f $(ALL) *.class *~ \#*
	rm -rf docs/*

backup:
	cp *.java bak
	cp Makefile bak

jar: $(PUB_SRC)
	make
	jar cvf ../../lib/ClientServer.jar *.class *.java docs

doc: $(PUB_SRC) 
	javadoc -public $(PUB_SRC)
	rm -rf docs/*
	mv *.html docs
	mv stylesheet.css docs
	mv package-list docs
