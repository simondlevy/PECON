% Assemble a cell array of submatrices into a single 2D matrix.
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


function a = assemble(c, np)
% ASSEMBLE  assemble a cell array of submatrices into a single 2D matrix.
%    ASSEMBLE(C, NP) assembles a cell array C of NP^2 rectangular
%    submatrices into a single 2D matrix, which it returns.  This
%    function is designed to work in conjunction with PECON/FEVAL,
%    when the latter is called with a partitioned matrix as an
%    argument.  For example, assuming P is a PECON object and A a
%    large matrix of numbers:
%
%      >> b = partition(a, 10); 
%      >> c = feval(p, @sqrt, b);
%      >> d = assemble(c, 10);
%
%    If C does not contain exactly NP^2 submatrices, or if the
%    submatrices differ in size, the behavior of ASSEMBLE is undefined.    
%
%    See also PARTITION.

m = size(c{1}, 1);
n = size(c{1}, 2);

a = zeros(m*np, n*np);

k = 1;

for i = 1:np
  for j = 1:np
    ilo = (i-1) * m + 1;
    ihi = ilo + m - 1;
    jlo = (j-1) * n + 1;
    jhi = jlo + n - 1;
    a(ilo:ihi, jlo:jhi) = c{k};
    k = k + 1;
  end
end


