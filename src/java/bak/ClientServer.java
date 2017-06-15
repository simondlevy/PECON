// common code for client and server

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
	    out.writeObject(new DoubleMatrix(d));
	    out.flush();
	}
	
        catch (Exception e) {
	    throw e;
        }
    }

    protected double [][] receiveDoubles() 
	throws IOException, ClassNotFoundException {

	DoubleMatrix dm = null;

        try {
	    dm = (DoubleMatrix)in.readObject();
	}
	
        catch (IOException e) {
	    throw(e);
        }

	if (dm == null) return null;

	return dm.getValues();
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
