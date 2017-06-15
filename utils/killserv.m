function killserv(hosts, varargin)
% KILLSERV kill Matlab processes running on named hosts.
%     KILLSERV(HOSTS) kills any of your processes named MATLAB
%     running on machines specified in cell array HOSTS.  This command
%     is useful when an unhandled exception in PECON leaves servers
%     running on other hosts.
%


for i = 1:length(hosts)
  host = hosts{i};
  shlcmd = sprintf('ssh %s "pkill -u %s MATLAB"', host, getenv('USER'));
  result = unix(shlcmd);
  if result
    fprintf('No process killed on host %s\n', host)
  else
    fprintf('Killed process on host %s\n', host)
  end
end

