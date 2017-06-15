/*
 Common code for client and server

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

import java.util.Date;

class ClientServer {

    private ObjectOutputStream out;
    private ObjectInputStream in;

    private int entryID;

    protected void sendChars(char [] c) throws Exception {

        try {
	    out.writeObject(new String(c));
	    out.flush();
	}
	
        catch (Exception e) {
	    throw e;
        }
    }

    protected char [] receiveChars() 
	throws IOException, ClassNotFoundException {

	String s = null;

        try {
	    s = (String)in.readObject();
	}
	
        catch (IOException e) {
	    throw(e);
        }

	if (s == null) return null;

	char [] c = new char [s.length()];

	s.getChars(0, s.length(), c, 0);

	return c;
    }


    protected void sendDoubles(double [][] d) throws Exception {

        try {
	    out.writeObject(d);
	    out.flush();
	}
	
        catch (Exception e) {
	    throw e;
        }
    }

    protected double [][] receiveDoubles() 
	throws IOException, ClassNotFoundException {

	double [][] retval = null;

        try {
	    retval = (double [][])in.readObject();
	}
	
        catch (IOException e) {
	    throw(e);
        }

	return retval;
    }

    // Closes input and output channels.
    protected void close() throws IOException {
	try {
	    out.close();
	    in.close();
	}
        catch (IOException e) {
	    throw(e);
        }
    }

    // Initializes input and output streams.
    protected void getInOut(Socket socket) throws IOException {
	out = new ObjectOutputStream(socket.getOutputStream());
	in = new ObjectInputStream(socket.getInputStream());
    }
}
