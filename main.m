clear; close all; clc;
show_fag = 1;
use_builtin_skeleton = 1;
% build agents, map
[im,agents_position,agent_radius,targets_position] = build_agents_map('screenshots/d.png', 1, 1);
%[im,agents_position,agent_radius,targets_position] = build_agents_map('data/rect.pgm', 0, 1);
if ~use_builtin_skeleton
   skeleton_im = load_afmm_skeleton('rect.png');
else
   skeleton_im = bwmorph(im,'skel',Inf);
end
% cluster the agents' postions, the clusters' postion is locate on the
% skeleton
clusters = cluster_agents(im,skeleton_im,agents_position,agent_radius);
% find the connections between different clusters
cluster_graph = cluster_connection_fix(skeleton_im, clusters);

% show the result
if show_fag
    B = edge(im);
    B = uint8(B)*255;
    rgb = cat(3, B, B, 255*skeleton_im);
    figure, imshow(rgb), hold
    % draw clusters
    for i=1:size(clusters,1)
        [p,r,agents] = clusters{i,:};
        viscircles(flip(p),r, 'Color','w','LineWidth',0.5);
        for j = 1:size(agents)
            viscircles(flip(agents(j,:)),agent_radius,'Color','w');
        end
    end

    % draw clusters graphs
    for i=1:size(clusters,1)
        for j=1:size(clusters,1)
            if cluster_graph(i,j)>0
                pi = clusters{i,1};
                pj = clusters{j,1};
                plot([pi(2),pj(2)]',[pi(1),pj(1)]','-','LineWidth',3);
            end
        end
    end

    for i = 1:size(clusters,1)
    % cluster_arrange, make every cluster's arrangement
        [fake_agents,agent_match_fake_id] = cluster_structure_inverse(im,clusters(i,:),agent_radius,show_fag,0);
    end
end