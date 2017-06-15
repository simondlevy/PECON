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

