% Kill Matlab processes running on named hosts.
%
% Copyright (C) 2017 Simon D. Levy
%
% This file is part of PECON.
%
% PECON is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% PECON is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% You should have received a copy of the GNU General Public License
% along with PECON.  If not, see <http://www.gnu.org/licenses/>.

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

