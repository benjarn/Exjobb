function [r,labels,ego_pos]=generate_sample_cluster(c)
%% Generates clusters to be tested with gibbs
% Produces x,y samples without labels

switch c
    case 1
        rng(01);  % For reproducibility
        N=5;%randi(6);
        labels=[];
        r = [];
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
        r={};
        N1=150;
        N=300; % 400 is ~max
        for i=N1:N
           z=[scan_noisy(i).zc];
           z(3,:) = i-N1+1; % Add time tag
           r{i-N1+1} = [z];
        end
        ego_pos={scan_noisy(N1:N).x_true_EGO};
        labels=[];
    otherwise
        error('Choose case 1 or 2')
end
%Plot the random numbers.
%figure
%plotClass(r,labels);