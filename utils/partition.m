% Partition a 2D matrix into rectangular submatrices
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

function b = partition(a, np)
% PARTITION  partition a 2D matrix into rectangular submatrices.
%    PARTITION(A, NP) partitions 2D matrix A into NP^2 rectangular
%    submatrices. The submatrices are returned in a cell array, which
%    can then be passed as an input argument to PECON/FEVAL.  If
%    SIZE(A)/NP does not yield whole numbers, the submatrices will
%    overlap each other.
%
%    See also ASSEMBLE.

m = round(size(a, 1) / np);
n = round(size(a, 2) / np);

k = 1;

for i = 1:np
  for j = 1:np
    ilo = (i-1) * m + 1;
    ihi = ilo + m - 1;
    jlo = (j-1) * n + 1;
    jhi = jlo + n - 1;
    b{k} = a(ilo:ihi, jlo:jhi);
    k = k + 1;
  end
end


