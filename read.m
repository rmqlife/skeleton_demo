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
[y,x] = find(B>0);
bset = [y,x];
% coordinates of skeleton pixels
[y,x] = find(S>0);
sset = [y,x];
% inner point set
[y,x] = find(im==0);
iset = [y,x]; 

agent_radius = 10;
% random selection from the inner space of the silhouette
count = 20;
pset = zeros(count,2);
num = 1;
while num<count
    i = randi(size(iset,1),1,1);
    p = iset(i,:);
    if dist(p,bset) < agent_radius
        continue
    end
    pset(num,:) = p;
    num = num + 1;
end

for i = 1:count
    plot( pset(i,2), pset(i,1), 'wx')
end

srset = zeros(size(sset,1),1); %every skeleton's max cirle radius
for times=1:size(sset)
    p = sset(times,:);
    [r,~] = dist(p,bset);
    srset(times) = r;
end

sa_match = zeros(size(sset,1), size(pset,1));
% skeleton agent match matrix, 1 represents A is in the circle radiate
% from S, while 0 represents NOT
for i = 1:size(pset,1)
    p = pset(i,:);
    pstack = repmat(p,size(sset,1),1);
    % dist + agent_radius
    pdist = sqrt(sum((pstack-sset).^2,2));
    sa_match(:,i) = pdist < srset;
end

match_count = 0;
while match_count<size(pset,1)
    match = sum(sa_match,2);
    [count,i] = max(match);
    match_count = match_count + count;
    p = sset(i,:);
    r = srset(i);
    plot(p(2),p(1),'gx')
    viscircles([p(2),p(1)],r, 'Color','g','LineWidth',0.5);
    for j=1:size(sa_match,2)
        if sa_match(i,j) == 1
            sa_match(:,j) = 0;
        end
    end
end