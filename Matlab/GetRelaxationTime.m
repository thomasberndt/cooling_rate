function [t_de, idx_de] = GetRelaxationTime(dMdNorm, t, p)
    ddMdNorm = [diff(dMdNorm); zeros(1,size(dMdNorm,2))];
    idx_de = NaN(1,size(dMdNorm,2)); 
    t_de = NaN(1,size(dMdNorm,2)); 
    for n = 1:size(dMdNorm, 2)
        idx = find(dMdNorm(:,n)<=p & ddMdNorm(:,n)<0, 1, 'first');
        if ~isempty(idx)
            t_de(n) = t(idx); 
            idx_de(n) = idx; 
        end
    end
end