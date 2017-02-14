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
Hypotheses = {};
for k=1:length(x)
    N=length(x{k});
    % Initialize cluster partition
    partition = initializePartitions(x{k},N);
    
    
    %%%%%% DEBUG PLOT
    % % Create array of points and corresponding labels
    % x_new = [];
    % labels_new = [];
    % for i=1:partition.Length
    %     for j=1:partition.Clusters{i}.Length
    %         x_new=[x_new partition.Clusters{i}.Points(1:2,j)];
    %         labels_new=[labels_new i];
    %     end
    % end
    % % Plot the new clusters
    % figure
    % plotClass(x_new,labels_new);
    % title('Initialized clustering')
    
    %profile on
    tic()
    % Algorithm 1
    iter = 10*N;
    for asd=1:iter % number of rotation of all the points
        % Randomly choose point from cluster
        [partition, point, c] = pickRandomZ(partition,N); % pick a point
        
        if(partition.Clusters{c}.Length==0) % delete if empty cluster
            partition = partition.removeCluster(c);
        end
        
        % point cannot exist in clusters when this is called
        W_k = evaluateWeights(partition,point,ego_pos{k}); % Returns the weight vector for all partition
        %plot(W_k);pause(0.1)
        partition = choosePartition(W_k,partition,point); % returns the chosen partition
        
    end
    Hypotheses{k} = partition;
    if(mod(k,1)==0)
        sprintf('k=%i,clusters=%i',k,partition.Length)
    end
end
% Gibbs done
toc()
%profile viewer


%% Mean over resulting clusters
Clusters = {};
for k=1:length(Hypotheses)
    Clusters = horzcat(Clusters,Hypotheses{k}.Clusters);
end

for i=1:length(Clusters)-1
    for k=i+1:length(Clusters)-1
        if(norm(Clusters{i}.Mean - Clusters{k}.Mean)<cluster_limit)
            % Same cluster (merge them)
            for j=1:Clusters{k}.Length
                [Clusters{k},point] = Clusters{k}.removePoint(1);
                Clusters{i}=Clusters{i}.addPoint(point);
            end
        end
    end
end
% Delete empty clusters
i=1;
while i<length(Clusters)
   if(Clusters{i}.Length==0)
       Clusters(i)=[];
   else
       i=i+1;
   end
end
partition=Partition();
for i=1:length(Clusters)
    partition = partition.addCluster(Clusters{i});
end

%%%%%%%%%%%% Slow and simple %%%%%%%%%%%%%%%%
%% Plotta sista
%partition = Hypotheses{5000};
% Create array of points and corresponding labels
x_mean = [];
x_new = [];
labels_new = [];
x_var={};
for i=1:partition.Length
    x_mean=[x_mean partition.Clusters{i}.Mean];
    x_var{i} = iwishrnd(S_0+partition.Clusters{i}.Sigma,v_0+partition.Clusters{i}.Length-1);
    if(partition.Clusters{i}.Length>0) % Removes single point clusters, good?
        for j=1:partition.Clusters{i}.Length
            x_new=[x_new partition.Clusters{i}.Points(1:2,j)];
            labels_new=[labels_new i];
        end
    else % single point cluster
        for j=1:partition.Clusters{i}.Length
            x_new=[x_new partition.Clusters{i}.Points(1:2,j)];
            labels_new=[labels_new 0];
        end
    end
end
% Plot the new clusters
figure
plotClass(x_new,labels_new);
hold on
plot(x_mean(1,:),x_mean(2,:),'x');
for i=1:length(x_var)
    sigmaplots(x_mean(:,i),x_var{i})
end
title('Resulting clusters')

a=zeros(1,length(Hypotheses));
for i=1:length(Hypotheses); a(i)=Hypotheses{i}.Length; end
figure
plot(a)
title('#Clusters over time')