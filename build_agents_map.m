function [map,agents_position,agents_radius,targets_position]=build_agents_map(filename)
debug = 0; draw = 0;
raw = imread(filename);
rim = raw(:,:,1);
gim = raw(:,:,2);
bim = raw(:,:,3);

agents_mask = (rim==255 & bim==0);
targets_mask = (rim==0 & bim==255);
map =(rim==bim & rim~=255 & rim~=0);
map = imfill(map,[1,1],8);
map = ~bwmorph(map,'open',1);
if debug
    figure, imshow(cat(2,agents_mask, targets_mask, map));
end
% build agents
[agents_position,agents_radius] = circle_positions(agents_mask);
% build agents
[targets_position,targets_radius] = circle_positions(targets_mask);

% draw all of them
if draw
    figure, imshow(map), hold;
    for i = 1:size(agents_position)
        viscircles(flip(agents_position(i,:),1), agents_radius, 'Color', 'r');
    end
    for i = 1:size(targets_position)
        viscircles(flip(targets_position(i,:),1), targets_radius, 'Color', 'b');
    end
end

return;