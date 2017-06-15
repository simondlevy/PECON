function d = rndst(n)
% RNDST - Random Distance matrix
%
% D = RNDST(N) returns an NxN matrix D of random distances in the
% interval (0, 1).  D(I,I) = 0; D(I,J) = D(J,I)

d = triu(rand(n)) .* ~diag(ones(1, n), 0);
d = d + d';
