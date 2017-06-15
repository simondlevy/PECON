% GA fitness function
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
 
ffunction f = fitness(phi)

ics = unif(300, 149);

for i = 1:size(ics, 1)

  niter = 320 + fix(randn*10);
  ic = ics(i,:);
  a = ca(phi, ic, niter); 
  rho = sum(ic) / length(ic);
  s = a(end,:);
  frac = sum(s) / length(s);

  if rho > 0.5
    f(i) = frac;
  else
    f(i) =  1 - frac;
  end

end

f = mean(f);


