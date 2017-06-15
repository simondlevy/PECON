% Attribute-setting function for PECON
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

function p = set(p, varargin)
% SET - Change PECON object attributes
%
%   P = SET(P, <ATTRIBUTE1>,<VALUE1>, <ATTRIBUTE2>,<VALUE2>, ...)
%   changes attribute/value pairs in PECON object P.  Attributes
%   are
%
%   'VERBOSE', <VERBOSE> display messages to/from servers [default = false]
%
%   'TOLERANT', <TOLERANT> tolerate server failure [default = false]
%
%   See also PECON, FEVAL, HALT

[p.verbose,p.tolerant] = ...
   getopts(varargin, {'verbose', 'tolerant'}, {p.verbose, p.tolerant});

