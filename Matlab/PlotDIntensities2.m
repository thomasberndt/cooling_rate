% clf
figure(13);
set(gcf, 'Color', 'w');
T_acs = unique(T_acs); 
if strcmpi(sample, 'MFn1')
    tau0 = 8e-8;
    Tc = 580 + 273;
    marker = 'o-';
    id_norm = find(~vrmtrm & T_ac == 37 & t_ac == 0.32);
else
    tau0 = 2e-9;
    Tc = 471 + 273;
    marker = 's-';
    id_norm = find(~vrmtrm & T_ac == 57 & t_ac == 0.16);
end

dM = (M(1,:) - M(700,:)) ./ (M(1,id_norm) - M(700,id_norm));
dM2 = (M(440,:) - M(450,:)) ./ (M(440,id_norm) - M(450,id_norm));

for T = 1:length(T_acs)
    idx = find(T_ac==T_acs(T) & ~vrmtrm); 
    if ~isempty(idx)
        t_eff = EffectiveTime(T_ac(idx), t_ac(idx)/60, tau0, Tc);
        t_eff = t_ac(idx);
        h = semilogx(t_eff, dM2(idx), marker, ...
            'DisplayName', sprintf('%s %g K', sample, T_acs(T))); 
        if strcmpi(sample, 'MFn1')
            h.MarkerFaceColor = h.Color;
        else
            h.MarkerFaceColor = 'w';
        end
        h.LineWidth = 2; 
        h.MarkerSize = 8; 
        hold on
    end
end

grid on
legend('Location', 'best'); 
title('Palaeointensities');
xlabel('Cooling rate [K/min]'); 
ylabel('pTRM/FullTRM (Palaeointensity)'); 

% export_fig(fullfile('../Output/Intensities.pdf'));
% export_fig(fullfile('../Output/Intensities.png'));