function cluster = cluster_structure_inverse(im,cluster,agent_radius)
background = ones(size(im));
% figure, imshow(background),hold;
[cluster_center,cluster_radius,agents] = cluster{:};
% draw cluster contour
plot(cluster_center(2),cluster_center(1),'gx')
viscircles([cluster_center(2),cluster_center(1)],cluster_radius, 'Color','g','LineWidth',0.5);

% fill the ring with the fake agents
ring_radius = cluster_radius;
fake_agents = [];
while ring_radius>=agent_radius
    theta = 0;
    if ring_radius > agent_radius*2
        delta_theta = 2 *asin(agent_radius/(ring_radius-agent_radius));
        ring_agent_number = uint8(floor(2*3.1415926/delta_theta));
        for j=1:ring_agent_number
            fake_agent_center = [(ring_radius-agent_radius)*cos(theta), (ring_radius-agent_radius)*sin(theta)];
            fake_agent_center = fake_agent_center +  cluster_center;
            theta = theta + delta_theta;
            fake_agents = [fake_agents;fake_agent_center];
        end
    else
        fake_agents = [fake_agents;cluster_center];
    end;
    ring_radius = ring_radius - agent_radius*2;
end
fake_agents = uint32(fake_agents);

% show the fake agents
for i=1:size(fake_agents)
    fake_agent_center = fake_agents(i,:);
    viscircles(flip(fake_agent_center), agent_radius,'Color','b','LineWidth',0.5);
end

% draw agents
for j=1:size(agents,1)
    viscircles([agents(j,2),agents(j,1)], agent_radius, 'Color','r');
end

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