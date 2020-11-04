function h= Nomogram(Tc, tau0, minT, maxT, timescale, number_of_lines) 
    if nargin < 6
        number_of_lines=35;
    end
    ho = ishold(); 

    yr = 365.25*24*3600;
    T = linspace(minT,maxT);
    T_lines = linspace(minT-100, maxT+100, number_of_lines); 
    
    h = [];
    for n = 1:length(T_lines)
        c = log(timescale/tau0) / (1/T_lines(n) - 1/Tc); 
        lnt = log(tau0) + c * (1./T-1/Tc);
        hh = semilogy(T, exp(lnt),'Color', 0.5*[1 1 1]);
        h = [h; hh];
        hold on
    end
    
    
%     set(gca,'YTick',[1,10, 60, 5*60,3600,24*3600, 30*24*3600, ...
%             yr,10*yr, 100*yr, 1000*yr, 1e4*yr, 1e5*yr, 1e6*yr, ...
%             1e9*yr, 1e12*yr]);
%     set(gca,'YTickLabel',{'1 s', '10 s', '1 min',  ...
%             '5 min', ...
%             '1 h', '1 day', '1 m', ...
%             '1 yr', '10 yr', '100 yr', ...
%             '1 ka', '10 ka', '100 ka', ...
%             '1 Ma', '1 Ba', '1 Ta'});

    grid on
    axis([minT,maxT,100,3e4]);
    
    xlabel('Blocking Temperature T_B [K]'); 
    ylabel('Relaxation time t [s]'); 
    
    if ho
        hold on
    else
        hold off
    end
end