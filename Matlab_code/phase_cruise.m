%% To do
% Input of altitude -> take the altitude of the phase before

function [v,dv,q,n,dh, alpha,CD0,alt_f, beta_phase] = phase_cruise(alt_i,range, time, speed, mach,K1)
    
%UNTITLED2 Summary of this function goes here
    %{
    Input
        alt_i - (feet)
        range - (feet)
        time - (sec)
        speed - (ft/s)
        mach - (no dim)
        K1 - (no dim)
    Output 
        V - (ft/s)
        q - (feet)
        n - (sec)
        alt_f - (feet)
        mach - (no dim)
        Wf2Wi - (no dim)
    %}
    % parmaters extracted by the air conditions
    [T,P, rho, v_air, delta, theta, sigma] = air_condition(alt_i);
    
    % Calculate Mach number if speed is given, else calculate speed from Mach number
    if isempty(speed)
        if isempty(mach)
            warning('need speed or mach number as input');
        else
            % If speed is not given
            v = mach * v_air; % Calculate speed from Mach
        end
    else
        % If speed is given, calculate Mach from speed
        v = convert_KEAS2KTAS(speed, alt_i); % Use given speed
        mach = v / v_air; % Calculate Mach number from speed
    end
    dv =0;
    v;
    % Dynamic pressure
    q = 0.5 * rho * v^2;

    % Load factor, n = 1 for level cruise flight
    n = 1;

    % derivative of altitude
    dh = 0;
    
    % determine time or range
    if isempty(range)
        if isempty(time)
            warning('need time or range as input');
        else
            % If speed is not given
            range = time * v;        
        end
    else
        range = convert_nautical_miles2feet(range);
        time = range/v;
    end    
    
    time_hour = time/3600;
    
    % calculate alpha
    alpha = calculate_alpha(mach, sigma);
    %altitude final
    alt_f = alt_i;

    % lift-drag ratio, assumed to minimize the thrust
    CD0 = calculate_CD0(mach,alt_i);
    L_D_frac = sqrt(1/(4*K1*CD0));
    
    % calculate the weight fraction

    TSFC = calculate_TSFC(mach,theta);
    TSFC_hour = TSFC*3600;

    beta_phase = calculate_wf2wi_breguet_range(range, TSFC, v, L_D_frac);
end