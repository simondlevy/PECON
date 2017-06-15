% Display function for PECON objects
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

