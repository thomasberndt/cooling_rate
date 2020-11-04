function T2 = BlockingTemperature(T1, t1, t2, TC, tau0)
    T2 = 1./(1./TC+(1./T1-1./TC).*log(t2./tau0)./log(t1./tau0)); 
    T2(imag(T2)>0 | real(T2)<0) = NaN;
end