% Random-bits function
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
