 
if exist('sample', 'var')
    sample_in = input(sprintf('Sample name (default=%s): ', sample), 's'); 
    if isempty(sample_in)
        prev_sample = 1; 
    else
        sample = sample_in; 
        samplenum = input('Sample number (for subplots): '); 
        prev_sample = 0;
    end
else
    sample = input('Sample name: ', 's'); 
    samplenum = input('Sample number (for subplots): '); 
    prev_sample = 0; 
end

colororder =   [0    0.4470    0.7410
    0.8500    0.3250    0.0980
    0.9290    0.6940    0.1250
    0.4940    0.1840    0.5560
    0.4660    0.6740    0.1880
    0.3010    0.7450    0.9330
    0.6350    0.0780    0.1840];
letters = 'abcdefghijklmn'; 
samplenames = {'Magnetoferritin', 'Tiva Canyon 12-01'};
t = logspace(log10(10), log10(12000), 1000); 

if ~prev_sample
    [files, T_ac, t_ac, T_de, labels, vrmtrm] = GetAllDatafiles(sample); 

    T_acs_vrm = unique(T_ac(vrmtrm), 'sorted'); 
    T_acs_trm = unique(T_ac(~vrmtrm), 'sorted'); 
    T_acs = [T_acs_vrm; T_acs_trm];
    vrmtrms = [ones(size(T_acs_vrm)); zeros(size(T_acs_trm))];
    N = length(T_acs); 
    if N == 4
        X = 2; 
        Y = 2;
    else
        X = 3; 
        Y = ceil(N/3); 
    end

    h_fits = cell(size(T_ac));
    h_num_plots = zeros(size(T_ac));
    dh_fits = cell(size(T_ac));

    M = NaN(length(t), length(length(T_ac)));
    dM = NaN(length(t), length(length(T_ac)));

    figure(1); 
    X = 3 + any(T_ac(vrmtrm) > max(T_de(vrmtrm))); 
    
    set(gcf, 'Position', [48 48 650/0.95 1100*X/4]);
    clf
    set(gcf, 'Color', 'w');

    p = panel(); 
%     p.pack(X, Y);
    p.pack(X, 2);
    p.margin = 14;
    p.margintop = 8;
    p.marginright = 8;
    p.de.margin = 14;

    for n = 1:length(T_ac)
        [M(:,n), dM(:,n), ~, M_raw, t_raw, M_offsets] = ...
                    LoadVrmExperiment(files{n}, t, 'tanhextra');

        k = find(T_acs==T_ac(n) & vrmtrms==vrmtrm(n)); 
        
        if (~vrmtrm(n))
        	p(4, 1).select();
            subplot_index = 4;
            title(sprintf('%s) TRM', letters(X))); 
        elseif (T_ac(n) < T_de(n))
        	p(1, 1).select();
            subplot_index = 1;
            title(sprintf('%s) VRM T_A < T_D', letters(1))); 
        elseif (T_ac(n) == T_de(n))
        	p(2, 1).select();
            subplot_index = 2;
            title(sprintf('%s) VRM T_A = T_D', letters(2))); 
        else 
        	p(3, 1).select();
            subplot_index = 3;
            title(sprintf('%s) VRM T_A > T_D', letters(3))); 
        end
        
        if vrmtrm(n)
            legend_label = sprintf('%g K, %g s', T_ac(n), t_ac(n));
        else
            legend_label = sprintf('%g K, %g K/min', T_ac(n), t_ac(n));
        end
        
        h_num_plots(subplot_index) = h_num_plots(subplot_index) + 1;
        h_fit = semilogx(t, M(:,n)*1e9, '-', ...
            'Color', colororder(h_num_plots(subplot_index),:), ...
            'LineWidth', 2, ...
            'DisplayName', legend_label); 
        h_fits{n} = h_fit;
        hold on
        
        h_raw = semilogx(t_raw{1}, M_raw{1}*1e9, 'ok', 'HandleVisibility', 'off'); 
        h_raw.MarkerSize = 1; 
        h_raw.MarkerFaceColor = 'k'; 
        
        for m = 2:length(M_raw)
            h_off = semilogx(t_raw{m}, (M_raw{m} + M_offsets(m-1))*1e9, 'or', ...
                'HandleVisibility', 'off');
            h_off.MarkerSize = 1; 
            h_off.MarkerFaceColor = 'r';  
        end

        if ~vrmtrm(n)
            xlabel('Time [s]'); 
        end
        ylabel('M [nAm^2]'); 
        legend('location', 'best');
        legend boxoff
        grid on
    end
end


hs = cell(size(T_acs));
legend_labels = cell(size(T_acs)); 
idx_norm = 0; 
while ~any(idx_norm)
    T_norm = input('T_norm: '); 
    t_norm = input('t_norm: ');
    idx_norm = logical(T_ac==T_norm & t_ac==t_norm); 
