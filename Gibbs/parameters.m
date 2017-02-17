% clustering parameters
global v_0 S_0 alpha_0 beta_0 cluster_limit;
%S_0 = eye(2)*5;
S_0 =    eye(2);
v_0 = 5;

alpha_0 = 5;
beta_0 = 0.25;

cluster_limit = 1; % eucl. dist.

% Car parameters
global sensor_width sensor_distance 
sensor_width = 15;
sensor_distance = 50;