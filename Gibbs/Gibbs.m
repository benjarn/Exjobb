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
title('Generated points and clusters')

%profile on
tic()
% Algorithm 1
iter = 5000;
for asd=1:iter % number of rotation of all the points
    % Randomly choose point from cluster
    [clusters, point, c] = pickRandomZ(clusters); % pick a point
    
    if(clusters{c}.Length==0) % delete if empty cluster
        clusters(c)=[];
    end
    
    % Måste ta bort point från clusters innan denna anropas...
    W_k = evaluateWeights(clusters,point);
    
    c_weigths=c_weigths/sum(c_weigths); % normalize
    c_rand = sum(cumsum(c_weigths)<rand())+1; % pick one cluster at random
    if c_rand<length(c_weigths)
        clusters{c_rand}=clusters{c_rand}.addPoint(point); % add the point to the cluster
    else
        clusters{c_rand}=GibbsCluster();
        clusters{c_rand}=clusters{c_rand}.addPoint(point);
        %disp('New cluster created');
    end
end
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
title('Generated points and clusters')
