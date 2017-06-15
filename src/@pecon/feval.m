% Evaluation function for PECON
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

function varargout = feval(p, f, varargin)
% FEVAL - Execute the specified function in parallel using PECON
%
%   FEVAL(P, F, x1, ..., xn) uses PECON object P to evaluate the
%   function specified by a function name (or handle) F, at the given
%   arguments, x1,...,xn.  Each x should be a cell array containing
%   the same number of elements as the other x's. Arguments are
%   distributed to servers round-robin.
%
%   [y1,..,yn] = FEVAL(F,x1,...,xn) returns multiple cell arrays of
%   output arguments.
%
%   Example:
%
%     s = feval(pobj, @sqrt, {0, 1, 4, 9, 16, 25, 36, 49, 64, 81});
%
%     See also PECON, SIZE, HALT

% require function arguments
if isempty(varargin)
    error('No input arguments')
end

% convert function handle to string
if isa(f, 'function_handle')
    f = func2str(f);
end

% check function exists
filestat = exist(f);
if filestat ~= 2 && filestat ~= 5
    error('No function %s found in path', f)
end

% check correct number of input arguments
if (nargin-2) ~= nargin(f)
    error('Function %s takes %d input argument(s); %d provided', ...
        upper(f), nargin(f), nargin-2)
end

% check correct number of output arguments
if nargout > nargout(f)
    error('Function %s supports at most %d argument(s); %d requested', ...
        upper(f), nargout(f), nargout)
end

% check no missing args
for i = 2:length(varargin)
    if length(varargin{i}) ~= length(varargin{i-1})
        error('All argument lists must be same length')
    end
end

% reshape arguments for sending to individual servers
servargs = cell(nargin-2, length(varargin));
for i = 1:length(varargin)
    arg = varargin{i};
    for j = 1:length(arg)
        servargs{j,i} = arg{j};
    end
end

% send data to servers
i = 1;
servers = p.servers;
nservargs = size(servargs, 1);
while i <= nservargs && ~isempty(servers)
    
    % round-robin servers to load-balance
    h = mod(i-1, length(servers)) + 1;
    server = servers{h};
    client = server.client;
    
    if p.verbose
        fprintf('Sending arg %d / %d to server %s\n', ...
            i, nservargs, server.hostname)
    end
    
    try
        
        % send function name to server
        client.sendChars(f);
        
        % break out serial arguments
        funargs = servargs(i,:);
        
        % send input arg count to server
        client.sendChars(num2str(length(funargs)));
        
        % send serial arguments to deisgnated server
        for j = 1:length(funargs)
            funarg = funargs{j};
            client.sendChars(num2str(isfloat(funarg)));
            if isfloat(funarg) % is arg a number??
                client.sendDoubles(funarg); % send it as a double array
            else
                client.sendChars(mat2xml(funarg)); % send it as an XML string
            end
            
        end
        
    catch err
        msg = sprintf('Communication with server %s failed: %s', ...
            server.hostname, getReport(err));
        if p.tolerant
            if p.verbose
                fprintf('%s\n', msg)
            end
            i = i - 1;
            servers = [servers(1:h-1) servers(h+1:end)];
        else
            error('%s', msg)
        end
    end
    
    i = i + 1;
    
end

% check for complete server failure
varargout = chkserv(p, f, servers, servargs, nargout, {}, 1);
if nargout(f) < 1 || ~isempty(varargout), return, end

if p.verbose, fprintf('\n'), end

% get results from servers
results = cell(nservargs, nargout(f));
i = 1;
servers = p.servers;
problem = false;

while i <= nservargs
    h = mod(i-1, length(servers)) + 1;
    server = servers{h};
    client = server.client;
    success = true;
    
    % check for complete server failure
    varargout = chkserv(p, f, servers, servargs, nargout, results, i);
    if nargout(f) < 1 || ~isempty(varargout), return, end
    
    % get results from servers
    for j = 1:nargout(f)
        
        try
            if str2double(char(client.receiveChars')); % matrix of doubles
                results{i, j} = client.receiveDoubles;
            else
                results{i, j} = xml2mat(char(client.receiveChars'));
            end
            
        catch err
            msg = sprintf('Communication with server %s problem', ...
                server.hostname, getReport(err));
            if p.tolerant
                if p.verbose
                    fprintf('%s\n', msg)
                end
                i = i - 1;
                servers = [servers(1:h-1) servers(h+1:end)];
                if isempty(servers)
                    halt(p)
                    error('No servers left; halting')
                end
                success = false;
                break
            else
                error('%s', msg)
            end
        end
        
        if strcmp(results{i,j}, '???')
            fprintf('Problem getting result %d from server %s: check log file %s\n', ...
                i, server.hostname, server.logfilename)
            problem = true;
        end
     
    end
    
    if success && p.verbose
        fprintf('Received result %d / %d from server %s\n', ...
            i, nservargs, server.hostname)
    end
    
    i = i + 1;
    
end % while i <= nservargs

% fill variable-length output arguments with results
if nargout(f) > 0
    varargout = results2varargout(results, nargout);
end

% report error if indicated
if problem
    error('PECON/FEVAL encountered a problem')
end



