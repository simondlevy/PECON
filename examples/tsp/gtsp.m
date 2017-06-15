% Greedy-search Traveling Salesman Problem 
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
