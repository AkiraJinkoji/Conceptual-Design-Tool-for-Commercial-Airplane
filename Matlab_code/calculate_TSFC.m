function TSFC = calculate_TSFC(mach,theta)
%{
    Input
         mach - (no dim)
        theta - (no dim)
    Output 
        TSFC - lb/(lbf·s)
    %}

    % technology factor for fuel flow
    k_TSFC = 0.64;
    % calculate CD0
    TSFC = k_TSFC * (0.45 + 0.54 * mach)*sqrt(theta)/3600;
end