function yn = ready(server)
% check remote Matlab process still running and Java server ready

cmd = ['ssh ' server.hostname ...
       ' "pgrep -f ''server\(' num2str(server.port) '''"'];

[s,w] = unix(cmd);

yn = (prod(size(w)) > 0) & server.client.ready;
