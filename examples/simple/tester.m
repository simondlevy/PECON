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

