function cluster_struction(im,cluster,agent_radius)
background = zeros(size(im));
figure,imshow(background);
hold;
[p,r,agents] = cluster{:};
for j=1:size(agents,1)
    viscircles([agents(j,2),agents(j,1)], agent_radius, 'Color','w','LineWidth',0.5);
end
plot(p(2),p(1),'gx')
viscircles([p(2),p(1)],r, 'Color','g','LineWidth',0.5);
return