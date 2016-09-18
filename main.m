clear; close all; clc;
show_fag = 1;
use_builtin_skeleton = 1;
% build agents, map
[im,agents_position,agent_radius,targets_position] = build_agents_map('screenshots/a.png', 1, 0);
%[im,agents_position,agent_radius,targets_position] = build_agents_map('data/leaf1.pgm', 0, show_fag);
if ~use_builtin_skeleton
   skeleton_im = load_afmm_skeleton('rect.png');
else
   skeleton_im = bwmorph(im,'skel',Inf);
end

tic
% cluster the agents' postions, the clusters' postion is locate on the
% skeleton
agent_clusters = cluster_agents(im,skeleton_im,agents_position,agent_radius);
target_clusters = cluster_agents(im,skeleton_im, targets_position, agent_radius);

% add both to compute the connection and structure
clusters = [agent_clusters; target_clusters];

% find the connections between different clusters
cluster_graph = cluster_connection_fix(skeleton_im, clusters);

% print the result to files
imwrite(im,'result/map.png');
imwrite(skeleton_im,'result/skel.png');

fid = fopen('result/cluster.txt','w');
fprintf(fid,'%g ',size(clusters,1));
fprintf(fid,'%g ',size(agent_clusters,1));
fprintf(fid,'%g\r\n',size(target_clusters,1));

if show_fag
    figure, imshow(im - skeleton_im), hold;
end
for i = 1:size(clusters,1)
    % cluster_arrange, make every cluster's arrangement
    [p,r,agents] = clusters{i,:};
    fprintf(fid, '\t');
    fprintf(fid, '%g %g ', flip(p),round(r));
    fprintf(fid, '\r\n');
    if show_fag
        viscircles(flip(p),r,'Color','g');
    end
    [fake_agents,agent_match_fake_id,loop_count] = cluster_structure_inverse_for_output(im,clusters(i,:),agent_radius,0,0);
    % append a occupied fag
    fake_agents=[fake_agents,zeros(size(fake_agents,1),1)];
    for j = 1:size(agents,1)
        fake_id = agent_match_fake_id(j);
        fake_agents(fake_id,:) = [agents(j,:),1];
    end
    current_total = uint32(1);
    
    % layers, from outside to inside
    fprintf(fid,'\t\t%g\r\n',size(loop_count,1));
    for j = 1:size(loop_count,1)
        fprintf(fid,'\t\t\t%g\r\n',loop_count(j));
        for k = current_total:current_total + loop_count(j) -1
            fprintf(fid,'\t\t\t\t');
            temp =  flip(fake_agents(k,:)');
            fprintf(fid,'%g %g ', temp, agent_radius);
            fprintf(fid,'\r\n');
            if show_fag
                if temp(1) % this is an agent
                    viscircles([temp(2),temp(3)], agent_radius, 'Color', 'r');
                else % this is a target
                    viscircles([temp(2),temp(3)], agent_radius, 'Color', 'b');      
                end
            end
        end
        current_total = current_total + loop_count(j);
    end
end
fclose(fid);
toc

fid = fopen('result/graph.txt','w');
fprintf(fid,'%g ',size(clusters,1));
fprintf(fid,'%g ',size(agent_clusters,1));
fprintf(fid,'%g\r\n',size(target_clusters,1));
for i = 1:size(cluster_graph,1)
    fprintf(fid, '%g ', cluster_graph(i,:));
    fprintf(fid, '\r\n');
end
fclose(fid);

% show the result
if show_fag
    B = 255*im;
    rgb = cat(3, B, B-255*skeleton_im, B-255*skeleton_im);
    figure, imshow(rgb), hold
    % draw clusters of agents
    for i=1:size(agent_clusters,1)
        [p,r,agents] = agent_clusters{i,:};
        viscircles(flip(p),r, 'Color',[0,0,0],'LineWidth',1);
        for j = 1:size(agents)
            viscircles(flip(agents(j,:)),agent_radius,'Color','r');
        end
    end
    % draw clusters of targets
    for i=1:size(target_clusters,1)
        [p,r,agents] = target_clusters{i,:};
        viscircles(flip(p),r, 'Color','b','LineWidth',0.5);
        for j = 1:size(agents)
            viscircles(flip(agents(j,:)),agent_radius,'Color','b');
        end
    end
    
    % draw clusters graphs
    if 1 
        for i=1:size(clusters,1)
            for j=1:size(clusters,1)
                if cluster_graph(i,j)>0
                    pi = clusters{i,1};
                    pj = clusters{j,1};
                    plot([pi(2),pj(2)]',[pi(1),pj(1)]','-','LineWidth',3,'Color','g');
                end
            end
        end
    end
end