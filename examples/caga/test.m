% Cellular automaton test script
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

tic

n = 149;

r = 3;

for i= -r:r
   neighbors(:,i+r+1) = (mod([0:n-1]+i, n)+1);
end

powers = repmat(pow2([0:2*r]), n, 1);

for i = 1:1000
  phi = unif(128);
  ic = unif(149);
  ca(phi, ic, 100, n, r, neighbors, powers);
end
toc
