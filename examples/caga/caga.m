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
