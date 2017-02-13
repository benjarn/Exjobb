function [ partitions ] = initializePartitions( x,N )
%INITIALIZEPARTITIONS Summary of this function goes here
%   Detailed explanation goes here

% Create clusters and add all points to them (random order)
partitions = Partition();
for i=1:ceil(N/10) % Create random number of clusters
    partitions = partitions.addCluster(GibbsCluster());
end
j=1;
for i = randperm(N) % Add points to cluster in random order
    partitions.Clusters{j} = partitions.Clusters{j}.addPoint(x(:,i));
    j=j+1;
    if j>partitions.Length
        j=1;
    end
end


end

