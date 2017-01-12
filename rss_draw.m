close all;

% show the result
if show_fag
    B = 255*im;
    rgb = cat(3, B, B-255*skeleton_im, B-255*skeleton_im);
    figure, imshow(rgb), hold
    % draw clusters of agents
    for i=1:size(agent_clusters,1)
        [p,r,agents] = agent_clusters{i,:};
        viscircles(flip(p),r, 'Color',[rand,rand,rand],'LineWidth',1);
        for j = 1:size(agents)
            viscircles(flip(agents(j,:)),agent_radius,'Color','b');
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
    if 0 
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