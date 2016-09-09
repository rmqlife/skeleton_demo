function build_agents_map()
clc;clear;close all;
debug = 0;
raw = imread('screenshots/c.png');
rim = raw(:,:,1);
gim = raw(:,:,2);
bim = raw(:,:,3);
% show each channel
if debug
    figure,imshow(raw);
    figure,imshow(cat(2,rim,gim,bim));
end
agents_mask = (rim==255 & bim==0);
targets_mask = (rim==0 & bim==255);
map_mask =(rim==bim & rim~=255 & rim~=0);
map_mask = imfill(map_mask,[1,1],8);
map_mask = ~bwmorph(map_mask,'open',1);

% build map
% cc = bwconncomp(map_mask);
% numPixels = cellfun(@numel,cc.PixelIdxList);
% [~,idx] = max(numPixels);
% map_mask = zeros(size(map_mask));
% map_mask(cc.PixelIdxList{idx}) = 1;
% map_mask= imfill(map_mask,'holes');

% build agents
[agents_position,agents_radius] = circle_positions(agents_mask);

% build agents
[targets_position,targets_radius] = circle_positions(targets_mask);

% draw all of them
canvas = zeros(size(raw));
figure, imshow(map_mask), hold;
for i = 1:size(agents_position)
    viscircles(flip(agents_position(i,:),1), agents_radius, 'Color', 'r');
end
for i = 1:size(targets_position)
    viscircles(flip(targets_position(i,:),1), targets_radius, 'Color', 'b');
end

if debug
% show the mask
    figure, imshow(cat(2,agents_mask, targets_mask, map_mask))
end

end