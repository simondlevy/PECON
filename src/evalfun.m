%
% CALLED AUTMOATICALLY BY PECON - DO NOT CALL DIRECTLY
%

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


