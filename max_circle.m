function [r,p] = max_circle(p,bset)
    % find the distance from p to B
    % stack p
    pstack = repmat(p,size(bset,1),1);

    % distances, find the nearest 2 points
    pdist = sqrt(sum((pstack-bset).^2,2));
    [r, index] = min(pdist);
    p = bset(index);
end
