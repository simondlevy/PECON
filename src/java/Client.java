/*
 Java client code for PECON

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

import java.io.*;
import java.net.*;
import org.xml.sax.helpers.XMLReaderFactory;
import org.xml.sax.InputSource;

/**
 * Client - sends objects to, and receives their results from, Server,
 * via sockets.
 */

public class Client extends ClientServer {

    private String hostname;
    private int port;
    private Socket socket;

    /**
     * Creates a Client on specified host and port, without opening
     * sockets.
     * @param hostname name of host server to connect to
     * @param port number of port on which host is accepting socket calls
     */
    public Client(String hostname, int port) {
	
	this.hostname = hostname;
	this.port = port;
    }

    /**
     * Attempts to connect to server host.  
     * @return true on success, false on ConnectException
     * @throws UnknownHostException, IOException on failure
     */
    public boolean connect() throws UnknownHostException, IOException {

        try {
            socket = new Socket(hostname, port);
	    getInOut(socket);
	}
	catch (ConnectException e) {
	    return false;
        } catch (UnknownHostException e) {     
	    throw(e);
        } catch (IOException e) {
	    throw(e);
        }
	return true;
    }

    /**
     * Sends an array of characters to the server.
     * @param c the character array
     * @throws Exception on failure  
     */
    public void sendChars(char [] c) throws Exception {
	super.sendChars(c);
    }

    /**
     * Receives an array of characters from server.  
     * @return the character array
     * @throws IOException, ClassNotFoundException on failure  
     */
    public char [] receiveChars() 
	throws IOException, ClassNotFoundException {
	return super.receiveChars();
    }

    /**
     * Sends a two-dimensional array of double-precision floats to the
     * server.
     * @param d the doubles array
     * @throws Exception on failure  
     */
    public void sendDoubles(double [][] d) throws Exception {
	super.sendDoubles(d);
    }

    /**
     * Receives an array of double-precision floats from server.  
     * @return the doubles array
     * @throws IOException, ClassNotFoundException on failure  
     */
    public double [][] receiveDoubles() 
	throws IOException, ClassNotFoundException {
	return super.receiveDoubles();
    }

    /**
     * Sends "done" message to server as empty string
     * @throws IOException on failure
     */
    public void sendDone() throws Exception {

	try {
	    sendChars(new char [0]);

        } catch (Exception e) {
	    throw(e);
        }
    }

    /** 
     * Closes the input and output channels for this Client.
     * @throws IOException on failure  
     */
    public void close() throws IOException {

	try {
	    super.close();
	    socket.close();

        } catch (IOException e) {
	    throw(e);
        }
    }

    /** 
     * Returns the state of the Client.
     * @return true if Client is ready, false otherwise
     */
    public boolean ready()  {
	return !socket.isClosed();
    }

    /**
     * Tests Client class.  Usage: java Client <hostname> [port]
     */
    public static void main(String [] args) {
	
	if (args.length < 1) {
	    System.err.println("Usage: java Client <hostname> [port]");
	}

	int port = 28000;

	int size = 800;

	Client [] c = new Client [args.length];

	double [][] a = new double [size][size];

	for (int j=0; j<size; ++j) {
	    for (int k=0; k<size; ++k) {
		a[j][k] = Math.random();
	    }
	}


	for (int i=0; i<args.length; ++i) {

	    String hostname = args[i];
	
	    c[i] = new Client(hostname, port);

	    try {
		c[i].connect();
	    }
	    catch (Exception e) {
		System.err.println(e);
	    }
	}

	for (int i=0; i<c.length; ++i) {

	    try {
		c[i].sendDoubles(a);
	    }
	    catch (Exception e) {
		System.err.println(e);
	    }
	}
	for (int i=0; i<c.length; ++i) {

	    try {
		double [][] b = c[i].receiveDoubles();
		System.out.println(b.length + " " + b[0].length);
	    }
	    catch (Exception e) {
		System.err.println(e);
	    }
	}
    }

}
