function z = MpmsResponseCurvePositions(coil_sep, scan_length, nsteps)
    n = 1:nsteps; 
    
    z1 = -scan_length/2 + coil_sep + (n-1) .* scan_length ./ (nsteps-1); 
    z2 = z1 - coil_sep; 
%     z3 = z2 - coil_sep; 
    z = z2 + scan_length/2; 
end