%
% CALLED AUTMOATICALLY BY PECON - DO NOT CALL DIRECTLY
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

function results = evalfun(funname, funargs)

% get number of output arguments for named function
funnargout = nargout(funname);

% special-case evaluation of no-output functions
if funnargout < 1
    
    eval('feval(funname, funargs{:});');
    results = {};
    
else
    
    % build up a left-hand-side [r1,r2,..,rn] to catch output
    res = '[';
    for i = 1:funnargout-1
        res = strcat(res, sprintf('r%d,', i));
    end
    res = strcat(res, sprintf('r%d]', max(funnargout, 1)));
    
    try
        
        % evaluate function, getting output
        eval([res ' = feval(funname, funargs{:});']);
        
        % parse output arguments to cell array
        for i = 1:max(funnargout, 1)
            eval(sprintf('results{%d} = r%d;', i, i));
        end
        
    catch exception
        
        % write to log file
        fprintf('*** %s\n', getReport(exception)) 
        
        % send special result value indicating failure
        for i = 1:max(funnargout, 1)
            results{i} = '???';
        end
    end
    
end


