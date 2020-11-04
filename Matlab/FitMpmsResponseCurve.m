function M = FitMpmsResponseCurve(voltage, pos)
    coil_sep = 15.19e-3; 
    coil_dia = 19.4e-3; 
    scan_length = 40e-3; 
    
    z_offsets = linspace(-scan_length/2, scan_length/2); 
    gofs = NaN(size(z_offsets));
    for n = 1:length(z_offsets)
        z_offset = z_offsets(n);

        fun = @(M, M_off, x) MpmsResponseCurve(x, coil_sep, coil_dia, scan_length, z_offset, M)- M_off;
        [f, gof] = fit(pos', voltage', fun, 'StartPoint', [0, 0]);
        gofs(n) = gof.rmse; 
    end
    
    [~, bestfit] = min(gofs); 
    z_offset = z_offsets(bestfit);

    fun = @(M, M_off, x) MpmsResponseCurve(x, coil_sep, coil_dia, scan_length, z_offset, M)- M_off;
    f = fit(pos', voltage', fun, 'StartPoint', [0, 0]);
    M = f.M;
    M_off = f.M_off; 
    plot(pos, voltage, 'or', pos, f(pos), 'xb-'); 
end