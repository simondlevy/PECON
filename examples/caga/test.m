tic

n = 149;

r = 3;

for i= -r:r
   neighbors(:,i+r+1) = (mod([0:n-1]+i, n)+1);
end

powers = repmat(pow2([0:2*r]), n, 1);

for i = 1:1000
  phi = unif(128);
  ic = unif(149);
  ca(phi, ic, 100, n, r, neighbors, powers);
end
toc
