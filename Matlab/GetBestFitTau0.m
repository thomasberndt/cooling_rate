function [tau0, tau0s, gof, num_fits] = GetBestFitTau0(T_ac, t_ac, T_de, t_de, Tc, vrmtrm)

    if nargin < 6
        vrmtrm = ones(size(T_ac));
    end

    zero_field_factor = 2;
    tau0s = logspace(-15, -3, 100); 
    t_de_fit = NaN(length(tau0s), length(t_ac));

    for n = 1:length(tau0s)
        t_ac_eff = t_ac; 
        t_ac_eff(~vrmtrm) = EffectiveTime(T_ac(~vrmtrm), zero_field_factor*t_ac(~vrmtrm)/60, tau0s(n), Tc)/zero_field_factor; 
        t_de_fit(n,:) = RelaxationTime(T_ac, t_ac_eff, T_de, Tc, tau0s(n)); 
        
%         Nomogram(Tc, tau0s(n), min(min(T_ac),min(T_de))-1, max(T_ac)+1, 1, 200); 
%         hold on
%         NomogramPoints(T_ac, t_ac, T_de, t_de*2, ...
%             'or', 'ob', 'k-');
%         NomogramPoints(T_ac, t_ac, T_de, ...
%             RelaxationTime(T_ac, t_ac/2, T_de, Tc, tau0s(n)), ...
%             'om', 'om', 'm:');
%         hold off
%         drawnow;
    end

    t_diff = log(t_de_fit)' - repmat(log(t_de(:)), 1, length(tau0s));
    gof = nansum(t_diff.^2);
    num_fits = sum(~isnan(t_diff));
    gof(num_fits==0) = NaN;
    tau0 = tau0s(gof==nanmin(gof));
end