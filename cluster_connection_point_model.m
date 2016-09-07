function cluster_graph = cluster_connection(skeleton_im, clusters)
debug_fag = 0;
detect_radius = 2;

figure,imshow(skeleton_im),hold;
cluster_size = size(clusters,1);

% coordinates of skeleton pixels
[y,x] = find(skeleton_im>0);
skeleton = [y,x];

skeleton_remain = skeleton;
% find the skeleton points covered by the cluster
cluster_cover_skeleton = cell(cluster_size,1);
for i = 1:cluster_size
    [p,~,~] = clusters{i,:};
    pstack = repmat(p,size(skeleton,1),1);
    pdist = sqrt(sum((pstack-skeleton).^2,2));    
    indices = (pdist<=detect_radius);
    covered_points = skeleton(indices,:);
    cluster_cover_skeleton{i} = covered_points;
end

% remove all the skeleton points covered by the circle from clusters
% center, radius = detect_radius
for i = 1:cluster_size
    [p,~,~] = clusters{i,:};
    pstack = repmat(p,size(skeleton_remain,1),1);
    pdist = sqrt(sum((pstack-skeleton_remain).^2,2));    
    indices = (pdist<=detect_radius-1);
    skeleton_remain(indices,:) = [];
end

% draw remain skeleton
skeleton_remain_im = zeros(size(skeleton_im));
skeleton_remain_indices = sub2ind(size(skeleton_remain_im),skeleton_remain(:,1),skeleton_remain(:,2));
skeleton_remain_im(skeleton_remain_indices) = 255;

% show remained skeleton
figure, imshow(skeleton_remain_im);
% label the connection
label_im = bwlabel(skeleton_remain_im,8);

cluster_graph = zeros(cluster_size);
cluster_labels = cell(size(clusters,1),1);
for i = 1:cluster_size
    % covered points
    covered_points = cluster_cover_skeleton{i};
    covered_indices = sub2ind(size(label_im),covered_points(:,1),covered_points(:,2));
    cluster_labels{i} = unique(label_im(covered_indices));
    cluster_labels{i}
end

for i = 1:cluster_size
    for j = i+1:cluster_size
        if size(intersect(cluster_labels{i},cluster_labels{j}),1)>=2
            cluster_graph(i,j) = 1;
            cluster_graph(j,i) = 1;
        end
    end
end


