function [Tc, tau0, Tcs_g, tau0s_g, total_err, tau0ofTcs, errofTcs, ignorednan] = ...
        FindTcTau0(Tcs, tau0s, Ta, rA, Td, rD)
    K =273; 

    good = and(~isnan(Td),~isnan(rD)); 
    Ta = Ta(good);
    rA = rA(good);
    Td = Td(good);
    rD = rD(good);

    [Tcs_g, tau0s_g, Td_g] = meshgrid(Tcs, tau0s, Td);  
    [~,     ~      , rD_g] = meshgrid(Tcs, tau0s, rD); 
    [~,     ~      , Ta_g] = meshgrid(Tcs, tau0s, Ta); 
    [~,     ~      , rA_g] = meshgrid(Tcs, tau0s, rA); 
    
    tD_g = 2*EffectiveTime(Td_g, rD_g, tau0s_g, Tcs_g); 
    tA_g = EffectiveTime(Ta_g, rA_g, tau0s_g, Tcs_g); 
    Tp_g = BlockingTemperature(Ta_g,tA_g,tD_g,Tcs_g,tau0s_g); 
    err = (Tp_g - Td_g).^2; 
    total_err = sqrt(sum(err, 3)./size(err,3)); 
    
    [errofTcs, id] = min(total_err); 
    tau0ofTcs = tau0s(id);
    tau0ofTcs(isnan(errofTcs)) = NaN;  
    
    bad = logical(tau0ofTcs==max(tau0s)); 
    tau0ofTcs(bad) = NaN;
    errofTcs(bad) = NaN;
    
    Tc = Tcs_g(total_err==min(min(total_err)));
    tau0 = tau0s_g(total_err==min(min(total_err)));
    
    
    
    
    
    
    % now do the same, ignoring Tc-s where some VRMs do not fit
    

    Tcs_g = Tcs_g(:,:,1);
    tau0s_g = tau0s_g(:,:,1);
    
    err_ignorenan = err; 
    err_ignorenan(isnan(err_ignorenan)) = 0; 
    num_ignorenan = sum(~isnan(err),3);
    ignorednan = sum(isnan(err),3)>0;
    total_err = sqrt(sum(err_ignorenan, 3)./num_ignorenan); 
    
    
    [errofTcs, id] = min(total_err); 
    tau0ofTcs = tau0s(id);
    tau0ofTcs(isnan(errofTcs)) = NaN;  
    
    bad = logical(tau0ofTcs==max(tau0s)); 
    tau0ofTcs(bad) = NaN;
    errofTcs(bad) = NaN;
    
    Tcs_g = Tcs_g(:,:,1);
    tau0s_g = tau0s_g(:,:,1);
end
    
    