function agents_position = init_agents(im,count,agent_radius)
% inner point set
[y,x] = find(im==0);
inner_space = [y,x]; 

% coordinates of boundary pixels
B = edge(im);
[y,x] = find(B>0);
boundary = [y,x];

% random selection from the inner space of the silhouette
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

return;
