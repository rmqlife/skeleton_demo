clear; close all; clc;
% load the bw image
im = imread('leaf1.pgm');
% load the skeleton image
skeleton_im = imread('out.png');
% process to remove the window bar
skeleton_im = skeleton_im(23:size(skeleton_im,1),:,1);
skeleton_im = uint8(255*(skeleton_im>0));
% find the boundary of the original image
B = edge(im);
B = uint8(B)*255;
rgb = cat(3, B, B, skeleton_im);
figure, imshow(rgb), hold

agent_radius = 10;
% initialize the agents' positions
agents_position = init_agents(im,20,agent_radius);
% cluster the agents' postions, the clusters' postion is locate on the
% skeleton
clusters = cluster_agents(im,skeleton_im,agents_position,agent_radius);
for i=1:size(clusters,1)
    [p,r,agents] = clusters{i,:};
    for j=1:size(agents,1)
        viscircles([agents(j,2),agents(j,1)], agent_radius, 'Color','w','LineWidth',0.5);
    end
    plot(p(2),p(1),'gx')
    viscircles([p(2),p(1)],r, 'Color','g','LineWidth',0.5);
end

% cluster_struction(im,clusters(1,:),agent_radius);
cluster_graph = cluster_connection(skeleton_im, clusters);


% draw graph
for i=1:size(clusters,1)
    pi = clusters{i,1};
    %plot(pi(2),pi(1),'go');
    for j=i+1:size(clusters,1)
        if cluster_graph(i,j)==1
            pj = clusters{j,1};
            plot([pi(2);pj(2)],[pi(1),pj(1)],'b-');
            break
        end
    end
end
