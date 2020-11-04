

function [voltage, t, pos, reg_fit] = LoadRawData(filename)

    fid = fopen(strcat('..\Input\', filename)); 
    line = ''; 
    while ~strcmpi(line, '[Data]')
        line = fgetl(fid);
    end
    fgetl(fid);
    data = textscan(fid, ...
        '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f ', ...
        'Delimiter',',','EmptyValue', NaN);  
    fclose(fid);
    
    t = data{1};
    t = t-t(1);
    pos = data{8} / 100; 
    voltage = data{12}; 
    reg_fit = data{15}; 
    
    t = reshape(t, 32, length(t)/32)';
    pos = reshape(pos, 32, length(pos)/32)';
    voltage = reshape(voltage, 32, length(voltage)/32)';
    reg_fit = reshape(reg_fit, 32, length(reg_fit)/32)';
end
    