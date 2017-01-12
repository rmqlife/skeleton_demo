function clusters = cluster_agents(im, skeleton_im, agents_position, agent_radius);
% coordinates of boundary pixels
[y,x] = find(edge(im)>0);
boundary = [y,x];
% coordinates of skeleton pixels
[y,x] = find(skeleton_im>0);
skeleton = [y,x];

cluster_radius = zeros(size(skeleton,1),1); %every skeleton's max cirle radius
for i=1:size(skeleton)
    p = skeleton(i,:);
    [r,~] = dist(p,boundary);
    cluster_radius(i) = r;
end

sa_match = zeros(size(skeleton,1), size(agents_position,1));
% skeleton agent match matrix, 1 represents A is in the circle radiate
% from S, while 0 represents NOT, 1 respresents capable.
for i = 1:size(agents_position,1)
    p = double(agents_position(i,:));
    pstack = repmat(p,size(skeleton,1),1);
    % dist + agent_radius
    pdist = sqrt(sum((pstack-skeleton).^2,2)) + double(agent_radius);
    sa_match(:,i) = pdist <= cluster_radius;
end

clusters = cell(0);
match_count = 0; 

while match_count<size(agents_position,1)
    match = sum(sa_match,2);
    count = max(match);
    % bad result
    if count == 0
        'bad result'
        break
    end
    match_count = match_count + count;
    % find the min radius circle in the max count
    candidates = find(match == count);
    if size(candidates,1) >1
        [~, min_candidates_index] = min(cluster_radius(candidates));
        min_candidate = candidates(min_candidates_index);
    else
        min_candidate = candidates;
    end
    p = skeleton(min_candidate,:);
    r = cluster_radius(min_candidate);
    matched_agents_id = find(sa_match(min_candidate,:) == 1);
    matched_agents_position = agents_position(matched_agents_id,:);
    clusters=[clusters;{p,r,matched_agents_position}];
    % clear the matched agents
    for j=1:size(sa_match,2)
        if sa_match(min_candidate,j) == 1
            sa_match(:,j) = 0;
        end
    end
end