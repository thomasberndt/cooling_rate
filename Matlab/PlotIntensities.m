clf
set(gcf, 'Color', 'w');
T_acs = unique(T_acs); 

for T = 1:length(T_acs)
    idx = find(T_ac==T_acs(T) & ~vrmtrm); 
    if ~isempty(idx)
        t_eff = EffectiveTime(T_ac(idx), t_ac(idx)/60, tau0, Tc);
        h = semilogx(t_eff, M(1,idx)*1e9, 'o-', ...
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
        h = semilogx(t_ac(idx), M(1,idx)*1e9, 's-', ...
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
ylabel('Initial magnetization [nAm^2]'); 

% export_fig(fullfile('../Output/', [sample, '_intensity.pdf']));
% export_fig(fullfile('../Output/', [sample, '_intensity.png']));