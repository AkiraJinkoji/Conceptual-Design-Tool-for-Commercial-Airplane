%% To do
% Input of altitude -> take the altitude of the phase before

function [v_mean,dv,q,n,dh, alpha,CD0,max_landing_weight] = constraint_approach(max_landing_weight, altitude, speed, descent_angle)

    alt_mean = altitude/2;
    [T,P, rho, v_air, delta, theta, sigma] = air_condition(alt_mean);

    % the weight assumed to be the maximum landing weight, assumed as 85%
    % convert KEAS to KTAS
    v_mean = convert_KEAS2KTAS(speed,alt_mean);

    % dv: approximation, constante acceleration
    dv = 0;

    % q
    q = 0.5 * rho * v_mean^2;

    % n : Lift approximately equals Weight
    n = 1;

    % climb rate
    dh = v_mean*sin(deg2rad(descent_angle));

    % alt_f
    alt_f = 0;
    
    % mach : approximate to its mean
    mach = v_mean / v_air; % Calculate Mach number from speed

    % alpha, lapse rate
    alpha = calculate_alpha(mach, sigma);

    % CD0, drag coefficient for 0 lift
    CD0 = calculate_CD0(mach,alt_mean);
end 
    

    