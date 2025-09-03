function [v,dv,q,n,dh, alpha,CD0,alt_f, beta_phase] = phase_loiter(alt_i, time, v_i, S, W, k1)
    % assumption : endurance speed 

        % parmaters extracted by the air conditions - approximate the altitude by its means
    [T,P, rho,v_air, delta, theta, sigma] = air_condition(alt_i);
    
    % convert time
    time =60*time;
    %convert form KEAS to KTAS
    v_i = convert_KEAS2KTAS(v_i,alt_i);
    
    % mach : approximate to its mean
    mach_i = v_i / v_air; % Calculate Mach number from speed
    
    % CD0, drag coefficient for 0 lift
    CD0_i = calculate_CD0(mach_i,alt_i);   
    
    
    % v, endurance speed
    v = sqrt(2/rho*W/S*sqrt(k1/CD0_i));
    
    % iteration to obtain the endurance velocity
    iter_max = 10;
    for i = 1:1:iter_max
            % mach : approximate to its mean
            mach = v / v_air; % Calculate Mach number from speed
            
            % CD0, drag coefficient for 0 lift
            CD0 = calculate_CD0(mach,alt_i);   
            
            % v, endurance speed
            v = sqrt(2/rho*W/S*sqrt(k1/CD0));
    end
    
    
    % dv: approximation, constante acceleration
    dv = 0;

    % q
    q = 0.5 * rho * v^2;

    % n : Lift approximately equals Weight
    n = 1;

    % dh, climb rate
    dh = 0;

    % alt_f
    alt_f = alt_i;

    % range
    range = time/v;

    % alpha, lapse rate
    alpha = calculate_alpha(mach, sigma);
    
    % lift and draf ratio
    L_D_frac = sqrt(1/(4*k1*CD0));
    
    % calculate the weight fraction

    TSFC = calculate_TSFC(mach,theta);
    TSFC_hour = TSFC*3600;

    beta_phase = calculate_wf2wi_breguet_endurance(time, TSFC, L_D_frac);

end