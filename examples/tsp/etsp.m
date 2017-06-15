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
