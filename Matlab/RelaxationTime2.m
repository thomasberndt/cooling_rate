function t = RelaxationTime2(T, V, N, Ms, tau0)
    K = 273; 
    mu0 = pi*4e-7;
    k = 1.38e-23; 
    
    t = tau0/2 .* exp(mu0*Ms.^2.*N.*V ./ (k*T)); 
end