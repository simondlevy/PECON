% Private utility function for PECON
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

function argout = chkserv(p, f, servers, servargs, servnargout, results, argix)

argout = {};

% check for complete server failure; compute serially if tolerant
if length(servers) < 1
    
    if p.tolerant
        
        fprintf('No servers available; computing serially...\n')
        
        % special-case evaluation of no-output functions
        if nargout(f) < 1
            for i = argix:size(servargs, 1)
                evalfun(f, servargs(i,:));
            end
        else
            
            for i = argix:size(servargs, 1)
                results(i,:) = evalfun(f, servargs(i,:));
            end
            
            % fill  output arguments with results
            argout = results2varargout(results, servnargout);
        end
        
    else
        error('No servers available')
    end
    
end
