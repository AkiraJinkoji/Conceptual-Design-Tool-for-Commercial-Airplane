%% To do
% Input of altitude -> take the altitude of the phase before

function [v_mean,dv,q,n,dh, alpha,CD0,alt_f, beta_phase] = phase_constant_speed_climb(alt_i, alt_f, climb_rate, speed, mach_i, mach_f,k1)
    
    % convert climb rate from ft/min to ft/s
    climb_rate = climb_rate/60; 
    
    % alt_f, spedd (kea), mach_i, mach_f are interdependant
    %disp('i am here 1')

    if isempty(alt_f)
         % Calculate Mach number if speed is given, else calculate speed from Mach number
        if isempty(mach_f) & isempty(mach_i) 
            warning('need final altitude or final mach number as input');
        else % no alt-f, but mach_f or/and mach_i
            if isempty(speed)
                warning('need speed or final or inital mach number as input')
            else % no alt-f provided, speed, mach_f or/and mach_i provided
                % determine the final altitude
                v_i = convert_KEAS2KTAS(speed, alt_i); %KTAS at inital altitude
                v_air_f_deduced = v_i/mach_f; % Calculate airspeed from final mach number
                [T_f,P_f, rho_f, v_air_f, delta_f, theta_f, sigma_f, alt_f] = inverse_air_condition(mach_f, v_i);
                %disp('i am here phase 5')

                %disp('i am here phase 5.2')
                mach_f;
                v_f = v_air_f*mach_f;
                v_i;

            end
        end
    else  % alt_f is provided
        if isempty(mach_f) & isempty(mach_i) % alt_f yes, but no mach numbers
            if isempty(speed)
                warning("need speed or mach numbers as input")
            else % no mach numbers, alt_f and speed provided
                if isempty(alt_i)
                    alt_i = 3200;
                else
                    [T_i,P_i, rho_i, v_air_i, delta_i, theta_i, sigma_i] = air_condition(alt_i);
                    [T_f,P_f, rho_f, v_air_f, delta_f, theta_f, sigma_f] = air_condition(alt_f);
                
                    v_i= convert_KEAS2KTAS(speed,alt_i);
                    mach_i = v_i/v_air_i;
                    
                    v_f = convert_KEAS2KTAS(speed,alt_f);
                    mach_f = v_f/v_air_f;
                end
            end 
        else % final altitude and mach numbers are provided, don't know for speed
            %disp('i am here 3')
            if isempty(alt_i)
                    alt_i = 3200;
                [T_i,P_i, rho_i, v_air_i, delta_i, theta_i, sigma_i] = air_condition(alt_i);
                [T_f,P_f, rho_f, v_air_f, delta_f, theta_f, sigma_f] = air_condition(alt_f);
                %disp('i am here');

                v_i = mach_i * v_air_i;
                v_f = mach_f * v_air_f;
            else
                [T_i,P_i, rho_i, v_air_i, delta_i, theta_i, sigma_i] = air_condition(alt_i);
                [T_f,P_f, rho_f, v_air_f, delta_f, theta_f, sigma_f] = air_condition(alt_f);

                v_i = mach_i * v_air_i;
                v_f = mach_f * v_air_f;
            end 
        end
    end

    % average speed
    v_mean = (v_f+v_i)/2*1.1;

    % average altitude
    alt_mean = (alt_f+alt_i)/2;

    % mean air condition
    [T_mean,P_mean, rho_mean, v_air_mean, delta_mean, theta_mean, sigma_mean] = air_condition(alt_mean);

    % time
    time = (alt_f-alt_i)/climb_rate;

    % dv: approximation, constante acceleration
    dv = 0;

    % q
    q = 0.5 * rho_mean * v_mean^2;

    % n : Lift approximately equals Weight
    n = 1;

    % dh, climb rate
    dh = climb_rate;

    % alt_f
    alt_f = alt_f;

    % mach : approximate to its mean
    mach_mean = v_mean / v_air_mean; % Calculate Mach number from speed
    
    % alpha, lapse rate
    alpha = calculate_alpha(mach_mean, sigma_mean);

    % CD0, drag coefficient for 0 lift
    mach_mean;
    alt_mean;
    CD0 = calculate_CD0(mach_mean,alt_mean);   

    % lift-drag ratio, assumed to maximize endurance for jet engine 
    L_D_frac = sqrt(1/(4*k1*CD0));
    
    %TSFC
    TSFC = calculate_TSFC(mach_mean,theta_mean);
    TSFC_hour = TSFC*3600;

    % weight fraction
    beta_phase = calculate_wf2wi_breguet_endurance(time, TSFC, L_D_frac);
end 
    

    