function yn = isbound(host, port)

% XXX port could be bound on host without accepting sockets, so we
% should use some other test

yn = true;

try
  java.net.Socket(host, port);
catch
  yn = false;
end

