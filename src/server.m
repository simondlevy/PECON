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

function server(port)

% create Java Server object
s = Server(port);

% run until HALT signal received, evaluating function calls
while true
    
    try
        
        % get message from client
        msg = s.receiveChars;
        
        % empty message is HALT signal
        if isempty(msg), break, end
        
        % get function name
        funname = char(msg');
        
        % get input argument count
        servnargin = str2double(char(s.receiveChars'));
        
        % report to log file
        fprintf('funname: %s\tservnargin: %d\n', funname, servnargin)
 
        % parse function arguments to cell array
        funargs = cell(1,servnargin);
        for j = 1:servnargin
            
            % client tells us whether / how many matrix elements to expect
            if str2double(char(s.receiveChars'))
                funargs{j} = s.receiveDoubles;
            else
                funargs{j} = xml2mat(char(s.receiveChars'));
            end
        end
        
        % compute results
        results = evalfun(funname, funargs);
        
        % send cell array of results to client
        for j = 1:nargout(funname)
            
            result = results{j};
                        
            % tell client whether / how much matrix data to receive
            s.sendChars(num2str(isfloat(result)));
            if isfloat(result)
                s.sendDoubles(result);           % send it as a double array
            else
                s.sendChars(mat2xml(result));    % send it as an XML string
            end
        end
        
    catch exception
        fprintf('%s\n', getReport(exception))
        s.close
        exit
    end
    
end % while true

s.close

exit
