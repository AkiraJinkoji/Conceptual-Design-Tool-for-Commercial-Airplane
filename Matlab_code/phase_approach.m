%% To do
% Input of altitude -> take the altitude of the phase before

function [v_mean,dv,q,n,dh, alpha,CD0,alt_f, beta_phase] = phase_approach(alt_i,speed, descent_angle,W_to, W_i,S)
    
    % parmaters extracted by the air conditions
    alt_mean = alt_i/2;
    [T,P, rho, v_air, delta, theta, sigma] = air_condition(alt_i/2);
    
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
    
    %% weight fraction
    % time
    time = (alt_i)/dh;
    
    % power ratio - assumption
    power_ratio = 0.2;
    
    thrust_max = 30000; % (lbf) based on the PW1100G-JM datasheet
    [T_to,P_to, rho_to,v_air_to, delta_to, theta_to, sigma_to] = air_condition(0);
    % parameters values approximated in the case of takeoff
    beta_to = 1; % assume no fuel consumption 
    k_to = 1.2; % stall coefficient
    g0 = 32.2; % gravitationnal acceleration (ft/s2)
    thrust_max = 30000; % (lbf) based on the PW1100G-JM datasheet
    CL_max = 2.56; % A320-200 during takeoff
    v_to = k_to * sqrt((W_to / S) * (2 * beta_to) / (rho_to * CL_max));
    mach_to = v_to/v_air_to;
    % TSFC takeoff
    TSFC = calculate_TSFC(mach_to,theta_to);
    TSFC_hour = TSFC*3600;

    beta_phase = 1/W_i*(-TSFC*thrust_max*power_ratio*time)+1;
end 
    

    