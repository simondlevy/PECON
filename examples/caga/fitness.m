function f = fitness(phi)

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


