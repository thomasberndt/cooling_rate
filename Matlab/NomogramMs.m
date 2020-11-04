function h = NomogramMs(V, T, Ms, tau0, N, color) 
    if nargin < 6
        color = [0 0 0]; 
    end
    yr = 365.25*24*3600;
    
    ho = ishold(); 
    
    h = zeros(size(V));
    TT = linspace(min(T), max(T), 1000);
    MMs = interp1(T, Ms, TT); 
        
    for n = 1:length(V)
        t = RelaxationTime2(TT, V(n), N, MMs, tau0);
        h(n) = semilogy(TT, t, ...
                    'Color', color, 'LineWidth', 1);
        hold on
    end
    
    % Use sensible timescale
    set(gca,'YTick',[1,60,3600,24*3600, 30*24*3600, ...
            yr,10*yr, 100*yr, 1000*yr, 1e4*yr, 1e5*yr, 1e6*yr, ...
            1e7*yr, 1e8*yr 1e9*yr, 4.5e9*yr]);
    set(gca,'YTickLabel',{'1 s', '1 min', '1 hour', '1 day', '1 month', ...
            '1 yr', '10 yr', '100 yr', ...
            '1 ka', '10 ka', '100 ka', ...
            '1 Ma', '10 Ma', '100 Ma', '1 Ba', '4.6 Ba'});

%     grid on
%     axis([min(T), max(T), 60, 4.5e9*yr]);
    axis([52.5, 58.5, 200, 20000]);
    set(gca, 'YScale', 'log'); 
    
    xlabel('Blocking Temperature T_B [K]'); 
    ylabel('Relaxation time t [s]'); 
    
    if ho
        hold on
    else
        hold off
    end
    
end