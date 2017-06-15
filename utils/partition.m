function b = partition(a, np)
% PARTITION  partition a 2D matrix into rectangular submatrices.
%    PARTITION(A, NP) partitions 2D matrix A into NP^2 rectangular
%    submatrices. The submatrices are returned in a cell array, which
%    can then be passed as an input argument to PECON/FEVAL.  If
%    SIZE(A)/NP does not yield whole numbers, the submatrices will
%    overlap each other.
%
%    See also ASSEMBLE.

m = round(size(a, 1) / np);
n = round(size(a, 2) / np);

k = 1;

for i = 1:np
  for j = 1:np
    ilo = (i-1) * m + 1;
    ihi = ilo + m - 1;
    jlo = (j-1) * n + 1;
    jhi = jlo + n - 1;
    b{k} = a(ilo:ihi, jlo:jhi);
    k = k + 1;
  end
end


