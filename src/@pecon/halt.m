% Halting function for PECON
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

function halt(p)
% HALT - Shut down PECON servers
%
%   HALT(P) shuts down servers associated with PECON object P.

for h = 1:length(p.servers)
    server = p.servers{h};
    fprintf('Shutting down server %s\n', server.hostname)
    try
        server.client.sendDone
        server.client.close
    catch err
        msg = sprintf('Communication with server %s failed; %s', ...
            server.hostname, getReport(err));
        if p.tolerant
            if p.verbose
                warning('%s', msg)
            end
        else
            error('%s', msg)
        end
    end
end

