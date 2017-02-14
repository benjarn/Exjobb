function p_D = fov(mean, ego_pos) 
% Simple box model, returns 1 if inside fov 0 otherwise 
% sensor_width = with from center 
% sensor_distance = front distance from sensor 
theta = ego_pos(4);
x_car = ego_pos(1); 
y_car = ego_pos(2); 
 
global sensor_width sensor_distance 
 
% Rotate the landmark mean to the car system 
R=[cos(theta) sin(theta); 
    -sin(theta) cos(theta)]; 
 
landmark_car = R*[-x_car + mean(1); 
    -y_car + mean(2)]; 
 
if ((landmark_car(1) > sensor_distance || landmark_car(1) < 0) || ... 
    (landmark_car(2) > sensor_width || landmark_car(2) < -sensor_width)) 
    p_D = 0; 
else 
    p_D = 1; 
end 