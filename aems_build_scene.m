clc;clear;close all;
map = imread('data/liang2.png');
map = rgb2gray(map);
map = ~(map==0);
[h,w] = size(map);
% add boundaries to those map without boundary
map([1,h],:) = 0;
map(:,[1,w]) = 0;

agents_radius = 8;
targets_radius = 8;
% initialize the agents' positions
agents_num = 30;
agents_position = init_agents(map,agents_num,agents_radius);
targets_position = init_agents(map,agents_num,agents_radius);

if 1
    figure, imshow(map), hold;
    for i = 1:agents_num
        viscircles(flip(agents_position(i,:)), agents_radius, 'Color', 'r');
        viscircles(flip(targets_position(i,:)), targets_radius, 'Color', 'b');
        % draw a line between start and goal
        plot([agents_position(i,2),targets_position(i,2)],[agents_position(i,1),targets_position(i,1)],'g-');
    end
end


fid = fopen('result/agents.txt','w');
fprintf(fid,'%g \r',agents_num);
for i = 1:agents_num
    fprintf(fid, '%g ', [agents_position(i,:), targets_position(i,:),agents_radius]);
    fprintf(fid, '\r\n');
end
fclose(fid);