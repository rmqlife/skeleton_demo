function [pos,radius] = circle_positions(mask)
% build agents
regions = regionprops(mask);
radius = double(uint16(sqrt(mean([regions.Area])/3.1415)));
pos = double(uint16(cell2mat({regions.Centroid}')));
%pos = flip(pos,1);
return