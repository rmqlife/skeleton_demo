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

for times=1:20
    % select a point p on S
    i = randi(size(sset,1),1);
    p = sset(i,:);

    % find the distance from p to B
    % stack p
    pstack = repmat(p,size(bset,1),1);

    % distances, find the nearest 2 points
    pdist = sqrt(sum((pstack-bset).^2,2));
    [sorted, index] = sort(pdist,'ascend');
    nearest1 = bset(index(1),:);
    nearest2 = bset(index(2),:);

    % plot
    plot(p(2),p(1),'g*');
    for i = 1:2
        bnear = bset(index(i),:);
        plot(bnear(2),bnear(1),'ro');
        viscircles([p(2),p(1)], sorted(i),'Color','r')
    end
end