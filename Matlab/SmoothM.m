function [Msmooth, Mder, Mder2] = SmoothM(M, T, smoothing, Teval)
    
    if nargin < 4 
        Teval = T;
    end
    
    Msmooth = zeros(length(Teval),size(M,2));
    Mder = zeros(length(Teval),size(M,2));
    Mder2 = zeros(length(Teval),size(M,2));
    
    if size(M,2) > 1
        for n = 1:size(M,2)
            M2 = M(:,n);
            idx = logical(~isnan(M2)); 
            M3 = M2(idx);
            T3 = T(idx); 
            w = diff(T3); 
            w = [w w(end)];
            
            f1 = fit(T3, M3,  'smoothingspline', ...
                    'SmoothingParam', smoothing, ...
                    'Weights', w);
            Msmooth(:,n) = feval(f1, Teval);
            [Mder(:,n), Mder2(:,n)] = differentiate(f1, Teval);

            Msmooth(Teval<min(T),n) = NaN; 
            Msmooth(Teval>max(T),n) = NaN; 
            Mder(Teval<min(T),n) = NaN; 
            Mder(Teval>max(T),n) = NaN; 
            Mder2(Teval<min(T),n) = NaN; 
            Mder2(Teval>max(T),n) = NaN; 
        end
    else
        idx = logical(~isnan(M)); 
        M3 = M(idx);
        T3 = T(idx); 
        w = diff(T3); 
        w(end+1) = w(end);
        w = ones(size(T3)); 
        
        f1 = fit(T3, M3,  'smoothingspline', ...
                'SmoothingParam', smoothing, ...
                'Weights', w);
        Msmooth = feval(f1, Teval);
        [Mder, Mder2] = differentiate(f1, Teval);

        Msmooth(Teval<min(T)) = NaN; 
        Msmooth(Teval>max(T)) = NaN; 
        Mder(Teval<min(T)) = NaN; 
        Mder(Teval>max(T)) = NaN; 
        Mder2(Teval<min(T)) = NaN; 
        Mder2(Teval>max(T)) = NaN; 
    end
end