function [yl] = Canal(sl,ecart_type)
%CANAL Summary of this function goes here
%   Detailed explanation goes here
nl = ecart_type * randn(1, length(sl));

yl = sl + nl;
end

