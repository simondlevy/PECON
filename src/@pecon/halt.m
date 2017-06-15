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

