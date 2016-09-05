clc;clear;close all;
im = zeros(400);
imshow(im);

center = [200,200];
center_radius = 100;
viscircles(center,center_radius);

agent_radius = 50;

num_radio = center_radius*2/agent_radius;
