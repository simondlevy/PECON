# Makefile for PECON Java classes
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
