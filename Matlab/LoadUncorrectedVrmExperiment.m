

function [M, t, T, H, bad] = LoadUncorrectedVrmExperiment(filename)
    fid = fopen(strcat('..\Input\', filename)); 
    line = ''; 
    while ~strcmpi(line, '[Data]')
        line = fgetl(fid);
    end
    fgetl(fid);
    data = textscan(fid, ...
        '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f', ...
        'Delimiter',',','EmptyValue', NaN);  
    fclose(fid);
       
    t_raw = data{1}; 
    T_raw = data{4}; 
    M_raw = sign(data{5}(1)-data{5}(end))*data{5}/1e3;
    H_raw = data{3}/1e3;
    algo = data{7}; 
    
    t_raw = t_raw - t_raw(1) + t_raw(2) - t_raw(1);
    
    b = 3;
    
    bad = logical(algo ~= 3);
    if ~any(bad) || all(bad)
        M = {M_raw(1:end-b)}; 
        t = {t_raw(1:end-b)}; 
        T = {T_raw(1:end-b)}; 
        H = {H_raw(1:end-b)}; 
    else
        starts = [1; find(diff(bad(:))==-1)+1]; 
        ends = find(diff(bad)==1)-b;
        if ~bad(end)
            ends(end+1) = length(bad)-b; 
        end
        ends = ends(:);
        long_enough = find(ends-starts>=10); 
        if (long_enough(1) ~= 1)
            long_enough = [1 long_enough]; 
            ends(1) = ends(1) + b + 1;
        end
        
        M = cell(size(long_enough)); 
        t = cell(size(long_enough)); 
        T = cell(size(long_enough)); 
        H = cell(size(long_enough)); 
        
        for n = 1:length(long_enough)
            idx = starts(long_enough(n)):ends(long_enough(n))-1;
            M{n} = M_raw(idx); 
            t{n} = t_raw(idx); 
            T{n} = T_raw(idx); 
            H{n} = H_raw(idx); 
        end
    end
end