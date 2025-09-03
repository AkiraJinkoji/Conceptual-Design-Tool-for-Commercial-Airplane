%% To do
% Input of altitude -> take the altitude of the phase before

function [v_mean,dv,q,n,dh, alpha,CD0,alt_f, beta_phase] = phase_horizontal_acceleration(alt_i,v_i, v_f, time, range,k1)
    
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
    
    % time conversion
    time = 60*time;

    % parmaters extracted by the air conditions
    [T,P, rho, V_air, delta, theta, sigma] = air_condition(alt_i);
    
    % convert KEAS to KTAS
    v_i = convert_KEAS2KTAS(v_i,alt_i);
    v_f = convert_KEAS2KTAS(v_f,alt_i);
    
    % v : approximate to its mean during the phase
    v_mean = (v_f+v_i)/2;

    % dv: approximation, constante acceleration
    dv = (v_f-v_i)/time;

    % q
    q = 0.5 * rho * v_mean^2;

    % n : Lift approximately equals Weight
    n = 1;

    % climb rate
    dh = 0;

    % alt_f
    alt_f = alt_i;
    
    % determine time or range
    if isempty(range)
        if isempty(time)
            warning('need time or range as input');
        else
            % If speed is not given
            range = time * v_mean;        
        end
    else
        time = range/v_mean;
    end  
    % mach : approximate to its mean
    mach = v_mean / V_air; % Calculate Mach number from speed

    % alpha, lapse rate
    alpha = calculate_alpha(mach, sigma);

    % CD0, drag coefficient for 0 lift
    CD0 = calculate_CD0(mach,alt_i);
    
    % lift-drag ratio, assumed to maximize endurance for jet engine 
    L_D_frac = sqrt(1/(4*k1*CD0));
    
    % calculate the weight fraction

    TSFC = calculate_TSFC(mach,theta);
    TSFC_hour = TSFC*3600;

    % weight fraction
    beta_phase = calculate_wf2wi_breguet_endurance(time, TSFC, L_D_frac); 
end 
    

    