

function [Ms, dMs] = LoadMsTHysteresis(filename, T)

    data = csvread(strcat('..\Input\', filename), 31, 0);
    t_file = data(:,1); 
    H_file = data(:,3);
    T_file = round(2*data(:,4)) ./ 2.0;
    M_file = data(:,5)/1e3;
    
    TT = unique(T_file); 
    hys_T = [];
    hys_H = [];
    hys_M = [];
    for n = 1:length(TT)
        M = M_file(T_file==TT(n));
        H = round(H_file(T_file==TT(n)))/1e4;
        para = H>(0.65*max(H)); 
        
        hys_H = [hys_H; H(para)]; 
        hys_M = [hys_M; M(para)]; 
        hys_T = [hys_T; TT(n) * ones(size(H(para)))]; 
    end
        
    fT0 = 293;
    ft = fittype('Ms0*((Tc-T)/(Tc-T0))^n + C*(H/T)^m', ...
                 'problem',{'T0'}, ...
                 'independent',{'T', 'H'}, ...
                 'coefficients',{'Ms0','C','n','Tc','m'}); 
    fo = fitoptions('Method','NonlinearLeastSquares',...
                    'Lower',[-Inf, -Inf,-Inf, 0,0],...
                    'Upper',[Inf, Inf, Inf, Inf,2],...
                    'StartPoint',[max(hys_M), 1, 0.43, 853,1]);
    f = fit([hys_T, hys_H], hys_M, ft, fo, 'problem', {fT0});
    C = coeffvalues(f); 
    fMs0 = C(1);
    fC = C(2); 
    fn = C(3); 
    fTc = C(4);
    fm = C(5);
%     disp(strcat('Ms0: ', num2str(fMs0)));
%     disp(strcat('Tc : ', num2str(fTc)));
%     disp(strcat('n  : ', num2str(fn)));
%     disp(strcat('C  : ', num2str(fC)));
%     disp(strcat('m  : ', num2str(fm)));
    Ms = NaN * zeros(size(TT)); 
    dMs = NaN * zeros(size(TT)); 
    for n = 1:length(T)
        Ms(n) = fMs0*((fTc-T(n))./(fTc-fT0)).^fn;
        dMs(n) = -1./(fTc-fT0).*fMs0*((fTc-T(n))./(fTc-fT0)).^(fn-1);
    end
    
end
    
    