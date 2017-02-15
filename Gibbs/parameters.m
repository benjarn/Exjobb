% clustering parameters
global v_0 S_0 alpha_0 beta_0 cluster_limit;
S_0 = eye(2)*0.5;
%S_0 =    [10.5000,    3.5000;
%    3.5000,   10.5000];
v_0 = 100;

alpha_0 = 5;
beta_0 = 1;

cluster_limit = 1; % eucl. dist.

% Car parameters
global sensor_width sensor_distance 
sensor_width = 15;
sensor_distance = 50;