

function [M, dM, t, r, T_raw, M_raw] = LoadHeatingRateExperiment(filename, T, smoothing)

    warning('off', 'MATLAB:table:ModifiedVarnames');
    data = readtable(strcat('..\Input\', filename)); 
    warning('on', 'MATLAB:table:ModifiedVarnames');

    t_raw = data{2:end-1,1}; 
    T_raw = data{2:end-1,4}; 
    M_raw = data{2:end-1,5}/1e3;
    H_raw = data{2:end-1,3}/1e3;
    
    if any(H_raw > 0) 
        f = find(H_raw>0, 1, 'last'); 
        t_raw = t_raw(f+1:end);
        T_raw = T_raw(f+1:end);
        M_raw = M_raw(f+1:end);
        H_raw = H_raw(f+1:end);
    end
        

    t_raw = t_raw - t_raw(1);
    
    [M, dM] = SmoothM(M_raw, T_raw, smoothing, T); 
    [t, r] = SmoothM(t_raw, T_raw, smoothing, T); 
    r = 1./r; % K/s
end