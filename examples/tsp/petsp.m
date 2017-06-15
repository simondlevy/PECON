function [trip,minlen] = petsp(d, p)
% PETSP - Parallel Exhaustive-search Traveling Salesman Problem 
%
%  [TRIP,LEN] = ETSP(D, P) uses PECON object P to solve the Traveling
%  Salesman Problem in parallel, using exhaustive search on distance
%  matrix D.  TRIP contains the trip with minimum length LEN.
%
%  See also RANDIST, GTSP, ETSP, PECON, HALT

% set up arguments to ETSP as cell arrays
for i = 1:size(p)
  arg1{i} = d;         % distance matrix
  arg2{i} = i;         % rank of each server
  arg3{i} = size(p);   % number of servers
end

% start timing
tic

% solve in parallel, getting a minimum length from each server
[trips,lens] = feval(p, 'etsp', arg1, arg2, arg3);

% find minimum of minima and one trip associated with it
lens = cell2mat(lens);
minlen = min(lens);
minix = find(lens==minlen);
trip = trips{minix(1)};

% report total time
toc


