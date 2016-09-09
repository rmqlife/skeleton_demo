clear; close all; clc;
% load the bw image
im = imread('data/rect.pgm');
im = 255*(im==0);
if 0
   skeleton_im = load_afmm_skeleton('rect.png');
else
    skeleton_im = 255 * bwmorph(im,'skel',Inf);
end
% find the boundary of the original image
B = edge(im);
B = uint8(B)*255;
rgb = cat(3, B, B, skeleton_im);

agent_radius = 10;
% initialize the agents' positions
agents_position = init_agents(im,20,agent_radius);
% cluster the agents' postions, the clusters' postion is locate on the
% skeleton
clusters = cluster_agents(im,skeleton_im,agents_position,agent_radius);
% cluster_struction(im,clusters(1,:),agent_radius);
cluster_graph = cluster_connection_fix(skeleton_im, clusters);

for i = 1:size(clusters,1)
% cluster_arrange, make every cluster's arrangement
    cluster_strut = cluster_structure(im,clusters(i,:),agent_radius);
end

figure, imshow(rgb), hold
for i=1:size(clusters,1)
    [p,r,agents] = clusters{i,:};
%     % show each agents
%     for j=1:size(agents,1)
%         rectangle('Position',[agents(j,2)-agent_radius,agents(j,1)-agent_radius,agent_radius*2,agent_radius*2],'Curvature', [1 1], 'FaceColor','r') 
%     end
    plot(p(2),p(1),'gx')
    viscircles([p(2),p(1)],r, 'Color','w','LineWidth',0.5);
end

% draw clusters graphs
for i=1:size(clusters,1)
    %plot(pi(2),pi(1),'go');
    for j=1:size(clusters,1)
        if cluster_graph(i,j)>0
            pi = clusters{i,1};
            pj = clusters{j,1};
            plot([pi(2),pj(2)]',[pi(1),pj(1)]','-','LineWidth',3);
        end
    end
end