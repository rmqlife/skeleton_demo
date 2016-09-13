function [map,agents_position,agents_radius,targets_position]=build_agents_map(filename, with_agents, show_fag)
% map: logical map, 1 means available, 0 means obstacles
if with_agents
    raw = imread(filename);
    rim = raw(:,:,1);
    bim = raw(:,:,3);
    agents_mask = (rim==255 & bim==0);
    targets_mask = (rim==0 & bim==255);
    map =(rim==bim & rim~=255 & rim~=0);
    map = imfill(map,[1,1],8);
    map = ~bwmorph(map,'open',1);
    % build agents
    [agents_position,agents_radius] = circle_positions(agents_mask);
    % build targets
    [targets_position,targets_radius] = circle_positions(targets_mask);
else %random generate agents
    map = imread(filename);
    map = (map==0);
    agents_radius = 8;
    targets_radius = 8;
    % initialize the agents' positions
    agents_position = init_agents(map,100,agents_radius);
    targets_position = init_agents(map,0,agents_radius);
end

% draw all of them
if show_fag
    figure, imshow(map), hold;
    for i = 1:size(agents_position,1)
        viscircles(flip(agents_position(i,:)), agents_radius, 'Color', 'r');
    end
    for i = 1:size(targets_position,1)
        viscircles(flip(targets_position(i,:)), targets_radius, 'Color', 'b');
    end
end

return;