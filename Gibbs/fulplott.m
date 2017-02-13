function [ means] = fulplott( partition )
%FULPLOTT Summary of this function goes here
%   Detailed explanation goes here
%% Plotta sista
%partition = Hypotheses{5000};
% Create array of points and corresponding labels
x_new = [];
labels_new = [];
means=[];
for i=1:partition.Length
    if(partition.Clusters{i}.Length>0) % Removes single point clusters, good?
        for j=1:partition.Clusters{i}.Length
            x_new=[x_new partition.Clusters{i}.Points(:,j)];
            means = [means partition.Clusters{i}.Mean];
            labels_new=[labels_new i];
        end
    else % single point cluster
        for j=1:partition.Clusters{i}.Length
            x_new=[x_new partition.Clusters{i}.Points(:,j)];
            means = [means partition.Clusters{i}.Mean];
            labels_new=[labels_new 0];
        end
    end
end
% Plot the new clusters
figure(4)
plotClass(x_new,labels_new);
hold on;
plot(means(1,:),means(2,:),'x','LineWidth',2);
title('Resulting clusters')


end

