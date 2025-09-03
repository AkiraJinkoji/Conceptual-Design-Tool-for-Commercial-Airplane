function [WSR, beta_phase] = phase_landing(v_i,k1,k2,beta)

    v_app = 1.2*v_i; % include k stall

    alt_i = 0;
    
    % convert keas to ktas
    v_app = convert_KEAS2KTAS(v_app,alt_i);

    % max lift coefficient
    CL_max = 2.56; % A320-200 during takeoff
    
    % parmaters extracted by the air conditions - approximate the altitude by its means
    [T,P, rho,v_air, delta, theta, sigma] = air_condition(alt_i/2);

    %convert rho from lb/ft3 to slug/ft3
    g0 = other_input_parameters.g0;
    %rho = rho/g0;
    
    mach = v_app/v_air;

    % weigh fraction
    endurance = 30*60; % regulation
    TSFC = calculate_TSFC(v_app/v_air, theta);
    CD0 = calculate_CD0(mach,alt_i);
    CD = k1*CL_max^2 + k2*CL_max + CD0; % max lift-drag ratio
    
    L_D_frac = CL_max/CD;
    beta_phase = calculate_wf2wi_breguet_endurance(endurance, TSFC, L_D_frac);

    % WSR
        WSR = 0.5*rho*CL_max*v_app^2 /beta;
        

end
