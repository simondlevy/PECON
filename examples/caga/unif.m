function bits = unif(m, n)
% UNIF  Uniformly distributed random bits
%
%   BITS = UNIF(M, N) returns an MxN matrix of BITS, where the bits in
%   each row are uniformly distributed.  This means that a given row
%   is just as likely to contain all zeros as it is to contain half
%   zeros and half ones.  Simply picking random bits would result in a
%   Gaussian (non-uniform) distribution of this zero/one ratio.  Such
%   a distribution would not contain enough "extreme" cases to support
%   general learning of by a genetic algorithm (for example).

if nargin < 2
  n = m;
  m = 1;
end

for i = 1:m
  bits(i,:) = rand(1,n) > rand;
end
