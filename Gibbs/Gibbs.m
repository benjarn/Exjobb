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
parameters
N=length(x);
% Initialize cluster partition
partition = initializePartitions(x,N);

Hypotheses = {partition};
%%%%%% DEBUG PLOT
% Create array of points and corresponding labels
x_new = [];
labels_new = [];
for i=1:partition.Length
    for j=1:partition.Clusters{i}.Length
        x_new=[x_new partition.Clusters{i}.Points(:,j)];
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
iter = 9000;
for asd=1:iter % number of rotation of all the points
    % Randomly choose point from cluster
    [partition, point, c] = pickRandomZ(partition,N); % pick a point
    
    if(partition.Clusters{c}.Length==0) % delete if empty cluster
        partition = partition.removeCluster(c);
    end
    
    % point cannot exist in clusters when this is called
    W_k = evaluateWeights(partition,point); % Returns the weight vector for all partition
   % plot(W_k);pause(0.1)
    Hypotheses{length(Hypotheses)+1} = choosePartition(W_k,partition,point); % returns the chosen partition
    partition = Hypotheses{length(Hypotheses)};
end
% Gibbs done
toc()
%profile viewer

%%%%%%%%%%%% Slow and simple %%%%%%%%%%%%%%%%
%% Plotta sista
%partition = Hypotheses{5000};
% Create array of points and corresponding labels
x_new = [];
labels_new = [];
for i=1:partition.Length
    if(partition.Clusters{i}.Length>0) % Removes single point clusters, good?
        for j=1:partition.Clusters{i}.Length
            x_new=[x_new partition.Clusters{i}.Points(:,j)];
            labels_new=[labels_new i];
        end
    else % single point cluster
        for j=1:partition.Clusters{i}.Length
            x_new=[x_new partition.Clusters{i}.Points(:,j)];
            labels_new=[labels_new 0];
        end
    end
end
% Plot the new clusters
figure
plotClass(x_new,labels_new);
title('Resulting clusters')
