function flux = MpmsResponseCurve(z, coil_sep, coil_dia, scan_length, z_offset, M)
    mu0 = pi*4e-7; 
    coil_r = coil_dia / 2; 
    
    z2 = z - scan_length/2;  
    z3 = z2 - coil_sep; 
    z1 = z2 + coil_sep; 
    
    flux1 = -mu0/2 * M * coil_r^2 ./ (coil_r^2 + (z1-z_offset).^2).^(3/2);
    flux2 = +mu0/2 * M * coil_r^2 ./ (coil_r^2 + (z2-z_offset).^2).^(3/2);
    flux3 = -mu0/2 * M * coil_r^2 ./ (coil_r^2 + (z3-z_offset).^2).^(3/2);
    
    flux = flux1 + flux2 + flux3; 
end