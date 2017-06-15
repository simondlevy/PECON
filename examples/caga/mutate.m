function y = mutate(x, mu)

y = xor(x, rand(1,length(x)) < mu);

