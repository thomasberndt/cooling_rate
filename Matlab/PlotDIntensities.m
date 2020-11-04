clf
set(gcf, 'Color', 'w');
T_acs = unique(T_acs); 

id_norm = find(vrmtrm & (T_ac == 57 & t_ac == 12000) | (T_ac == 37 & t_ac == 6000) ); 
dM = (M(1,:) - M(2,:)) ./ (M(1,id_norm) - M(2,id_norm));
dM2 = (M(11,:) - M(12,:)) ./ (M(11,id_norm) - M(12,id_norm));

for T = 1:length(T_acs)
    idx = find(T_ac==T_acs(T) & ~vrmtrm); 
    if ~isempty(idx)
        t_eff = EffectiveTime(T_ac(idx), t_ac(idx)/60, tau0, Tc);
        h = semilogx(t_eff, dM(idx), 'o-', ...
            'DisplayName', sprintf('%g K TRM', T_acs(T))); 
        h.MarkerFaceColor = h.Color;
        h.LineWidth = 2; 
        h.MarkerSize = 8; 
        hold on
    end
end
for T = 1:length(T_acs)
    idx = find(T_ac==T_acs(T) & vrmtrm); 
    if ~isempty(idx)
        h = semilogx(t_ac(idx), dM(idx), 's-', ...
            'DisplayName', sprintf('%g K VRM', T_acs(T))); 
        h.MarkerFaceColor = 'w';
        h.LineWidth = 2; 
        h.MarkerSize = 8; 
        hold on
    end
end

legend('Location', 'northwest'); 
title(sample);
xlabel('(Effective) Acquisition time [s]'); 
ylabel('Initial pTRM/FullTRM'); 

export_fig(fullfile('../Output/', [sample, '_dintensity.pdf']));
export_fig(fullfile('../Output/', [sample, '_dintensity.png']));