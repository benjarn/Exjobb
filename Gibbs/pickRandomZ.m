function [ partition, point, c, p ] = pickRandomZ( partition, N )
%PICKRANDOMZ picks a random point and removes it from clusters
% N = length of measurements
% does a linear search for the selected element.
% x = randi(N); % Pick random point out of all x;
% c = 1;
% p = 1;
% set = 0;
% s = 0;
% while c < partition.Length && ~set
%     c = c + 1;
%     p=0;
%     while p < partition.Clusters{c}.Length && ~set
%         p = p + 1;
%         s = s+1;
%         if(s>=x)
%             set = 1;
%         end
%     end
% end

c = ceil(partition.Length*rand());
p = ceil(partition.Clusters{c}.Length*rand());
[partition.Clusters{c}, point] = partition.Clusters{c}.removePoint(p); % pick a point



end

