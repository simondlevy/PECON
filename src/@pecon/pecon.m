function  result = pecon(varargin)
% PECON - Parallel Evaluation CONtroller
%
%   PECON([OPTIONS]) creates a PECON object for parallel function
%   evaluation.  OPTIONS are
%
%     'SERVERS', <LIST_OF_SERVERS>   [default = localhost] *
%
%     'PORT', <PORTNUMBER>   [default = 28000], currently *
%
%     'VERBOSE', <VERBOSE> display messages to/from servers [default = false]
%
%     'TOLERANT', <TOLERANT> tolerate server failure [default = true]
%
%     'NICE', <NICENESS> run in "nice" mode with level <NICENESS> [default= 0] *
%
%   Examples:
%
%     >> p = pecon
%
%     >> p = pecon('servers', {'alpha', 'bravo', 'charlie', 'delta', 'echo'})
%
%   See also FEVAL, HALT, SET
%
%   * Currently unavailable on Windows

% how many ports to try before failing
MAX_TRY_PORTS = 100;

% defaults
servers = {};
port = 28000;
verbose = false;
tolerant = true;
nice = 0;

% set attributes
[servers, port, result.verbose,result.tolerant,result.nice] = ...
    getopts(varargin, {'servers', 'port', 'verbose', 'tolerant', 'nice'}, ...
    {servers, port, verbose, tolerant,nice});

% assume remote servers
uselocal = false;

% assume *nix
slash = '/';

% default to localhost if servers unspecified
if isempty(servers)
    
    % determine number of cores via shell command
    if ismac
        [~,ncores] = unix('sysctl hw.ncpu  | awk ''{print $2}''');
    elseif ispc
        ncores = getenv('NUMBER_OF_PROCESSORS');
        slash = '\';
    else
        [~,ncores] = unix('grep "processor" /proc/cpuinfo | wc -l');
    end
        
    ncores = str2double(ncores);
        
    for k = 1:ncores
        servers{k} = 'localhost';
    end
    
    uselocal = true;
    
elseif ispc
    
    error('SERVERS option unavailable on Windows')
    
end


% check server availability
okservers = servers;
for h = 1:length(servers)
    
    host = servers{h};
    
    % always check first host; then check subsequent hosts unless local
    if ~ispc && (h == 1 || ~uselocal)
        
        fprintf('Checking host %s ... ', host)
        
        [s,~] = unix(sprintf('ssh %s which matlab', host));
        
        if s
            msg = sprintf('Host %s is unavailable or cannot run Matlab', host);
            if result.tolerant
                fprintf('%s\n', msg)
                okservers(h) = [];
            else
                error('%s', msg)
            end
        else
            fprintf('okay\n')
        end
        
    end
    
end

if isempty(okservers)
    error('No servers available')
end


% launch servers on specified hosts
k = 1;
for h = 1:length(okservers)
    
    host = okservers{h};
    
    serv.port = port;
    
    % tolerance supports search for open ports
    if isbound(host, port)
        msg = sprintf('Port %d already bound on host %s', serv.port, host);
        if result.tolerant
            begport = port;
            endport = port + MAX_TRY_PORTS;
            for sport = begport:endport
                if ~isbound(host, sport)
                    fprintf('\n%s. Using port %d\n', msg, sport);
                    serv.port = sport;
                    break
                end
            end
        else
            error('%s', msg)
        end
    end
    
    
    serv.hostname = host;
    
    [~,loghost] = system('hostname');
    
    % truncate final linefeed
    loghost = loghost(1:end-1);
    
    logfilename = [pwd slash loghost '_' num2str(h) '.log'];
    
    fprintf('Connecting to server %s on port %d with logfile %s ...', host, serv.port, logfilename)
    
    serv.logfilename = logfilename;
    
    % support optional startup.m
    startupcmd = 'startup';
    if ~exist('startup.m', 'file')
        if result.verbose
            warning('No startup.m found; assuming paths have been set properly')
        end
        startupcmd = '';
    end
    
    % launch Matlab remotely, running server code and dumping to log
    % file named according to remote host
    
    matcmd = sprintf('cd %s, %s, server(%d)', pwd, startupcmd, serv.port);
    
    if ispc
        
        shlcmd = sprintf('start /Min /B matlab -automation -r "%s" > %s', ...
            matcmd, logfilename);
    else
        
        shlcmd = sprintf('ssh -n %s "nice -n %d matlab -nodisplay -r ''%s'' > %s" &', ...
            host, nice, matcmd, logfilename);
    end
    
    system(shlcmd);
    
    % launch a client to get values back from server
    
    serv.client = javaObject('Client', host, serv.port);
    
    % open connection to server
    while true
        if serv.client.connect, break, end
    end
    
    fprintf('connection established\n')
    result.servers{k} = serv;
    k = k + 1;
    
    % for multicore, always look at next server
    if uselocal
        port = port + 1;
    end
    
end

result = class(result, 'pecon');
