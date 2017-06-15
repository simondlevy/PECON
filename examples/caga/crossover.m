function c = crossover(p1, p2)

n = randindex(p1);

c = [p1(1:n) p2(n+1:end)];

