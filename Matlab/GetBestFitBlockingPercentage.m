function [p, ps, gof, num_fits] = GetBestFitBlockingPercentage(dMdNorm, t, t_exp)

    ps = linspace(0, 1, 101);
    t_de_fit = NaN(length(ps), length(t_exp));
    idx_de_fit = NaN(length(ps), length(t_exp));

    for n = 1:length(ps)
        [t_de_fit(n,:), idx_de_fit(n,:)] = GetRelaxationTime(dMdNorm, t, ps(n));
    end

    t_diff = log(t_de_fit)' - repmat(log(t_exp), 1, length(ps));
    gof = nansum(t_diff.^2);
    num_fits = sum(~isnan(t_diff));
    gof(num_fits==0) = NaN;
    p = ps(gof==nanmin(gof));
end