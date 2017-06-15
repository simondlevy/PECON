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
