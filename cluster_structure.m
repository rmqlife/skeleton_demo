function cluster = cluster_structure(im,cluster,agent_radius)
background = zeros(size(im));
figure,imshow(background);
hold;
[cluster_center,cluster_radius,agents] = cluster{:};
% draw agents
for j=1:size(agents,1)
    viscircles([agents(j,2),agents(j,1)], agent_radius, 'Color','w','LineWidth',0.5);
end
% draw cluster contour
plot(cluster_center(2),cluster_center(1),'gx')
viscircles([cluster_center(2),cluster_center(1)],cluster_radius, 'Color','g','LineWidth',0.5);

ring_numbers = 0;
% ring arrange
for r=agent_radius:2*agent_radius:cluster_radius
    viscircles([cluster_center(2), cluster_center(1)],r,'Color','y','LineWidth',0.5);
    ring_numbers = ring_numbers + 1;
end

% fill the ring with the fake agents
ring_agent_center_dist = 0;
ring_agent_number = 1;
fake_agents = [];
for i=1:ring_numbers
    theta = 0;
    delta_theta = 2*3.1415926/ring_agent_number;
    for j=1:ring_agent_number
        fake_agent_center = [ring_agent_center_dist*cos(theta), ring_agent_center_dist*sin(theta)];
        fake_agent_center = fake_agent_center +  cluster_center;
        theta = theta + delta_theta;
        fake_agents = [fake_agents;fake_agent_center];
    end
    if ring_agent_number == 1
        ring_agent_number = 6;
    else
        ring_agent_number = ring_agent_number+6;
    end;
    ring_agent_center_dist = ring_agent_center_dist + agent_radius*2;
end

% show the fake agents
% for i=1:size(fake_agents)
%     fake_agent_center = fake_agents(i,:);
%     viscircles(flip(fake_agent_center), agent_radius);
% end

% match the fake agents with the exact ones
match_cost = pdist2(fake_agents,agents);
[assignment,unassignedTracks,unassignedDetections] = assignDetectionsToTracks(match_cost',100);

% show tha assignments
for i=1:size(assignment,1) % agents indices
    agent = agents(assignment(i,1),:);
    fake_agent = fake_agents(assignment(i,2),:);
    plot([agent(2),fake_agent(2)],[agent(1),fake_agent(1)],'-','LineWidth',3);
    %viscircles(flip(fake_agent),agent_radius,'Color','g','LineStyle','--','LineWidth',0.5);
end
return