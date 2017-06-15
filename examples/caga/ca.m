function a = ca(phi, ic, m)
% CA  Cellular automaton program
%
%   A = CA(PHI, IC, M) runs M iterations of a one-dimensional
%   cellular automaton algorithm using rule table PHI and initial
%   conditions IC.  PHI is a bit string of size 2^(2R+1), where R
%   is the radius (number of neighbors).   A is an MxN matrix,
%   where N is the size of IC, and each of the M rows represents a
%   single iteration.

% ------------ pre-compute some stuff for efficiency -------------

n = length(ic);

% radius can be computed from size of rule table = 2^(2R+1)
r = (log2(length(phi)) - 1) / 2;

% compute indices of neighbors for each cell (cell is its own neighbor)
for i= -r:r
   nbrs(:,i+r+1) = (mod([0:n-1]+i, n)+1);
end

% build an Nx(2*R+1) matrix of the powers of two
pwrs2 = repmat(pow2([0:2*r]), n, 1);

  
% ---------------- actual CA algorithm begins here ----------------

% start state is initial conditions
s = ic;

for t = 1:m

    a(t,:) = s;
 
    % S(NBRS) gives stats (bits values) of a cell's neighbors.
    % Multiplying these by powers of two and summing the products over
    % rows via SUM(...,2) gives indices into the rule table.  Update
    % rule replaces cell values with table values at these indices.
    % Need to add 1 at the end because Matlab indices start there.
    
    s = phi(sum(pwrs2.*s(nbrs), 2) + 1);

end
