function [ clusters ] = initializePartitions( x,N )
%INITIALIZEPARTITIONS Summary of this function goes here
%   Detailed explanation goes here

% Create clusters and add all points to them (random order)
clusters = {};
for i=1:ceil(83) % Create random number of clusters
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


end

