%% To do
% Input of altitude -> take the altitude of the phase before

function [v,dv,q,n,dh, alpha,CD0] = constraint_service_ceilling(alt_service_ceilling, min_climb_rate, mach)

    [T,P, rho, v_air, delta, theta, sigma] = air_condition(alt_service_ceilling);

    % v
    v = mach * v_air;
    
    %dv
    dv =0;

    % Dynamic pressure
    q = 0.5 * rho * v^2;

    % Load factor, n approximated to 1
    n = 1;

    % derivative of altitude
    dh = min_climb_rate/60 ;   
    
    
    % calculate alpha
    alpha = calculate_alpha(mach, sigma);

    % lift-drag ratio, assumed to minimize the thrust
    CD0 = calculate_CD0(mach,alt_service_ceilling);
end