

function [Mt, dMt, Mf, dMf, T_raw, M_raw] = LoadFullTRM(filename, T, smoothing)

    warning('off', 'MATLAB:table:ModifiedVarnames');
    data = readtable(strcat('..\Input\', filename));
    warning('on', 'MATLAB:table:ModifiedVarnames'); 

    t_raw = data{:,1}; 
    H_raw = data{:,3}; 
    T_raw = data{:,4}; 
    M_raw = data{:,5}/1e3;

    t_raw = t_raw - t_raw(1);
    
    if isempty(M_raw(H_raw>0))
        Mf = []; 
        dMf = []; 
    else        
        [Mf, dMf] = SmoothM(M_raw(H_raw>0), T_raw(H_raw>0), smoothing, T); 
    end
    if isempty(M_raw(H_raw==0))
        Mt = Mf; 
        dMt = dMf;
    else
        [Mt, dMt] = SmoothM(M_raw(H_raw==0), T_raw(H_raw==0), smoothing, T); 
        if isempty(Mf)
            Mf = Mt; 
            dMf = dMt; 
        end
    end
    T_raw = T_raw(H_raw == 0);
    M_raw = M_raw(H_raw == 0);
end