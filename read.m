clear; close all; clc;
im = imread('leaf1.pgm');
S = imread('out.png');
S = S(23:size(S,1),:,1);
S = uint8(255*(S>0));
% find the boundary of the original image
B = edge(im);
B = uint8(B)*255;
rgb = cat(3, B, B, S);
figure, imshow(rgb), hold
% coordinates of boundary pixels
[y,x] = find(B>0);
boundary = [y,x];
% coordinates of skeleton pixels
[y,x] = find(S>0);
skeleton = [y,x];
% inner point set
[y,x] = find(im==0);
inner_space = [y,x]; 

agent_radius = 10;
% random selection from the inner space of the silhouette
count = 20;
agents_position = [];
num = 1;
while num<=count
    i = randi(size(inner_space,1),1,1);
    p = inner_space(i,:);
    if dist(p,boundary) <= agent_radius
        continue
    end
    if size(agents_position,1)>1 && dist(p,agents_position) < 2*agent_radius
        continue
    end
    agents_position = [agents_position;p];
    num = num + 1;
end


for i = 1:size(agents_position,1)
    viscircles([agents_position(i,2),agents_position(i,1)], agent_radius, 'Color','w','LineWidth',0.5);
end

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
    p = agents_position(i,:);
    pstack = repmat(p,size(skeleton,1),1);
    % dist + agent_radius
    pdist = sqrt(sum((pstack-skeleton).^2,2)) + agent_radius;
    sa_match(:,i) = pdist <= cluster_radius;
end

clusters = cell(0);
match_count = 0; 

while match_count<size(agents_position,1)
    match = sum(sa_match,2);
    count = max(match);
    % bad result
    if count == 0
        break
    end
    match_count = match_count + count;
    % find the min radius circle in the max count
    candidates = find(match == count);
    if size(candidates,1) >1
        [min_radius, min_candidates_index] = min(cluster_radius(candidates));
        min_candidate = candidates(min_candidates_index);
    else
        min_candidate = candidates;
    end
    p = skeleton(min_candidate,:);
    r = cluster_radius(min_candidate);
    plot(p(2),p(1),'gx')
    viscircles([p(2),p(1)],r, 'Color','g','LineWidth',0.5);
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

