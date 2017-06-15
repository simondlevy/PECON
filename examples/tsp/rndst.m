% Random Distance matrix
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

function d = rndst(n)
% RNDST - Random Distance matrix
%
% D = RNDST(N) returns an NxN matrix D of random distances in the
% interval (0, 1).  D(I,I) = 0; D(I,J) = D(J,I)

d = triu(rand(n)) .* ~diag(ones(1, n), 0);
d = d + d';
