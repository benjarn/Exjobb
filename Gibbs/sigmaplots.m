function [ output_args ] = sigmaplots(mu, P)
%SIGMAPLOTS Summary of this function goes here
%   Detailed explanation goes here

% Ellipsoid example code:
n = 100; % Number of grid points
phi = linspace(0,2 * pi,100); % Create grid in interval [0,2 * pi]
%mu = [1;2]; % Mean of a 2?D normal random variable
%A1=[1 0;0 2];
%Qx=eye(2);
%P = A1*Qx*A1'; % Covariance of a 2?D normal random variable
% 3?Sigma ellipse
x = repmat(mu,1,n)+2 * sqrtm(P) * [cos(phi);sin(phi)]; % Equation(12) in HA1 document
plot(x(1,:),x(2,:),'-g','LineWidth',2)
end

