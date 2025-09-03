function [TWR_range, beta_phase] = phase_takeoff(height_obs, max_takeoff_dist, S, W_to,T_sl, k1,k2, wsr_range)

    % parameters values approximated in the case of takeoff
    alt_i = 0; % initial altitude
    beta = 1; % assume no fuel consumption 
    k_to = 1.3; % stall coefficient
    g0 = 32.2; % gravitationnal acceleration (ft/s2)
    t_R = 3; %(sec) time for the rotation 
    climb_rate = 3000/60; % assumption from the instruction
    C_DR = 0.0015; % Drag for non-clean configuration
    
    % max lift coefficient
    CL_max = 2.56; % A320-200 during takeoff
    
    % parmaters extracted by the air conditions - approximate the altitude by its means
    [T,P, rho,v_air, delta, theta, sigma] = air_condition(alt_i);
    
    % convert rho from lb/ft3 to slug/ft3
    %rho = rho;

    % takeoff speed
    v_to = @(wsr) k_to * sqrt((wsr) * (2 * beta) / (rho * CL_max));

    %mach
    mach_to = @(wsr) v_to(wsr)/v_air;
    
    % radius of transition
    R_c =  @(wsr) (v_to(wsr)^2) / (g0 * (0.8 * k_to^2 - 1));
    
    % climb angle
    theta_obs = @(wsr) acos(1-height_obs/R_c(wsr));

    % distances
    s_R = @(wsr) t_R * v_to(wsr); % rotation distance
    s_obs = @(wsr) R_c(wsr)*sin(theta_obs(150));
    s_to = max_takeoff_dist;

    s_g = @(wsr) s_to - s_R(wsr) - s_obs(wsr);
    
    % friction takeoff coefficient 
    mu_to = 0.05;
    
    % alpha, lapse rate
    alpha = 1;

    % CD0, drag coefficient for 0 lift
    CD0 = @(wsr) calculate_CD0(mach_to(wsr),alt_i);
    
    % drag
    Cd = @(wsr) k1*CL_max^2 + k2*CL_max + CD0(wsr);

    ksi_to = @(wsr) Cd(wsr) + C_DR - mu_to*CL_max;

    % constraint equation
    
    
    % Initialize output array for TWR values
    TWR_range = zeros(size(wsr_range)); % Preallocate for performance
    ksi_to_range= zeros(size(wsr_range)); 
    s_g_range = zeros(size(wsr_range)); 
    % Loop over each value in wsr_range to calculate TWR for each
    for i = 1:length(wsr_range)
        WSR = wsr_range(i);
        ksi_to_range(i) = ksi_to(WSR);
        s_g_range(i) = s_g(WSR);
        TWR_range(i) = beta/alpha*(mu_to + (ksi_to(WSR)*k_to^2/CL_max)/(1-exp(-s_g(WSR)*rho*g0*ksi_to(WSR)/beta/WSR)));
    end

    % weight fraction
    time_clear = (s_g(W_to/S)+s_R(W_to/S))/v_to(W_to/S);
    time_obs = (height_obs-0)/climb_rate;

    total_time = time_obs + time_clear;

    % TSFC
    TSFC = calculate_TSFC(mach_to(W_to/S),theta);
    TSFC_hour = TSFC*3600;

    beta_phase = 1/W_to*(-TSFC*T_sl*total_time)+1;

end
