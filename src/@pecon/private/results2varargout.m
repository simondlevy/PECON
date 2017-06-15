function argout = results2varargout(results, servnargout)
% fill variable-length output arguments with results

argout = {};

for i = 1:max(servnargout, 1)
    arg =  results(:,i);
    if ~strcmp(arg, '???')
        argout{end+1} = arg;
    end
end
