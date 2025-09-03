function [v_mean,dv,q_mean,n,dh, alpha,CD0,alt_f, beta_phase] = phase_decelerate(alt,speed_i,speed_f, k1, k2, W_i,S)
    
%UNTITLED2 Summary of this function goes here
    %{
    Input
        alt_i - (feet)
        range - (feet)
        time - (sec)
        v_i - (KEAS)
        v_i - (KEAS)
    Output 
        V - (ft/s)
        q - (feet)
        n - (sec)
        alt_f - (feet)
        mach - (no dim)
        Wf2Wi - (no dim)
    %}
    % parmaters extracted by the air conditions
    [T,P, rho, v_air, delta, theta, sigma] = air_condition(alt);
    
        % convert KEAS to KTAS
    v_i = convert_KEAS2KTAS(speed_i,alt);
    v_f = convert_KEAS2KTAS(speed_f,alt);
    
    % v : approximate to its mean during the phase
    v_mean = (v_f+v_i)/2;
   
    % mach : approximate to its mean
    mach = v_mean / v_air; % Calculate Mach number from speed
    
    % CD0, drag coefficient for 0 lift
    CD0 = calculate_CD0(mach,alt);
    
    % q
    q_mean = 0.5 * rho * v_mean^2;

   
    g0 = 32.2; % gravitationnal acceleration (ft/s2)
    CL_mean = W_i/q_mean/S;
    CD_mean = k1*CL_mean^2 + k2*CL_mean + CD0;
    
    % time approximation - assume the acceleration is constant
    time = W_i * (v_i - v_f)/g0/q_mean/S/CD_mean;

    % dv: approximation, constante acceleration
    dv = (v_f-v_i)/time;

    % n : Lift approximately equals Weight
    n = 1;

    % climb rate
    dh = 0;

    % alt_f
    alt_f = alt;

    % alpha, lapse rate
    alpha = calculate_alpha(mach, sigma);

    % assume no fuel flow
    beta_phase = 1;
end