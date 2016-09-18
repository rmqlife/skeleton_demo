clc; clear; close all;
im = imread('data/liang2.png');
im = im(:,:,1);
im = im>0;
border = zeros(size(im)+[2,2]);
border(2:end-1,2:end-1) = im;
im = border;
skeleton_im = bwmorph(im,'skel',Inf);


% coordinates of boundary pixels
[y,x] = find(edge(im)>0);
boundary = [y,x];
% coordinates of skeleton pixels
[y,x] = find(skeleton_im>0);
skeleton = [y,x];

cluster_radius = zeros(size(skeleton,1),1); %every skeleton's max cirle radius
for i=1:size(skeleton)
    p = skeleton(i,:);
    [r,~] = dist(p,boundary);
    cluster_radius(i) = r;
end

figure, imshow(skeleton_im | ~im), hold;
fout = fopen('skeleton.txt','w');
fprintf(fout,'%g \r\n', size(x,1));
for i=1:size(x,1)
    fprintf(fout,'%g ',x(i),y(i),ceil(cluster_radius(i)));
    fprintf(fout,'\r\n');
end
fclose(fout);

for i=1:10
    i = randi(size(skeleton,1));
    viscircles([x(i),y(i)],cluster_radius(i));
    
end