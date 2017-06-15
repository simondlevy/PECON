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

