%% To do
% Input of altitude -> take the altitude of the phase before

function [v,dv,q,n,dh, alpha,CD0] = constraint_steep_turn(alt, mach, bank_angle_deg)

    bank_angle = deg2rad(bank_angle_deg);
    
    % parmaters extracted by the air conditions
    [T,P, rho, v_air, delta, theta, sigma] = air_condition(alt);
    
    %v
    v = mach * v_air;

    dv =0;
    
    % Dynamic pressure
    q = 0.5 * rho * v^2;

    % Load factor, n = 1 for level cruise flight
    n = 1/cos(bank_angle);

    % derivative of altitude
    dh = 0;
    
    % calculate alpha
    alpha = calculate_alpha(mach, sigma);

    % lift-drag ratio, assumed to minimize the thrust
    CD0 = calculate_CD0(mach,alt);
end