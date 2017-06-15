function [trip,len] = gtsp(d)
% GTSP - Greedy-search Traveling Salesman Problem 
%
%  [TRIP,LEN] = GTSP(D) solves the Traveling Salesman Problem using
%  greedy search on distance matrix D.  TRIP contains the trip
%  with minimum length LEN.
%
%  See also RNDST, ETSP, PETSP

% mark diagonal visited to avoid self-visits
d(find(d == 0)) = Inf;

trip = [];
len = 0;

% start at a random city
i = fix(rand*length(d)) + 1;

while true
  trip(end+1) = i;
  j = find(d(i,:) == min(d(i,:)));
  if length(j) > 1, break, end
  len = len + d(i,j);
  d(:,i) = Inf; % mark visited
  i = j;
end
