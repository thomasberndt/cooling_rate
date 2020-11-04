function teff = EffectiveTime(T, r, tau0, Tc)
    teff = tau0 ./ 2 .* exp( Lambert_W(2.*T./(r.*tau0) .* (1-T./Tc)) );
    teff(imag(teff)>0 | real(teff)<0) = NaN;
end