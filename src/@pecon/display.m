function display(p)

fprintf('verbose: %s\n', bool2str(p.verbose))
fprintf('tolerant: %s\n', bool2str(p.tolerant))
fprintf('nice: %d\n', p.nice)

for i = 1:length(p.servers)
  server = p.servers{i};
  fprintf('Server %s (port %d): ', server.hostname, server.port)

  if ready(server)  
    fprintf('ready\n')
  else
    fprintf('not ready\n')
  end
end

