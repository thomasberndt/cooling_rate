
if exist('sample', 'var')
    sample_in = input(sprintf('Sample name (default=%s): ', sample), 's'); 
    if isempty(sample_in)
        prev_sample = 1; 
    else
        sample = sample_in; 
        prev_sample = 0;
    end
else
    sample = input('Sample name: ', 's'); 
    prev_sample = 0; 
end

t = logspace(log10(10), log10(12000), 1000); 

[files, T_ac, t_ac, T_de, labels, vrmtrm] = GetAllDatafiles(sample, 'Input_All'); 

figure(1);
clf; 
T_acs_vrm = unique(T_ac(vrmtrm), 'sorted'); 
T_acs_trm = unique(T_ac(~vrmtrm), 'sorted'); 
T_acs = [T_acs_vrm; T_acs_trm];
vrmtrms = [ones(size(T_acs_vrm)); zeros(size(T_acs_trm))];
N = length(T_acs); 
X = 3;
Y = 2; 

h_fits = cell(size(T_acs));
legend_labels = cell(size(T_acs)); 

M = NaN(length(t), length(length(T_ac)));
dM = NaN(length(t), length(length(T_ac)));

figure(1); 
clf
set(gcf, 'Color', 'w');
figure(2); 
clf
set(gcf, 'Color', 'w');

for n = 1:length(T_ac)
    [M(:,n), dM(:,n), ~, M_raw, t_raw, M_offsets] = ...
                LoadVrmExperiment(fullfile('../Input_All', files{n}), t, 'tanhextra');

    k = find(T_acs==T_ac(n) & vrmtrms==vrmtrm(n)); 
    if k > 6
        figure(2); 
        subplot(X, Y, k-6); 
    else
        figure(1); 
        subplot(X, Y, k); 
    end
    h_fit = semilogx(t, M(:,n)*1e9, '-'); 
    hold on
    h_fits{k} = [h_fits{k}; h_fit];
    if vrmtrm(n)
        legend_labels{k} = cat(1, legend_labels{k} , {sprintf('%g s', t_ac(n))});
    else
        legend_labels{k} = cat(1, legend_labels{k} , {sprintf('%g K/min', t_ac(n))});
    end


    h_raw = semilogx(t_raw{1}, M_raw{1}*1e9, 'ok'); 
    hold on
    h_raw.MarkerSize = 2; 
    h_raw.Color = h_fit.Color; 
    h_raw.MarkerFaceColor = h_fit.Color; 

    for m = 2:length(M_raw)
        h_off = semilogx(t_raw{m}, (M_raw{m} + M_offsets(m-1))*1e9, 'or');
        h_no_off = semilogx(t_raw{m}, (M_raw{m})*1e9, 'ob');

        h_off.MarkerSize = 2; 
        h_off.Color = h_fit.Color; 
        h_off.MarkerFaceColor = h_fit.Color; 

        h_no_off.MarkerSize = 1; 
        h_no_off.Color = h_fit.Color; 
        h_no_off.MarkerFaceColor = h_fit.Color; 
    end


    legend(h_fits{k}, legend_labels{k});
    if vrmtrm(n)
        title(sprintf('VRM T_{ac}=%g K, T_{de}=%g K', T_ac(n), T_de(n)));
    else        
        title(sprintf('TRM T_{ac}=%g K, T_{de}=%g K', T_ac(n), T_de(n)));
    end
    xlabel('Time [s]'); 
    ylabel('M [nAm^2]'); 
    grid on
end

%%
s = input('Continue?', 's');
figure(1); 
export_fig(fullfile('../Output/Supplement', [sample, '_suppl_decay_1.pdf']));
figure(2); 
export_fig(fullfile('../Output/Supplement', [sample, '_suppl_decay_2.pdf']));

