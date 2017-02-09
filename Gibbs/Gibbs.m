clear;
close all;
clc
%% gen points
[x,labels]=generate_sample_cluster();
figure
plotClass(x,labels);
title('Generated points and clusters')
%%
% Sample the distribution
% Assume gaussian
%randperm // gives random permutation of array, good for selection in
%random order
N=length(x);
% Initialize cluster partitions
clusters = initializePartitions(x,N);

%%%%%% DEBUG PLOT
% Create array of points and corresponding labels
x_new = [];
labels_new = [];
for i=1:length(clusters)
    for j=1:clusters{i}.Length
        x_new=[x_new clusters{i}.Points(:,j)];
        labels_new=[labels_new i];
    end
end
% Plot the new clusters
figure
plotClass(x_new,labels_new);
title('Initialized clustering')

%profile on
tic()
% Algorithm 1
iter = 5000;
for asd=1:iter % number of rotation of all the points
    % Randomly choose point from cluster
    [clusters, point, c] = pickRandomZ(clusters,N); % pick a point
    
    if(clusters{c}.Length==0) % delete if empty cluster
        clusters(c)=[];
    end
    
    % point cannot exist in clusters when this is called
    W_k = evaluateWeights(clusters,point); % Returns the weight vector for all partitions
    
    clusters = choosePartition(W_k,clusters); % returns the chosen partition
end
% Gibbs done
toc()
%profile viewer

%%%%%%%%%%%% Slow and simple %%%%%%%%%%%%%%%%
% Create array of points and corresponding labels
x_new = [];
labels_new = [];
for i=1:length(clusters)
    if(clusters{i}.Length>1) % Removes single point clusters, good?
        for j=1:clusters{i}.Length
            x_new=[x_new clusters{i}.Points(:,j)];
            labels_new=[labels_new i];
        end
    else % single point cluster
        for j=1:clusters{i}.Length
            x_new=[x_new clusters{i}.Points(:,j)];
            labels_new=[labels_new 0];
        end
    end
end
% Plot the new clusters
figure
plotClass(x_new,labels_new);
title('Resulting clusters')
