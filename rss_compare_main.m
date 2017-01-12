clc;clear;close all;
show_fag = 1;
raw = imread('data/liang6-1.png');
raw = rgb2gray(raw);
imshow(raw);
[centers, radii, metric] = imfindcircles(raw,[10 30]);
%viscircles(centers,radii,'EdgeColor','b');
aver = zeros(size(radii));
agents_position = [];
targets_position = [];
for i = 1:length(centers)
    r = round(radii(i,1));
    y = round(centers(i,1));
    x = round(centers(i,2));
    r2 = round(r/2);
    sub = raw(x-r2:x+r2, y-r2:y+r2);
    aver(i) = mean(sub(:));
    if aver(i)>170
        viscircles([y,x],r,'EdgeColor','b');
        agents_position = [agents_position;[x,y]];
    else
        viscircles([y,x],r,'EdgeColor','r');
        targets_position = [targets_position;[x,y]];
    end
    raw(x-r:x+r, y-r:y+r) = 255;
end
map = (raw <= 149) & (raw > 145);
% figure,imshow(map);
agent_radius = round(min(radii))-1;
map2 = zeros(size(map));
CC=bwconncomp(map);
CC = CC.PixelIdxList;
for i = 1:size(CC,2)
    if size(CC{i},1)>1000
        map2(CC{i}) = 1;
    end
end
im = ~map2;
map2 = imresize(map2,1/2);
imwrite(map2,'map.pgm');

%im
%agent_radius
%agents_position
%targets_postion
scale = 1/2;
im = imresize(im,scale);
agent_radius = agent_radius * scale -1 ;
agents_position = scale * agents_position;
targets_position = scale * targets_position;

im = im == 1;
figure,imshow(im);
skeleton_im = bwmorph(im,'skeleton',Inf);
skeleton_im = (load_afmm_skeleton('skel.tiff')==255);
tic
% cluster the agents' postions, the clusters' postion is locate on the
% skeleton
agent_clusters = cluster_agents(im,skeleton_im,[agents_position;targets_position],agent_radius);
% show the result
if show_fag
    B = 255*im;
    rgb = cat(3, B, B-255*skeleton_im, B-255*skeleton_im);
    figure, imshow(rgb), hold
    % draw agents
   	for i = 1:size(agents_position,1)
        x = round(agents_position(i,1));
        y = round(agents_position(i,2));
        viscircles([y,x],agent_radius,'EdgeColor','b');
    end
    
    for i = 1:size(targets_position,1)
        x = round(targets_position(i,1));
        y = round(targets_position(i,2));
        viscircles([y,x],agent_radius,'EdgeColor','r');
    end
    
    % draw clusters of agents
    for i=1:size(agent_clusters,1)
        [p,r,agents] = agent_clusters{i,:};
        viscircles(flip(p),r, 'Color',[rand,rand,rand],'LineWidth',1);
    end    
end