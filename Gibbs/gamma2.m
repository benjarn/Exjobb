function [ gamma2 ] = gamma2( a )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if(a==0.5)
    a=0.51;
end
    
gamma2=sqrt(pi)*gamma(a)*gamma(a-1/2);
%gamma2 = 0.5*log(pi) + gammaln(a) + gammaln(a-0.5);
end

