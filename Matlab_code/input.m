%%% Input

%% Mission Profile
% Define total phases, phase types, and parameters
totalPhases = 18;
phaseTypes = {
    'taxi_inout', 'takeoff', 'climb_up', 'horizontal_acceleration', 'climb_up', ...
    'climb_up', 'cruise', 'descent', 'decelerate', 'approach', ...
    'climb_up', 'cruise', 'loiter', 'descent', 'decelerate', ...
    'approach', 'landing', 'taxi_inout'
};
phaseParams = {
    struct('time', 20),  % Phase 1: Taxi out
    struct('height_obs', 35, 'max_takeoff_dist', 5500),  % Phase 2: Takeoff
    struct('alt_i', 0, 'alt_f', 10000, 'climb_rate', 3000, 'speed', 250),  % Phase 3: Climb
    struct('alt_i', 10000, 'v_i', 250, 'v_f', 290, 'time', 1),  % Phase 4: Horizontal acceleration
    struct('alt_i', 10000, 'climb_rate', 4000, 'speed', 290, 'mach_f', 0.78),  % Phase 5: Climb until Mach 0.78
    struct('alt_f', 35000, 'climb_rate', 1500, 'mach_i', 0.78, 'mach_f', 0.78),  % Phase 6: Climb to 35,000 ft
    struct('alt_i', 35000, 'range', 3000, 'mach', 0.78),  % Phase 7: Cruise
    struct('alt_i', 35000, 'alt_f', 3000, 'descent_rate', 1500, 'speed', 250),  % Phase 8: Descend
    struct('alt_i', 3000, 'v_i', 250, 'v_f', 135),  % Phase 9: Decelerate
    struct('alt_i', 3000, 'speed', 135, 'descent_angle', 3),  % Phase 10: Approach
    struct('alt_i', 0, 'alt_f', 15000, 'climb_rate', 3000, 'speed', 250),  % Phase 11: Missed approach climb
    struct('alt_i', 15000, 'range', 200, 'speed', 250),  % Phase 12: Cruise at 15,000 ft
    struct('alt_i', 15000, 'time', 45, 'v_i', 250),  % Phase 13: Loiter
    struct('alt_i', 15000, 'alt_f', 3000, 'descent_rate', 1500, 'speed', 250),  % Phase 14: Descend to 3000 ft
    struct('alt_i', 3000, 'v_i', 250, 'v_f', 135),  % Phase 15: Decelerate
    struct('alt_i', 3000, 'speed', 135, 'descent_angle', 3),  % Phase 16: Approach at 3 degrees
    struct('v_i', 135),  % Phase 17: Landing
    struct('time', 20)  % Phase 18: Taxi in
};

% Create the MissionProfile instance
missionProfile = MissionProfile(totalPhases, phaseTypes, phaseParams);

%% Additional Constraints Input
totalConstraints = 5;
constraintTypes = {
    'gradient_climb', 'rate_climb_ceiling', 'max_mach_number', ...
    'steep_turn', 'approach'
};
constraintParams = {
    struct('climb_gradient', 0.05),  % Takeoff with one engine inoperative (climb gradient)
    struct('min_climb_rate', 300, 'alt_service_ceiling', 41000, 'mach', 0.78),  % Service ceiling with minimum climb rate
    struct('mach', 0.82, 'alt_i', 35000),  % Maximum Mach number at cruise altitude
    struct('bank_angle_deg', 45, 'alt', 39000, 'mach', 0.78),  % Steep turn performance
    struct('max_landing_weight', 0.85 * 73900, 'altitude', 3000, 'approach_speed', 135, 'descent_angle', 3)  % Approach at landing
};

additionalConstraints = AdditionalConstraints(totalConstraints, constraintTypes, constraintParams);

%% Other parameters 
% Define induced drag coefficient, payload/crew weights, initial guess for
% takeoff weight, wing surface and sea-level thrust

payload_weight = (190 + 30) * 150; 
crew_weight = 1050;

% initial guess
W_to_guess = 160000;   % takeoff weight
S_guess = 1300; % wing surface
T_sl_guess = 24700*2; % static thrust at sea level

% Create an instance of other_input_parameters
otherParameters = other_input_parameters(payload_weight, crew_weight, W_to_guess, S_guess, T_sl_guess);

%% maximum number of iteration for the tool
max_iteration = 12;

%% Run this function
[T_sl_final, W_to_final, S_final, EWF_final, FWF_final] = CA_MA_iteration(max_iteration, missionProfile, otherParameters, additionalConstraints);
