function [filenames, T_ac, t_ac, T_de, labels, vrmtrm] = GetAllDatafiles(sample, path)
% vrmtrm - 1 for VRM; 0 for TRM
    if nargin < 2
        path = 'Input'; 
    end

    filename_pattern = fullfile('..', path, sprintf('%s_*RMac_*_VRMde_*K.dc.dat', sample)); 
    files = dir(filename_pattern); 
    
    T_ac = NaN(size(files));
    t_ac = NaN(size(files));
    T_de = NaN(size(files));
    vrmtrm = NaN(size(files));
    filenames = cell(size(files));
    labels = cell(size(files));

    for n = 1:length(files)
        C = sscanf(files(n).name, sprintf('%s_VRMac_%%gK_%%gs_VRMde_%%gK.dc.dat', sample)); 
        if isempty(C)
            C = sscanf(files(n).name, sprintf('%s_TRMac_%%gK_%%gKmin_VRMde_%%gK.dc.dat', sample)); 
            vrmtrm(n) = 0;
        else
            vrmtrm(n) = 1;
        end
        T_ac(n) = C(1); 
        t_ac(n) = C(2); 
        T_de(n) = C(3); 
        filenames{n} = files(n).name; 
        if vrmtrm(n)
            labels{n} = sprintf(...
                'VRM T_{ac}: %g K, t_{ac}: %g s, T_{de}: %g K', ...
                T_ac(n), t_ac(n), T_de(n));
        else
            labels{n} = sprintf(...
                'TRM T_{ac}: %g K, r_{ac}: %g K/min, T_{de}: %g K', ...
                T_ac(n), t_ac(n), T_de(n));
        end
    end
    
    [~, i] = sortrows([vrmtrm, T_de, T_ac, t_ac]); 
    vrmtrm = logical(vrmtrm(i)); 
    T_de = T_de(i); 
    T_ac = T_ac(i); 
    t_ac = t_ac(i);
    labels = labels(i); 
    filenames = filenames(i); 
end