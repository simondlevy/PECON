# PECON
Parallel Evaluation CONntroller: Run Matlab in Parallel on your Multicore PC or Unix Cluster


PECON (Parallel Evaluation CONtroller) is a very small, easy-to-use
Matlab class library that simplifies the task of parallelizing
existing Matlab programs.  PECON exploits Matlab's Java Virtual
Machine to pass XML-encoded data structures between a central client
and several "compute servers", thereby avoiding reliance on
lower-level message-passing 
<a href="http://en.wikipedia.org/wiki/Message_Passing_Interface">software</a>.  
If you've already obtained some speedup by using Mex, PECON's Mex parallelization
libraries may also help you get additional speedup.

PECON works on a multiprocessor machine (Windows, Mac OS X, Linux) or a 
network running Unix, such as a
Beowulf cluster.  All
processors must have access to the same file system. You must have version 6 
or later of Matlab installed on this file system, and socket calls must be 
enabled -- i.e., there must be no firewall on the servers, or the firewall must
be configured to enable the port used by Pecon (default 28000).

To try out PECON, download and unzip the file 
<a href="pecon.zip">pecon.zip</a>.  Then download 
<a href="http://www.mathworks.com/matlabcentral/fileexchange/6268">
XML4MAT</a> and unzip its contents in a new folder. Modify your
startup.m file reflect where you put the resulting files. 
For example, my startup.m contains the lines
<pre>
  PECON_DIR = '/Users/levys/Documents/pecon';
  addpath /Users/levys/Documents/XML4MATv2
  addpath([PECON_DIR '/src']);
  javaaddpath([PECON_DIR '/lib/ClientServer.jar']);
</pre>

Then launch Matlab.  

The simplest way to launch PECON is on a multiprocessor or multicore machine:

<pre>
  >> p = pecon;
</pre>

which on a two-core machine is equivalent to 

<pre>
  >> p = pecon('servers', {'localhost', 'localhost'});
</pre>

and will cause Matlab to resond with 

<pre>

  Checking host localhost ... okay

  Checking host localhost ... okay

  Connecting to server localhost on port 28000...connection established

  Port 28000 already bound on host localhost. Using port 28001

  Connecting to server localhost on port 28001...connection established

</pre>

To run PECON on a Unix cluster or network, you'll need to know the names of some 
hosts (nodes) to which you can ssh from the node on which you're running (because PECON
automatically calls ssh to run Matlab remotely on the nodes).  You must be able 
to ssh to all the hosts that you wish to use,
without having to enter a password.  In order to do this, run the following
commands from your home directory:

<pre>

  % ssh-keygen -trsa 

  (hit return to use defaults; including no passphrase)

  % cd .ssh

  % cp id_rsa.pub authorized_keys

</pre>

Let's
say you have three such nodes, named alpha, bravo, and charlie.  
You can then issue the following instructions in Matlab.

<pre>

  >> p = pecon('servers', {'alpha', 'bravo', 'charlie'})

</pre>

After a brief startup period, Matlab should respond with

<pre>

  Server alpha: ready

  Server bravo: ready

  Server charlie: ready

</pre>

<p>

Once you've launched PECON you can then try (trivial) parallel evaluation of a 
function by doing

<pre>

  >> feval(p, @plus, {1, 3, 5, 7, 9, 11, 13, 15}, {0, 2, 4, 6, 8, 10, 12, 14})

</pre>

Matlab should respond with

<pre>

  ans = 



    [1]

    [5]

    [9]

    [13]

    [17]

    [21]

    [25]

    [29]

</pre>

You can shut down the servers by 

<pre>

  >> halt(p)

</pre>

If anything goes wrong (like <tt>feval</tt> hanging forever), kill the current command 
and re-initialize pecon with the <tt>verbose</tt> flag set to <tt>true</tt>:

<pre>

  >> p = pecon('verbose',true);

</pre>

Doing this will give you a better idea of what's going wrong, and how to fix it.


Now you are ready to use PECON to parallelize existing Matlab functions.
The <b>utils</b> directory contains a few utility functions for killing
errant servers, and partitioning and re-assembling matrices. The <b>exmaples/simple</b> directory
contains a little <b>tester.m</b> function that provides an estimate of the speedup you can expect.

<p>

Note that PECON provides no mechanism for handling errors on the compute servers;
behavior after a server error can become unstable.  So <b>you
should make sure to test each function on the client side</b> (ordinary Matlab)
before proceeding.  Also, PECON's <tt><b>feval</b></tt> function is strict
about the number of input arguments to the function being evaluated. Hence, if
you are calling <tt><b>feval</b></tt> on polymorphic functions like <tt><b>max</b></tt>,
you should write a wrapper function that accepts a specific number of arguments:

<pre>

  function res = mymax(x)

  res = max(x);

</pre>

<p>

If you are a C programmer and have used Mex to accelerate your Matlab project, PECON supports parallelizing C code
as well.  Look at the code in pecon/examples/mex to get started.  You can even use pecon without Matlab, as
shown in pecon/examples/standalone, but in that case it would probably be better to work with a standard tool like 
MPI.

<p>

The technical paper describing PECON is available 

<a href="http://home.wlu.edu/~levys/publications/#pdcs2006">here</a>.

Please e-mail <a href="mailto:simon.d.levy@gmail.com">simon.d.levy@gmail.com</a> with any question or complaints.  Enjoy!
