clear; close all; clc;
im = imread('leaf1.pgm');
S = imread('out.png');
S = S(23:size(S,1),:,1);
S = uint8(255*(S>0));
% find the boundary of the original image
B = edge(im);
B = uint8(B)*255;
rgb = cat(3, B, B, S);
figure, imshow(rgb), hold
% coordinates of boundary pixels
[yb,xb] = find(B>0);
bset = [yb,xb];
% coordinates of skeleton pixels
[ys,xs] = find(S>0);
sset = [ys,xs];

for times=1:10
    % select a point p on S
    i = randi(size(sset,1),1);
    p = sset(i,:);
    plot(p(2),p(1),'gx');
    [r, pmin] = max_circle(p,bset);
    viscircles([p(2),p(1)], r, 'Color','r','LineWidth',0.5);
end