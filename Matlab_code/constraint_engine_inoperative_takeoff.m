function [TWR_range] = constraint_engine_inoperative_takeoff(S, W_to,wsr_range, climb_gradient)

    % max lift coefficient
    CL_max = 2.56; % A320-200 during takeoff
  
    % induced drag coefficient
    k1 = other_input_parameters.k1;
    k2 = other_input_parameters.k2;

    % parameters values approximated in the case of takeoff
    alt = 0; % initial altitude
    beta = 1; % assume no fuel consumption 
    k_to = 1.3; % stall coefficient
    mu_to = 0.03; % Ground roll friction coefficient
    

% atmospheric conditions
[T,P, rho, v_air, delta, theta, sigma] = air_condition(alt);

        % takeoff speed
    v_to = k_to * sqrt((W_to / S) * (2 * beta) / (rho * CL_max));

        %mach
    mach_to = v_to/v_air;
   
   % Calculate dynamic pressure
   q = 0.5 * rho * v_to^2;

   % beta assumed to be approximately 1
   beta = 1;

   % alpha, lapse rate
   alpha = calculate_alpha(mach_to,sigma);

   % CD0, drag coefficient for 0 lift
    CD0 = calculate_CD0(mach_to,alt);

    % drag
    Cd = k1*CL_max^2 + k2*CL_max + CD0;

    ksi_to = Cd - mu_to*CL_max;


    % Initialize output array for TWR values
    TWR_range = zeros(size(wsr_range)); % Preallocate for performance
    
    % Loop over each value in wsr_range to calculate TWR for each
    for i = 1:length(wsr_range)
        WSR = wsr_range(i);
        TWR_range = (beta / alpha) * (ksi_to * (q / beta) * (1 / WSR) + mu_to + climb_gradient);
    end
end


