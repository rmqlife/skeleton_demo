clc;clear;close all;
raw = imread('data/liang6-1.png');
raw = rgb2gray(raw);
imshow(raw);
[centers, radii, metric] = imfindcircles(raw,[10 30]);
%viscircles(centers,radii,'EdgeColor','b');
aver = zeros(size(radii));
for i = 1:length(centers)
    r = round(radii(i,1));
    y = round(centers(i,1));
    x = round(centers(i,2));
    r2 = round(r/2);
    sub = raw(x-r2:x+r2, y-r2:y+r2);
    aver(i) = mean(sub(:));
    if aver(i)>170
        viscircles([y,x],r,'EdgeColor','b');
    else
        viscircles([y,x],r,'EdgeColor','r');
    end
    raw(x-r:x+r, y-r:y+r) = 255;
end
map = (raw <= 149);
figure,imshow(map);

map2 = zeros(size(map));
CC=bwconncomp(map);
CC = CC.PixelIdxList;
for i = 1:size(CC,2)
    if size(CC{i},1)>1000
        map2(CC{i}) = 1;
    end
end
figure, imshow(map2);