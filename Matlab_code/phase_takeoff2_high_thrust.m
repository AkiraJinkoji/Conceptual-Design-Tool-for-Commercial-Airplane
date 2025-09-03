function [TWR_range, beta_phase] = phase_takeoff2_high_thrust(height_obs, max_takeoff_dist, S, W_to, k1,k2, wsr_range)
%UNTITLED2 Summary of this function goes here
    %{
    Input
        alt_i - (feet)
        range - (feet)
        time - (sec)
        v_i - (ft/s)
        v_i - (ft/s)
    Output 
        V - (ft/s)
        q - (feet)
        n - (sec)
        alt_f - (feet)
        mach - (no dim)
        Wf2Wi - (no dim)
    %}
    
    % parameters values approximated in the case of takeoff
    alt_i = 0; % initial altitude
    beta = 1; % assume no fuel consumption 
    k_to = 1.2; % stall coefficient
    g0 = 32.2; % gravitationnal acceleration (ft/s2)
    thrust_max = 30000; % (lbf) based on the PW1100G-JM datasheet
    t_R = 3; %(sec) time for the rotation 
    climb_rate = 3000/60; % assumption from the instruction
    

    % max lift coefficient
    CL_max = 2.56; % A320-200 during takeoff
    
    % parmaters extracted by the air conditions - approximate the altitude by its means
    [T,P, rho,v_air, delta, theta, sigma] = air_condition(alt_i);
    
    % paramaters to consider for takeoff with high thrust
    k_to = 1.2;

    % takeoff speed
    v_to = k_to * sqrt((W_to / S) * (2 * beta) / (rho * CL_max));

    %mach
    mach_to = v_to/v_air;
    
    % radius of transition
    R_c =  (v_to^2) / (g0 * (0.8 * k_to^2 - 1));
    
    % climb angle
    theta_obs = acos(1-height_obs/R_c);

    % distances
    s_R = t_R * v_to; % rotation distance
    s_obs = R_c*sin(theta_obs);
    s_to = max_takeoff_dist;

    s_g = s_to - s_R - s_obs;
    
    % alpha, lapse rate
    alpha = calculate_alpha(mach_to, sigma);

    % constraint equation
    
    
    % Initialize output array for TWR values
    TWR_range = zeros(size(wsr_range)); % Preallocate for performance
    
    % Loop over each value in wsr_range to calculate TWR for each
    for i = 1:length(wsr_range)
        WSR = wsr_range(i);
        %TWR_range(i) = beta/alpha*(mu_to + (ksi_to*CL_max/k_to^2)/(1-exp(-s_g*rho*g0*ksi_to/beta/WSR)));
        TWR_range(i) = beta^2/alpha*k_to^2/(s_g*rho*g0*CL_max)*WSR;
    end

    % weight fraction
    time_clear = (s_g+s_R)/v_to;
    time_obs = (height_obs-0)/climb_rate;

    total_time = time_obs + time_clear;

    % TSFC
    TSFC = calculate_TSFC(mach_to,theta);
    TSFC_hour = TSFC*3600;

    beta_phase = 1/W_to*(-TSFC*thrust_max*total_time)+1;
end
