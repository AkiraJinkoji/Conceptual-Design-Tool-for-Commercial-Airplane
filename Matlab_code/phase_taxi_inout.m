function [beta_phase] = phase_taxi_inout(time, W_to, S)
    % no constraint from this mission phase
    
    % convert time from min to sec
    time = time*60;

    % weight fraction
    
    % power ratio - assumption
    power_ratio = 0.1;
    
    [T,P, rho,v_air, delta, theta, sigma] = air_condition(0);
    
    % parameters values approximated in the case of takeoff
    beta_to = 1; % assume no fuel consumption 
    k_to = 1.2; % stall coefficient
    g0 = 32.2; % gravitationnal acceleration (ft/s2)
    thrust_max = 30000; % (lbf) based on the PW1100G-JM datasheet
    CL_max = 2.56; % A320-200 during takeoff
    v_to = k_to * sqrt((W_to/ S) * (2 * beta_to) / (rho * CL_max));
    mach_to = v_to/v_air;
    % TSFC takeoff
    TSFC = calculate_TSFC(mach_to,theta);
    TSFC_hour = TSFC*3600;

    beta_phase = 1/W_to*(-TSFC*thrust_max*power_ratio*time)+1;
end
