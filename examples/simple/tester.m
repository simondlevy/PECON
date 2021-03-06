% Wrapper function for summed-square-root parallelization tester
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

function tester(p, m, n)
% TESTER(P, M, N) uses PECON object P to run M iterations of the SUMSQRT
% function on N numbers.  Reports serial execution time, parallel (PECON)
% execution time, and speedup.
% 
% Example:
%
%    >> p = pecon;
%    >> tester(p, 24, 2e7)

fprintf('Evaluating serially ...')
tic
for i = 1:m
    sumsqrt(n);
end
stime = toc;

fprintf('\nEvaluating in parallel ...')
tic
feval(p, @sumsqrt, num2cell(n*ones(1,m)));
ptime = toc;

fprintf('\nSerial: %f sec\tParallel: %f sec\tSpeedup: %f\n', ...
    stime, ptime, stime/ptime)

