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

function varargout = getopts(varargs, names, defaults)
% get name/attribute options

for j = 1:length(defaults)
    varargout{j} = defaults{j};
end


for i = 1:length(varargs)
    vararg = varargs{i};
    if ischar(vararg)
        for j = 1:length(names)
            if strcmp(lower(vararg), names{j})
                argval = varargs{i+1};
                if strcmp(argval, 'true')
                    argval = 1;
                elseif strcmp(argval, 'false')
                    argval = 0;
                end
                varargout{j} = argval;
                i = i + 1;
            end
        end
    end
end