end
M_norm = M(:,idx_norm); 
dM_norm = dM(:,idx_norm); 
dMdNorm = dM./repmat(dM_norm, 1, length(T_ac)); 
    

if ~prev_sample

    for n = 1:length(T_ac)
        k = find(T_acs==T_ac(n) & vrmtrms==vrmtrm(n)); 
        if (~vrmtrm(n))
        	p(4, 2).select();
            title(sprintf('%s) TRM', letters(X+4))); 
        elseif (T_ac(n) < T_de(n))
        	p(1, 2).select();
            title(sprintf('%s) VRM T_A < T_D', letters(1+4))); 
        elseif (T_ac(n) == T_de(n))
        	p(2, 2).select();
            title(sprintf('%s) VRM T_A = T_D', letters(2+4))); 
        else 
        	p(3, 2).select();
            title(sprintf('%s) VRM T_A > T_D', letters(3+4))); 
        end
        
        if vrmtrm(n)
            legend_label = sprintf('%g K, %g s', T_ac(n), t_ac(n));
        else
            legend_label = sprintf('%g K, %g K/min', T_ac(n), t_ac(n));
        end
        
        h = semilogx(t, dMdNorm(:,n), '-', ... 
            'LineWidth', 2, ...
            'DisplayName', legend_label); 
        dh_fits{n} = h; 
        hold on
        legend('location', 'best');
        legend boxoff
        if ~vrmtrm(n)
            xlabel('Time [s]'); 
        end
        ylabel('dM/dM_{FullVRM}');
        grid on
        axis([10 12000 0 1]);
        set(gca, 'YTick', 0:0.1:1)
    end
end


% zero_field_factor = 1 
zero_field_factor = 2;


figure(3); 
clf;

idx = logical(vrmtrm & T_ac==T_de); 
[perc, ps, gof, num_fits] = GetBestFitBlockingPercentage(...
        dMdNorm(:,idx), t*zero_field_factor, t_ac(idx));
plot(ps, gof, 'ok-', ps, num_fits, 'sb-'); 

p_in = input(sprintf('Blocking ratio (best=%g): ', perc)); 
if ~isempty(p_in)
    perc = p_in;
end


t_de = GetRelaxationTime(dMdNorm, t, perc);

%%
figure(1); 
for n = 1:length(T_ac)
    if (~vrmtrm(n))
        p(4, 1).select();
    elseif (T_ac(n) < T_de(n))
        p(1, 1).select();
    elseif (T_ac(n) == T_de(n))
        p(2, 1).select(); 
    else 
        p(3, 1).select();
    end
    
    color = h_fits{n}.Color; 
    M_de = interp1(t, M(:,n)*1e9, t_de(n)); 
    semilogx(t_de(n), M_de, 'o', 'Color', color, 'HandleVisibility', 'off'); 
    
    if (~vrmtrm(n))
        p(4, 2).select();
    elseif (T_ac(n) < T_de(n))
        p(1, 2).select();
    elseif (T_ac(n) == T_de(n))
        p(2, 2).select(); 
    else 
        p(3, 2).select();
    end
        
    dM_de = interp1(t, dMdNorm(:,n), t_de(n)); 
    semilogx(t_de(n), dM_de, 'o', 'Color', color, 'HandleVisibility', 'off'); 
end


export_fig(fullfile('../Output/', [sample, '_decay.pdf']));


%% 
Tc_in = input('Tc (default=580) [C]: ');
if isempty(Tc_in)
    Tc = 580+273;
else
    Tc = Tc_in + 273;
end
figure(4);
clf;
idx = logical(vrmtrm & T_ac~=T_de); 
[tau0, tau0s, gof, num_fits] = GetBestFitTau0(...
        T_ac(idx), t_ac(idx)/zero_field_factor, T_de(idx), t_de(idx), Tc);
semilogx(tau0s, gof, 'ok-', tau0s, num_fits, 'sb-'); 
xlabel('Tau_0 [s]');


r_ac = t_ac(~vrmtrm); 
tau0_in = input(sprintf('tau0 [s] (best=%g): ', tau0)); 
if ~isempty(tau0_in)
    tau0 = tau0_in;
end

%%
figure(5);

if samplenum > 0
    set(gcf, 'Position', [48 500 1100 600]);
    if samplenum == 1
        p_nomo = panel(); 
        p_nomo.pack(1, 2);
        p_nomo.margin = 15;
        p_nomo.margintop = 8;
        p_nomo.marginright = 8;
        p_nomo.de.margin = 14;
        p_nomo(1, 1).select();
    else 
        p_nomo(1, samplenum).select();
    end
    title(samplenames{samplenum}); 
else
    set(gcf, 'Position', [48 500 600 600]);
    clf
