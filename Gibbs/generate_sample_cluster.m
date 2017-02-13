function [r,labels,ego_pos]=generate_sample_cluster(c)
%% Generates clusters to be tested with gibbs
% Produces x,y samples without labels

switch c
    case 1
        rng(01);  % For reproducibility
        N=5;%randi(6);
        labels=[];
        r = [];
        ego_pos=[];
        for i=1:N
            n=ceil(rand*50);
            mu = 10*N*(rand(1,2)-0.5);
            %a = (rand(2)-0.5)*2;
            a = bsxfun(@plus,eye(2), [0.5;0.5]);
            b = triu(a) + triu(a,1)';
            sigma = b'*b;
            r = [r mvnrnd(mu,sigma,n)'];
            labels = [labels repmat(i,1,n)];
        end

    case 2
        load('noisy_scans')
        r={scan_noisy(1:3).zc};
        for i=1:length(r)
            z=r{i};
            r{i}=z(1:2,:); % Fulkod
        end
        ego_pos = [scan_noisy(1:50).x_true_EGO];
        labels=[];
    otherwise
        error('Choose case 1 or 2')
end
%Plot the random numbers.
%figure
%plotClass(r,labels);