function cluster_graph = cluster_connection(skeleton_im, clusters)
figure,imshow(skeleton_im),hold;
cluster_size = size(clusters,1);
cluster_centers = zeros(cluster_size,2);
for i=1:size(clusters,1)
    [p,r,~] = clusters{i,:};
    viscircles([p(2),p(1)],r);
    cluster_centers(i,:) = p;
end

%cluster_centers

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
% figure, imshow(skeleton_remain_im);

cluster_graph = zeros(cluster_size);
% note every skeleton points with
for i = 1:cluster_size
    [pi,ri,~] = clusters{i,:};
    skeleton_map = skeleton_remain_im;
    % add cluster i's covered skeleton to the map
    % covered points
    covered_points = cluster_cover_skeleton{i};
    covered_indices = sub2ind(size(skeleton_map),covered_points(:,1),covered_points(:,2));
    skeleton_map(covered_indices) = 255;
    % show intermediate result for debug
    %figure,imshow(skeleton_map), hold;
    %viscircles([pi(2),pi(1)],ri);
    
    for j = i+1:cluster_size
        skeleton_map_copy = skeleton_map;
        [pj,rj,~] = clusters{j,:};
        covered_points = cluster_cover_skeleton{j};
        covered_indices = sub2ind(size(skeleton_map_copy),covered_points(:,1),covered_points(:,2));
        skeleton_map_copy(covered_indices) = 255;
        label_im = bwlabel(skeleton_map_copy,8);
        if label_im(pj(1),pj(2)) == label_im(pi(1),pi(2))
            cluster_graph(i,j) = 1;
            cluster_graph(j,i) = 1;
        end
    end
end