end
set(gcf, 'Color', 'w');

t_eff = EffectiveTime(T_ac, t_ac/60, tau0, Tc); 
issame = (T_de == T_ac); 

Nomogram(Tc, tau0, min(min(T_ac),min(T_de))-1, max(T_ac)+1, 1, 200); 
hold on
[h_lines, h_a, h_v] = NomogramPoints(...
    T_ac(vrmtrm)+0.03*issame(vrmtrm), t_ac(vrmtrm), ...
    T_de(vrmtrm)-0.03*issame(vrmtrm), t_de(vrmtrm)*zero_field_factor, ...
    'or', 'ob', 'k-', 'nonan');
for n = 1:length(h_a)
    h_a{n}.MarkerSize = 8; 
%     h_a{n}.MarkerFaceColor = 'w';
    h_v{n}.MarkerSize = 8; 
    h_v{n}.MarkerFaceColor = 'w';
end
% NomogramPoints(T_ac(vrmtrm), t_ac(vrmtrm), T_de(vrmtrm), ...
%     RelaxationTime(T_ac(vrmtrm), t_ac(vrmtrm)/2, T_de(vrmtrm), Tc, tau0), ...
%     'om', 'om', 'm:');
[h_lines, h_at, h_vt] = NomogramPoints(T_ac(~vrmtrm), t_eff(~vrmtrm), ...
    T_de(~vrmtrm), t_de(~vrmtrm)*zero_field_factor, ...
    'dr', 'db', 'k--', 'nonan');
for n = 1:length(h_a)
    h_at{n}.MarkerSize = 10; 
    h_at{n}.MarkerFaceColor = [1 .4 .2];
    h_vt{n}.MarkerSize = 10; 
    h_vt{n}.MarkerFaceColor = [.8 .8 1];
end



legend([h_a{1} h_v{1} h_at{1} h_vt{1}], ...
    sprintf('VRM acquisition'), ...
    sprintf('Demagnetization of VRM'), ...
    sprintf('TRM acquisition'), ...
    sprintf('Demagnetization of TRM'), ...
    'Expected trend', 'Actual trend', 'location', 'northeast'); 

xlim([min(T_ac)-0.5 max(T_ac)+0.5]);
ylim([200 2e4]); 
set(gca, 'FontSize', 12);
export_fig(fullfile('../Output/', [sample, '_nomogram.pdf']));

%%

figure(6)

if samplenum > 0
    set(gcf, 'Position', [1300 500 1100 600]);
    if samplenum == 1
        p_trend = panel(); 
        p_trend.pack(1, 2);
        p_trend.margin = 15;
        p_trend.margintop = 8;
        p_trend.marginright = 8;
        p_trend.de.margin = 14;
        p_trend(1, 1).select();
    else 
        p_trend(1, samplenum).select();
    end
    title(samplenames{samplenum}); 
else
    set(gcf, 'Position', [48 500 500 500]);
    clf
end

set(gcf, 'Color', 'w');

TT = linspace(nanmin(T_ac)-0.5, nanmax(T_ac)+0.5); 
h_exp = plot(TT, TT, 'k-'); 
xlim([TT(1) TT(end)]);
ylim([TT(1) TT(end)]);
hold on
T_ac_pred = NaN(size(T_de)); 
T_ac_pred(vrmtrm) = BlockingTemperature(T_de(vrmtrm), t_de(vrmtrm)'*zero_field_factor, t_ac(vrmtrm), Tc, tau0); 
T_ac_pred(~vrmtrm) = BlockingTemperature(T_de(~vrmtrm), t_de(~vrmtrm)'*zero_field_factor, t_eff(~vrmtrm), Tc, tau0); 

good = ~isnan(T_ac_pred); 
p_fit = polyfit(T_ac(good), T_ac_pred(good), 2); 
T_pred_reg = polyval(p_fit, TT); 
h_trend = plot(TT, T_pred_reg, 'k--'); 

h = plot(T_ac(vrmtrm), T_ac_pred(vrmtrm), 'or', ...
     T_ac(~vrmtrm), T_ac_pred(~vrmtrm), 'dr'); 
h(1).MarkerSize = 10; 
h(1).MarkerFaceColor = 'w'; 
h(2).MarkerSize = 10; 
h(2).MarkerFaceColor = [1 .4 .2];
xlabel('Actual T_A [K]'); 
ylabel('Predicted T_A from nomograms [K]'); 
grid on
hold off

legend([h(1) h(2) h_exp h_trend], ...
    'Constant T (VRM)', 'Cooling (TRM)', ...
    'Expected trend', 'Actual trend', 'location', 'northwest'); 

set(gca, 'FontSize', 12);

export_fig(fullfile('../Output/', [sample, '_trend.pdf']));

