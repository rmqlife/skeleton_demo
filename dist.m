function [r,p] = dist(p,pset)
    % find the distance from p to B
    % stack p
    pstack = repmat(p,size(pset,1),1);
    % distances, find the nearest 2 points
    pdist = sqrt(sum((pstack-pset).^2,2));
    [r, index] = min(pdist);
    p = pset(index,:);
end
