

function [r_B, r, T_B, t, H] = LoadHeatingRateEnv(filename, T, smoothing)

    warning('off', 'MATLAB:table:ModifiedVarnames');
    data = readtable(strcat('..\Input\', strrep(filename,'.rso.','.env.'))); 
    warning('on', 'MATLAB:table:ModifiedVarnames');
    
    t_raw = data{:,1}; 
    T_raw = data{:,2}; 
    H_raw = data{:,3}/1e3;
    
    if any(H_raw > 0) 
        f = find(H_raw>0, 1, 'last'); 
        t_raw = t_raw(1:f);
        T_raw = T_raw(1:f);
        H_raw = H_raw(1:f);
        f = find(H_raw>0, 1, 'first');
        T_B = T_raw(f); 
    end
        

    t_raw = t_raw - t_raw(1);
    
    [H] = SmoothM(H_raw, T_raw, smoothing, T); 
    [t, r] = SmoothM(t_raw, T_raw, smoothing, T); 
    r = -1./r; % K/s
    f = find(T>=T_B, 1, 'first'); 
    r_B = r(f); 
end