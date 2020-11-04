function teff = EffectiveTimeMs(T, r, tau0, Ms, dMs)
    gamma = 1.781;
    BerndtFactor = 1; 
    teff = BerndtFactor*tau0 .* exp( Lambert_W(gamma*T./(r.*tau0) ./ (1-2*T./Ms.*dMs)) );
    teff(imag(teff)>0 | real(teff)<0) = NaN;
end