
clear;
close all;
clc
%profile on
%% gen points
lim=1; % meter gräns
landmark_extent = 4; % utbrednad i antal punkter

[x,labels,ego_pos]=generate_sample_cluster(2);
partition=Partition();
partition = partition.addCluster(GibbsCluster());
partition.Clusters{partition.Length} = partition.Clusters{partition.Length}.addPoint([0;0]);
for k=1:length(x)
    zz = x{k}(1:2,:);
    for zi = 1:length(zz)
        z=zz(:,zi);
        distances = zeros(partition.Length,1);
        for j = 1:partition.Length
            distances(j) = norm(partition.Clusters{j}.Mean - z);
        end
        [val,I] = min(distances);
        if(val<lim)
            partition.Clusters{I} = partition.Clusters{I}.addPoint(z);
        else
            partition = partition.addCluster(GibbsCluster());
            partition.Clusters{partition.Length} = partition.Clusters{partition.Length}.addPoint(z);
        end
    end
end

%%
for k=1:partition.Length
    plot(partition.Clusters{k}.Points(1,:),partition.Clusters{k}.Points(2,:),'.')
    hold on
     if(partition.Clusters{k}.Length>landmark_extent)
         plot(partition.Clusters{k}.Mean(1),partition.Clusters{k}.Mean(2),'x')
     end
end

%%
x_mean = [];
x_new = [];
labels_new = [];
x_var={};
for i=1:partition.Length
    
    if(partition.Clusters{i}.Length>landmark_extent) % Removes single point clusters, good?
        x_mean=[x_mean partition.Clusters{i}.Mean];
        x_var{length(x_var)+1} = partition.Clusters{i}.Sigma;
        
        for j=1:partition.Clusters{i}.Length
            x_new=[x_new partition.Clusters{i}.Points(1:2,j)];
            labels_new=[labels_new i];
        end
    else % single point cluster
        %                 for j=1:partition.Clusters{i}.Length
        %                     x_new=[x_new partition.Clusters{i}.Points(1:2,j)];
        %                     labels_new=[labels_new 0];
        %                 end
    end
end

hold on
plot(x_mean(1,:),x_mean(2,:),'x');
for i=1:length(x_var)
    sigmaplots(x_mean(:,i),x_var{i})
end
title('Resulting clusters')

% profile off
% profile viewer