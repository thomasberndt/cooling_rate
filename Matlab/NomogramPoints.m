function [h_lines, h_as, h_vs] = NomogramPoints(Ta, ta, Tv, tv, marker_style_a, marker_style_v, line_style, extra) 
    if nargin < 7 
        line_style = 'k-'; 
    end
    if nargin < 8
        extra = ''; 
    end
    if nargin < 5
        marker_style_a = 'or'; 
        marker_style_v = 'ob'; 
    elseif nargin < 6
        marker_style_v = marker_style_a; 
    end
    

    ho = ishold(); 
    h_lines = cell(size(Ta));
    h_as = {}; 
    h_vs = {}; 
    
    for n = 1:length(Ta)
        h_lines{n} = semilogy([Ta(n) Tv(n)], [ta(n) tv(n)], line_style);
        
        if ~strcmpi(extra, 'nonan') || ~any(isnan([Ta(n) Tv(n) ta(n) tv(n)]))
            h_a = semilogy(Ta(n), ta(n), marker_style_a);
            h_a.MarkerFaceColor = h_a.Color; 
            h_as{end+1} = h_a; 
            h_v = semilogy(Tv(n), tv(n), marker_style_v);
            h_v.MarkerFaceColor = h_v.Color;  
            h_vs{end+1} = h_v;  
        end
        
        h_lines{n}.LineWidth = 2;
        hold on
    end
    
    if ho
        hold on
    else
        hold off
    end
end