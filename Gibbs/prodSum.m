function [ W_k ] = prodSum( W_k,v_k,S_k,mu_k,c_k,alpha_k,beta_k )
%PRODSUM Summary of this function goes here
global v_0 S_0 alpha_0 beta_0;
%   Detailed explanation goes here
 W_k = W_k  * (beta_0^alpha_0*gamma(alpha_k))/(beta_k^alpha_k*gamma(alpha_0)) * (norm(S_0)^(v_0/2)*gamma2(v_k/2))/(pi^(c_k-1)*sqrt(c_k)*gamma2(v_0/2)*norm(S_k)^(v_k/2));
 

end

