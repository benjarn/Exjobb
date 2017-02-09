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
alpha=0.1;
S_0 = eye(2)*0.1;
v_0 = 2;
alpha_0 = 0.1;
beta_0 = 0;

% Create clusters and add all points to them (random order)
clusters = {};
for i=1:ceil(N*rand()) % Create random number of clusters
    clusters{length(clusters)+1} = GibbsCluster();
end
j=1;
for i = randperm(N) % Add points to cluster in random order
    clusters{j} = clusters{j}.addPoint(x(:,i));
    j=j+1;
    if j>length(clusters)
        j=1;
    end
end

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
    % Randomly choose point from cluster (uniformly)
    c = ceil(length(clusters)*rand());
    p = ceil(clusters{c}.Length*rand());
    [clusters{c}, point] = clusters{c}.removePoint(p); % pick a point
    
    if(clusters{c}.Length==0) % delete if empty cluster
        clusters(c)=[];
    end
    
    c_length = length(clusters);
    c_weigths = zeros(1,c_length+1);
    for k=1:c_length
        v_k = v_0 + clusters{k}.Length-1;
        S_k = S_0 + (clusters{k}.Points-clusters{k}.Mean)*(clusters{k}.Points-clusters{k}.Mean)';
        mu_k = clusters{k}.Mean;
        c_k = clusters{k}.Length;
        alpha_k = alpha_0 + c_k;
        beta_k = beta_0 + length(clusters) + 0.1; % KOMPLETTERA
        % c_weigths(k)=rand(); % calculate the weight to move to cluster
        c_weigths(k)=(clusters{k}.Length/(alpha+N-1))*mvnpdf(point',mu_k',iwishrnd(S_k,v_k)); % KOMPLETTERA
    end
    c_weigths(end)=alpha/(alpha+N-1); % weigth to create new cluster KOMPLETTERA
    
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
