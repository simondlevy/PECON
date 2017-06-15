/*
 Java server code for PECON

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

import java.net.*;
import java.io.*;

/**
 * Server - receives objects from client, and sends function
 * evaluations on them to client, via sockets.
 */

public class Server extends ClientServer {

    private ServerSocket serverSocket;
    private Socket clientSocket;

    /**
     * Sends an array of characters to the client.
     * @param c the character array
     * @throws Exception on failure  
     */
    public void sendChars(char [] c) throws Exception {
	super.sendChars(c);
    }

    /**
     * Receives an array of characters from client.  
     * @return the bytes array
     * @throws IOException, ClassNotFoundException on failure  
     */
    public char [] receiveChars() 
	throws IOException, ClassNotFoundException {
	return super.receiveChars();
    }

    /**
     * Sends a two-dimensional array of double-precision floats to the
     * client.
     * @param d the doubles array
     * @throws Exception on failure  
     */
    public void sendDoubles(double [][] d) throws Exception {
	super.sendDoubles(d);
    }

    /**
     * Receives an array of double-precision floats from client.  
     * @return the doubles array
     * @throws IOException, ClassNotFoundException on failure  
     */
    public double [][] receiveDoubles() 
	throws IOException, ClassNotFoundException {
	return super.receiveDoubles();
    }

    /** 
     * Opens a new Server on specified port.
     * @param port the port
     * @throws IOException on failure
     */
    public Server(int port) throws IOException {

        try {
            serverSocket = new ServerSocket(port);
            clientSocket = serverSocket.accept();
	    getInOut(clientSocket);
	}
	
        catch (IOException e) {
	    throw(e);
        }
    }

    /** 
     * Closes the input and output channels for this Server.
     * @throws IOException on failure  
     */
    public void close() throws IOException {
	try {
	    super.close();
	    clientSocket.close();
	    serverSocket.close();
	}
        catch (IOException e) {
	    throw(e);
        }
    }


    /**
     * Tests Server class.  Usage: java Server [port]
     */
    public static void main(String [] args) {

	int port = 28000;

	if (args.length > 0) {
	    port = Integer.parseInt(args[0]);
	}

	try {
  	    Server s = new Server(port);
	    double [][] a = s.receiveDoubles();
	    s.sendDoubles(a);

	}
	catch (Exception e) {
	    System.err.println(e);
	}

    }
}
