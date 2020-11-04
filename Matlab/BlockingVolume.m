function NVMs0 = BlockingVolume(T, t, TC, tau0)
    k = 1.38e-23; 
    mu0 =pi*4e-7;
    NVMs0 = k.*log(2*t./tau0)./(mu0.*(1./T-1./TC)); 
    NVMs0(imag(NVMs0)>0 | real(NVMs0)<0) = NaN;
end