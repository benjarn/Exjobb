function [ clusters, point, c, p ] = pickRandomZ( clusters )
%PICKRANDOMZ Summary of this function goes here
%   Detailed explanation goes here

c = ceil(length(clusters)*rand());
p = ceil(clusters{c}.Length*rand());
[clusters{c}, point] = clusters{c}.removePoint(p); % pick a point



end

