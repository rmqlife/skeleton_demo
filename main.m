clear; close all; clc;
show_fag = 1;
use_builtin_skeleton = 1;
% build agents, map
[im,agents_position,agent_radius,targets_position] = build_agents_map('screenshots/a.png', 1, 0);
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

% print the result to files
imwrite(im,'result/map.png');
imwrite(skeleton_im,'result/skel.png');

fid = fopen('result/cluster.txt','w');
fprintf(fid,'%g\r\n',size(clusters,1));
for i = 1:size(clusters,1)
    % cluster_arrange, make every cluster's arrangement
    [p,r,agents] = clusters{i,:};
    fprintf(fid, '\t');
    fprintf(fid, '%g %g ', flip(p),r);
    fprintf(fid, '\r\n');
    
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
            fprintf(fid,'%g %g ', flip(fake_agents(k,:)'), agent_radius);
            fprintf(fid,'\r\n');
        end
        current_total = current_total + loop_count(j);
    end
end
fclose(fid);

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
end