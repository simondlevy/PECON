% Compare ordinary vs parallel GA execution
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

servers = oknodes;

for i = 6:-1:2
  fprintf('\n%d NODES\n', i)
  p = pecon({servers{1:i}});
  for j = 1:5
    caga(1, p);
  end
  halt(p)
end

fprintf('SERIAL:\n')

for j = 1:5
  caga(1);
end

