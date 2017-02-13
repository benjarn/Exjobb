clear;
close all;
clc
%% gen points
[x,labels,ego_pos]=generate_sample_cluster(2);

if ~isempty(labels)
    figure
    plotClass(x,labels);
    title('Generated points and clusters')
end

%%
% Sample the distribution
% Assume gaussian
%randperm // gives random permutation of array, good for selection in
%random order
parameters

% Initialize cluster partition
partition = Partition();
Hypotheses={};
profile on
tic()
% Algorithm 1
for k=1:length(x)
    partition=Partition();
    partition = initializePartitions(x{k},length(x{k}),partition);
    
    N=length(x{k});
    iter = 500;
    for asd=1:iter % number of rotation of all the points
        % Randomly choose point from cluster
        [partition, point, c] = pickRandomZ(partition,N); % pick a point
        
        if(partition.Clusters{c}.Length==0) % delete if empty cluster
            partition = partition.removeCluster(c);
        end
        
        % point cannot exist in clusters when this is called
        W_k = evaluateWeights(partition,point,ego_pos(:,k)); % Returns the weight vector for all partition
        %plot(W_k);pause(0.1)
        partition = choosePartition(W_k,partition,point); % returns the chosen partition
        if(mod(asd,100)==0)
            sprintf('iter=%i,cluster=%i,measurement=%i',asd,partition.Length,k)
        end
    end
    % Gibbs done
    Hypotheses{length(Hypotheses)+1} = partition;
end
toc()
profile viewer

%%%%%%%%%%%% Slow and simple %%%%%%%%%%%%%%%%
%% Plotta sista
%partition = Hypotheses{5000};
% Create array of points and corresponding labels
x_mean = [];
x_new = [];
labels_new = [];
for i=1:partition.Length
    x_mean=[x_mean partition.Clusters{i}.Mean];
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
hold on
plot(x_mean(1,:),x_mean(2,:),'x');
title('Resulting clusters')

a=zeros(1,length(Hypotheses));
for i=1:length(Hypotheses); a(i)=Hypotheses{i}.Length; end
figure
plot(a)
title('#Clusters over time')