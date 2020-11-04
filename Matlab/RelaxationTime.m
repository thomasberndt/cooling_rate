function t2 = RelaxationTime(T1, t1, T2, TC, tau0)
    K = 273; 
    t2 = tau0 ./ 2 .* exp(T1./T2.*(1-(T2-K)./(TC-K))./(1-(T1-K)./(TC-K)).*log(2.*t1./tau0));
end