% Genetic algorithm example for PECON
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
 
function pop = caga(ngen, pobj)

MU = 0.01;

rand('seed', 0)
randn('seed', 0)

pop = num2cell(unif(100, 128), 2);

tic

for i = 1:ngen

  if nargin > 1
    fits = feval(pobj, 'fitness', pop);
  else
    for j=1:length(pop)
       fits{j} = fitness(pop{j});
       fprintf('%d / %d : %f\n', j, length(pop), fits{j})
    end
  end 

  fprintf('Gen: %5d \t AvgFit: %6.6f\n', i, mean(cell2mat(fits)))

  [dummy,indices] = sort(cell2mat(fits));

  newpop = {pop{indices(length(indices)/2+1:end)}};

  while length(newpop) < length(pop) 

    parent1 = pickrand(pop);
    parent2 = pickrand(pop);

    child = crossover(parent1, parent2);

    child = mutate(child, MU);

    newpop{end+1} = child; 

  end

  pop = newpop; 

end

toc
