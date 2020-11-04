function teff = EffectiveTimeField(T, r, tau0, Tc, eta)
    teff = tau0 .* exp( Lambert_W(T./(r.*tau0) .* (1-T./Tc)) ./ eta);
    teff(imag(teff)>0 | real(teff)<0) = NaN;
end