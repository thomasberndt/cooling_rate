function [filename, label] = GetDatafile(sample, vrmtrm, T_ac, t_ac, T_de)
    [filenames, T_acs, t_acs, T_des, labels] = GetAllDatafiles(sample, vrmtrm); 
    idx = logical(T_acs==T_ac & t_acs==t_ac & T_des==T_de); 
    if any(idx)
        filename = filenames{idx}; 
        label = labels{idx}; 
    else
        filename = []; 
        label = [];
    end
end