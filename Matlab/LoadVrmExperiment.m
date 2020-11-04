

function [M, dM, t, M_raw, t_raw, M_offsets] = LoadVrmExperiment(filename, t, extra, omit)
    if nargin < 3
        extra = [];
    end
    if nargin < 4
        omit = 0; 
    end
    [M_raw, t_raw, ~, ~, bad] = LoadUncorrectedVrmExperiment(filename);
%     if all(bad)
%         omit = 10; 
%     end
    M_raw{1} = M_raw{1}(omit+1:end);
    t_raw{1} = t_raw{1}(omit+1:end);
    
    if nargin < 3 || isempty(t)
        t = logspace(log10(t_raw{1}(1)), log10(t_raw{end}(end)), 1000); 
    end 
    lnt = log(t); 
    
    if strcmpi(extra, 'tanh')
        fun = @(a, b, c, d, x) -a*(tanh(b*(x-c))-d);
        
        M_offsets = zeros(length(M_raw)-1, 1); 
        offset_change = Inf; 
        
        M_complete = M_raw{1}(:); 
        t_complete = t_raw{1}(:); 
        
        M_off = min(M_complete); 
        M_range = max(M_complete) - M_off;
        M_fit = 2*(M_complete - M_off) / M_range - 1; 
        lnt_off = min(log(t_complete)); 
        lnt_range = max(log(t_complete)) - lnt_off; 
        lnt_fit = 2*(log(t_complete) - lnt_off) / lnt_range - 1;
        w = diff(lnt_fit(:));
        w(end+1) = w(end); 
%       w(1:2) = w(end-1:end);
        w = ones(size(w));
        f = fit(lnt_fit(1:length(M_fit)), M_fit, fun, ...
                'StartPoint', [1 1 0 0], ...
                'Lower', [0 0 -100 -100], ...
                'Weights', w(1:length(M_fit))); 
            
        lnt_fit = 2*(lnt - lnt_off) / lnt_range - 1;
        M = (f(lnt_fit)+1)/2*M_range+M_off;
        M(t>t_raw{1}(end)) = NaN; 
    elseif strcmpi(extra, 'tanhextra')
        fun = @(a, b, c, d, x) -a*(tanh(b*(x-c))-d);
        
        M_offsets = zeros(length(M_raw)-1, 1); 
        offset_change = Inf; 
        
        while offset_change > 1e-3 * abs(max(cat(1, M_raw{:}))-min(cat(1, M_raw{:})))
            M_complete = M_raw{1}(:); 
            t_complete = t_raw{1}(:); 
            if offset_change < Inf
                for n = 1:length(M_offsets)
                    M_complete = [M_complete; M_offsets(n)+M_raw{n+1}(:)]; 
                    t_complete = [t_complete; t_raw{n+1}(:)]; 
                end
            else
                for n = 1:length(M_offsets)
                    t_complete = [t_complete; t_raw{n+1}(:)]; 
                end
            end

            M_off = min(M_complete); 
            M_range = max(M_complete) - M_off;
            M_fit = 2*(M_complete - M_off) / M_range - 1; 
            lnt_off = min(log(t_complete)); 
            lnt_range = max(log(t_complete)) - lnt_off; 
            lnt_fit = 2*(log(t_complete) - lnt_off) / lnt_range - 1;
            w = diff(lnt_fit(:));
            w(end+1) = w(end); 
%             w(1:2) = w(end-1:end);
%             w = ones(size(w));
            f = fit(lnt_fit(1:length(M_fit)), M_fit, fun, ...
                    'StartPoint', [1 1 0 0], ...
                    'Lower', [0 0 -100 -100], ...
                    'Weights', w(1:length(M_fit))); 
            
            offset_change = 0;
            for n = 1:length(M_offsets)
                lnt_n = 2*(log(t_raw{n+1}) - lnt_off) / lnt_range - 1;
                M_n = (f(lnt_n)+1)/2*M_range+M_off; 
                new_offset = -mean(M_raw{n+1}(1:5) - M_n(1:5));
                offset_change = offset_change + abs(M_offsets(n) - new_offset); 
                M_offsets(n) = new_offset;
            end
                        
            M_it = (f(lnt_fit)+1)/2*M_range+M_off; 
%             plot(log(cat(1, t_raw{:})), cat(1, M_raw{:}), 'k-', ...
%                  log(t_complete), M_it, 'r-', ...
%                  log(t_complete(1:length(M_complete))), M_complete, 'ob');
        end
        lnt_fit = 2*(lnt - lnt_off) / lnt_range - 1;
        M = (f(lnt_fit)+1)/2*M_range+M_off;
        M(t>t_raw{end}(end)) = NaN; 
    else 
        M_offsets = 0;
        M = M_raw{1};
        t = t_raw{1};
    end
    
    dM = diff(M); 
    dM(end+1) = dM(end); 
end