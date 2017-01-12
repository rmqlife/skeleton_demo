clc;clear;close all;
map = imread('data/leaf1.pgm');
%map = rgb2gray(map);
map = (map == 0)
width = 400;
height = 300;
if (height/width < size(map,1)/size(map,2))
    map  = imresize(map,height/size(map,1));
else
    map = imresize(map,width/size(map,2));
end
map_copy = map;
map = zeros(height,width);
size_gap = (size(map)-size(map_copy))/2;
map(size_gap(1)+1:size_gap(1)+size(map_copy,1), size_gap(2)+1:size_gap(2)+size(map_copy,2)) = map_copy;

imwrite(map,'result/map.png');
skel_points(map);

map = ~(map==0);
[h,w] = size(map);
% add boundaries to those map without boundary
map([1,h],:) = 0;
map(:,[1,w]) = 0;

agents_radius = 5;
targets_radius = 5;
% initialize the agents' positions
agents_num = 20;
map1=map;
% mask it to cluster partial  
figure,imshow(map1);
agents_position = init_agents(map1,agents_num,agents_radius);
map2=map;
figure,imshow(map2);
targets_position = init_agents(map2,agents_num,agents_radius);

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

% print 
size(map)