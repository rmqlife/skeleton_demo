function cluster_graph = cluster_connection_fix(skeleton_im, clusters)
debug_fag = 0;

cluster_size = size(clusters,1);
% coordinates of skeleton pixels
[y,x] = find(skeleton_im>0);
skeleton = [y,x];

skeleton_remain = skeleton;
% find the skeleton points covered by the skeletons
cluster_cover_skeleton = cell(cluster_size,1);
for i = 1:cluster_size
    [p,r,~] = clusters{i,:};
    pstack = repmat(p,size(skeleton,1),1);
    pdist = sqrt(sum((pstack-skeleton).^2,2));    
    indices = (pdist<=r);
    covered_points = skeleton(indices,:);
    cluster_cover_skeleton{i} = covered_points;
end
% remove all the skeleton points in any cluster
for i = 1:cluster_size
    [p,r,~] = clusters{i,:};
    pstack = repmat(p,size(skeleton_remain,1),1);
    pdist = sqrt(sum((pstack-skeleton_remain).^2,2));    
    indices = (pdist<=r);
    skeleton_remain(indices,:) = [];
end

% draw remain skeleton
skeleton_remain_im = zeros(size(skeleton_im));
skeleton_remain_indices = sub2ind(size(skeleton_remain_im),skeleton_remain(:,1),skeleton_remain(:,2));
skeleton_remain_im(skeleton_remain_indices) = 255;
if debug_fag
    figure, imshow(skeleton_remain_im);
end
cluster_graph = zeros(cluster_size);
% note every skeleton points with
for i = 1:cluster_size
    [pi,ri,~] = clusters{i,:};
    skeleton_map = skeleton_remain_im;
    % add cluster i's covered skeleton to the map
    % covered points
    covered_points = cluster_cover_skeleton{i};
    covered_indices = sub2ind(size(skeleton_map),covered_points(:,1),covered_points(:,2));
    skeleton_map(covered_indices) = 1;
    % show intermediate result for debug
    for j = i+1:cluster_size
        skeleton_map_copy = skeleton_map;
        [pj,rj,~] = clusters{j,:};
        covered_points = cluster_cover_skeleton{j};
        covered_indices = sub2ind(size(skeleton_map_copy),covered_points(:,1),covered_points(:,2));
        skeleton_map_copy(covered_indices) = 1;
        
        % other agents' center can not be bypassed
        for k = 1:cluster_size
            if k~=i && k~=j
                [pk,~,~] = clusters{k,:};
                skeleton_map_copy(pk(1),pk(2)) = 0;
                skeleton_map_copy(pk(1)-1,pk(2)) = 0;
                skeleton_map_copy(pk(1)+1,pk(2)) = 0;
                skeleton_map_copy(pk(1),pk(2)-1) = 0;
                skeleton_map_copy(pk(1),pk(2)+1) = 0;
            end
        end
              
        label_im = bwlabel(skeleton_map_copy,8);
        if label_im(pj(1),pj(2)) == label_im(pi(1),pi(2))
            cluster_graph(i,j) = 1;
            cluster_graph(j,i) = 1;
        end
        
        if debug_fag
            figure,imshow(skeleton_map_copy), hold;
            viscircles([pi(2),pi(1)],ri);
            viscircles([pj(2),pj(1)],rj);
        end
    end
end