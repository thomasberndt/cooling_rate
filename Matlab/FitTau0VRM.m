function [tau0, total_err] = FitTau0VRM(Tc, tau0s, TA, tA, TD, rD, eta)
    
    good = and(~isnan(TD),~isnan(rD)); 
    TA = TA(good);
    tA = tA(good);
    TD = TD(good);
    rD = rD(good);
    eta = eta(good);

    [tau0s_g, TD_g] = meshgrid(tau0s, TD);  
    [~      , rD_g] = meshgrid(tau0s, rD); 
    [~      , TA_g] = meshgrid(tau0s, TA); 
    [~      , tA_g] = meshgrid(tau0s, tA); 
    [~      , eta_g] = meshgrid(tau0s, eta); 
    
    tD_g = EffectiveTime(TD_g, rD_g, tau0s_g, Tc); 
    tA_adj_g = tA_g.^eta_g ./ (2*tau0s_g.^(eta_g-1)); 
    
    NVA_g = BlockingVolume(TA_g, tA_adj_g, Tc, tau0s_g);
    NVD_g = BlockingVolume(TD_g, tD_g,     Tc, tau0s_g);
    lnVA_g = log(NVA_g); 
    lnVD_g = log(NVD_g); 
    
    weight = 1; %(rD_g - 2*rA_g).^2; 
    err = weight .* ((lnVA_g - lnVD_g)./(lnVA_g + lnVD_g)).^2; 
    total_err = sqrt(sum(err, 1)./size(err, 1)); 
    
    tau0 = tau0s(find(total_err==min(total_err), 1, 'first'));
        
end
    
    