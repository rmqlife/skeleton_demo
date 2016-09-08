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
% ring arrange
for r=agent_radius:2*agent_radius:cluster_radius
    viscircles([cluster_center(2), cluster_center(1)],r,'Color','y','LineWidth',0.5);
end

return