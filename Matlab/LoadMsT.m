

function [Ms, T] = LoadMsT(filename)

    data = csvread(strcat('..\Input\', filename), 31, 0);
    t_file = data(:,1); 
    H_file = data(:,3);
    T_file = round(2*data(:,4)) ./ 2.0;
    M_file = data(:,5)/1e3;
    
    T = unique(T_file)'; 
    hys_T = [];
    hys_H = [];
    hys_M = [];
    Ms = [];
    for n = 1:length(T)
        M = M_file(T_file==T(n));
        H = round(H_file(T_file==T(n)))/1e4;
        para = find(H>(0.65*max(H))); 
        
        hys_H = [hys_H; H(para)]; 
        hys_M = [hys_M; M(para)]; 
%         id = find(H>=0, 1, 'first'); 
        Ms(n) = M(para(end));
        hys_T = [hys_T; T(n) * ones(size(H(para)))]; 
    end
    
    Ms = Ms / Ms(end) * 480e3;
end
    
    