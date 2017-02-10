function [ gamma2 ] = gamma2( a )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
gamma2=0.5*log(pi) +gammaln(a) +gammaln(a-1/2);
end

