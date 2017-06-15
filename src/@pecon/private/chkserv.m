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
