function [r,labels]=generate_sample_cluster()
%% Generates clusters to be tested with gibbs
% Produces x,y samples without labels


rng(01);  % For reproducibility
N=10;%randi(6);
labels=[];
r = [];
for i=1:N
    n=ceil(rand*50);
    mu = 10*N*(rand(1,2)-0.5);
    %a = (rand(2)-0.5)*2;
    a = eye(2) + [0.5;0.5];
    b = triu(a) + triu(a,1)';
    sigma = b'*b;
    r = [r mvnrnd(mu,sigma,n)'];
    labels = [labels repmat(i,1,n)];
end
%Plot the random numbers.
%figure
%plotClass(r,labels);