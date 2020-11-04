% clf
figure(11);
    
T_acs = unique(T_acs); 
if strcmpi(sample, 'MFn1')
    tau0 = 8e-8;
    Tc = 580 + 273;
    marker = 'o-';
    id_norm = find(~vrmtrm & T_ac == 37 & t_ac == 0.32);
    set(gcf, 'Position', [48 500 1100 600]);
    set(gcf, 'Color', 'w');
    p_arai = panel(); 
    p_arai.pack(1, 2);
    p_arai.margin = 15;
    p_arai.margintop = 8;
    p_arai.marginright = 8;
    p_arai.de.margin = 16;
    p_arai(1,1).select(); 
else
    tau0 = 2e-9;
    Tc = 471 + 273;
    marker = 's-';
    id_norm = find(~vrmtrm & T_ac == 57 & t_ac == 0.16);
    p_arai(1,2).select(); 
end

MM = M - repmat(nanmin(M), size(M,1), 1);
M0 = MM(1,id_norm);

for n = 1:length(T_ac)
%     idx = find(T_ac==T_acs(T) & ~vrmtrm); 
    if ~vrmtrm(n)
        h = plot(MM(1:30:end,n)/MM(1,n), 1-MM(1:30:end,id_norm)/MM(1,n), marker, ...
            'DisplayName', sprintf('%g K, %g K/min', T_ac(n), t_ac(n))); 
        if strcmpi(sample, 'MFn1')
            h.MarkerFaceColor = h.Color;
        else
            h.MarkerFaceColor = h.Color;
        end
        h.LineWidth = 2; 
        h.MarkerSize = 8; 
        hold on
    end
end

axis([0 1 0 1]);
grid on
legend('Location', 'best'); 
title(sample);
xlabel('Full TRM'); 
ylabel('pTRM'); 

% set(gca, 'FontSize', 12);
% export_fig(fullfile('../Output/Arai.pdf'));
% export_fig(fullfile('../Output/Arai.png'));