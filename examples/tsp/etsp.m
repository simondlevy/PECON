% Exhaustive-search Traveling Salesman Problem 
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

function [trip,minlen] = etsp(d, k, n)
% ETSP - Exhaustive-search Traveling Salesman Problem 
%
%  [TRIP,LEN] = ETSP(D) solves the Traveling Salesman Problem using
%  exhaustive search on distance matrix D.  TRIP contains the trip
%  with minimum length LEN.
%
%  ETSP(D, K, N) searches only within the Kth of N contiguous block of
%  permutations.
%
%  See also RANDIST, GTSP, PETSP

% mark diagonal visited to avoid self-visits
d(find(d == 0)) = Inf;

% matrix of permutations
p = perms(1:length(d));

% determine beginning, ending permutations from K, N args
pmax = size(p, 1);
if nargin > 2
  blocksize = fix(pmax / n) + 1;
  pbeg = (k-1) * blocksize + 1;
  pend = min(pmax, k * blocksize);
  
% default to all permutations  
else
  pbeg = 1;
  pend = pmax;
end


% start timing
tic

% evaluate all permutations to find minimum length
minlen = Inf;
for i = pbeg:pend
  len = 0;
  t = p(i,:);
  for j = 2:length(t)
    len = len + d(t(j-1), t(j));
  end
  if len < minlen
    minlen = len;
    trip = t;
  end
end

% report total time
toc
