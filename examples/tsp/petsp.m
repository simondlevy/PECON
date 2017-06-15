% Parallel Exhaustive-search Traveling Salesman Problem 
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


