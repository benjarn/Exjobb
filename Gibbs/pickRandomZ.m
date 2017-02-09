function [ clusters, point, c, p ] = pickRandomZ( clusters, N )
%PICKRANDOMZ picks a random point and removes it from clusters
% N = length of measurements
% does a linear search for the selected element.
x = randi(N); % Pick random point out of all x;
c = 0;
p = 0;
set = 0;
s = 0;
while c < length(clusters) && ~set
    c = c + 1;
    p=0;
    while p < clusters{c}.Length && ~set
        p = p + 1;
        s = s+1;
        if(s>=x)
            set = 1;
        end
    end
end
%c = ceil(length(clusters)*rand());
%p = ceil(clusters{c}.Length*rand());
[clusters{c}, point] = clusters{c}.removePoint(p); % pick a point



end

