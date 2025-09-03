function [twr_cvg, wsr_cvg,beta_w_iplus1_2_w_i] = constraints_plots(missionProfile, additionalConstraints, W_to, S,T_sl, k, max_iteration)

    % Phase number
    number_phases = length(missionProfile.Phases);
    number_constraints = length(additionalConstraints.Constraint);

    % dataset for both axis : wsr, twr
    wsr_range = 0:0.1:250;
    twr_range = zeros(length(wsr_range), number_phases + 6);

    % constants
    k1 = other_input_parameters.k1;
    k2 = other_input_parameters.k2;

        % Initialize beta_w_iplus1_2_w_i, the list of beta for each mission phase
    beta_w_iplus1_2_w_i = ones(1, number_phases);
    beta = 1;
    % Loop over each phase to obtain the constraint plots for each of them
    for i = 1:number_phases

        % Extract phase type and parameters
        phase_type = missionProfile.getPhaseType(i);
        parameters = missionProfile.getPhaseParameters(i);
        
        % calculate beta = W_i/W_to
        
        if i >1
            beta_phase;
            beta = beta_phase * beta;
        end

        if strcmp(phase_type, 'cruise')
            % extract parameters
            if isfield(parameters, 'alt_i')
                alt_i = parameters.alt_i;
            else
                alt_i = [];
            end
            if isfield(parameters, 'range')
                range = parameters.range;
            else
                range = [];
            end
            if isfield(parameters, 'time')
                time = parameters.time;
            else
                time = [];
            end
            if isfield(parameters, 'speed')
                speed = parameters.speed;
            else
                speed = [];
            end
            if isfield(parameters, 'mach')
                mach = parameters.mach;
            else
                mach = [];
            end

            % call cruise function 
            [v, dv, q, n, dh, alpha, CD0, alt_f, beta_phase] = phase_cruise(alt_i, range, time, speed, mach, k1);
            beta_w_iplus1_2_w_i(1, i) = beta_phase;
            twr_range(:, i) = master_equation(v, dv, q, n, dh, alpha, CD0, wsr_range, beta);

        elseif strcmp(phase_type, 'climb_up')
            % extract parameters
            if isfield(parameters, 'alt_i')
                alt_i = parameters.alt_i;
            else
                alt_i = [];
            end
            if isfield(parameters, 'alt_f')
                alt_f = parameters.alt_f;
            else
                alt_f = [];
            end
            if isfield(parameters, 'climb_rate')
                climb_rate = parameters.climb_rate;
            else
                climb_rate = [];
            end
            if isfield(parameters, 'speed')
                speed = parameters.speed;
            else
                speed = [];
            end
            if isfield(parameters, 'mach_i')
                mach_i = parameters.mach_i;
            else
                mach_i = [];
            end
            if isfield(parameters, 'mach_f')
                mach_f = parameters.mach_f;
            else
                mach_f = [];
            end
            
            % call climb_up 
            [v, dv, q, n, dh, alpha, CD0, ~, beta_phase] = phase_constant_speed_climb(alt_i, alt_f, climb_rate, speed, mach_i, mach_f, k1);
            beta_w_iplus1_2_w_i(1, i) = beta_phase;
            twr_range(:, i) = master_equation(v, dv, q, n, dh, alpha, CD0, wsr_range, beta);

        elseif strcmp(phase_type, 'descent')
            % extract parameters
            if isfield(parameters, 'alt_i')
                alt_i = parameters.alt_i;
            else
                alt_i = [];
            end
            if isfield(parameters, 'alt_f')
                alt_f = parameters.alt_f;
            else
                alt_f = [];
            end
            if isfield(parameters, 'descent_rate')
                descent_rate = parameters.descent_rate;
            else
                descent_rate = [];
            end
            if isfield(parameters, 'speed')
                speed = parameters.speed;
            else
                speed = [];
            end
            if isfield(parameters, 'mach_i')
                mach_i = parameters.mach_i;
            else
                mach_i = [];
            end
            if isfield(parameters, 'mach_f')
                mach_f = parameters.mach_f;
            else
                mach_f = [];
            end

            % descent function and calculate twr_range
            [v, dv, q, n, dh, alpha, CD0, ~, beta_phase] = phase_descent(alt_i, alt_f, descent_rate, speed, mach_i, mach_f, k1);
            beta_w_iplus1_2_w_i(1, i) = beta_phase;
            twr_range(:, i) = master_equation(v, dv, q, n, dh, alpha, CD0, wsr_range, beta);

        elseif strcmp(phase_type, 'decelerate')
            % extract parameters
            if isfield(parameters, 'alt_i')
                alt_i = parameters.alt_i;
            else
                alt_i = [];
            end
            if isfield(parameters, 'v_i')
                v_i = parameters.v_i;
            else
                v_i = [];
            end
            if isfield(parameters, 'v_f')
                v_f = parameters.v_f;
            else
                v_f = [];
            end
        
            W_i = beta_phase * W_to;
        
            % Call decelerate functio
            [v, dv, q, n, dh, alpha, CD0, ~, beta_phase] = phase_decelerate(alt_i, v_i, v_f, k1, k2, W_i, S);
            beta_w_iplus1_2_w_i(1, i) = beta_phase;
            twr_range(:, i) = master_equation(v, dv, q, n, dh, alpha, CD0, wsr_range, beta);

        elseif strcmp(phase_type, 'horizontal_acceleration')
             
       % extract parameters
            if isfield(parameters, 'alt_i')
                alt_i = parameters.alt_i;
            else
                alt_i = [];
            end
            if isfield(parameters, 'v_i')
                v_i = parameters.v_i;
            else
                v_i = [];
            end
            if isfield(parameters, 'v_f')
                v_f = parameters.v_f;
            else
                v_f = [];
            end
            if isfield(parameters, 'time')
                time = parameters.time;
            else
                time = [];
            end
            if isfield(parameters, 'range')
                range = parameters.range;
            else
                range = [];
            end

            % Call horizontal_acceleration function
            [v, dv, q, n, dh, alpha, CD0,~,beta_phase] = phase_horizontal_acceleration(alt_i, v_i, v_f, time, range, k1);
            beta_w_iplus1_2_w_i(1, i) = beta_phase;

            twr_range(:, i) = master_equation(v, dv, q, n, dh, alpha, CD0, wsr_range, beta);

        elseif strcmp(phase_type, 'approach')
            % extract parameters
            if isfield(parameters, 'alt_i')
                alt_i = parameters.alt_i;
            else
                alt_i = [];
            end
            if isfield(parameters, 'speed')
                speed = parameters.speed;
            else
                speed = [];
            end
            if isfield(parameters, 'descent_angle')
                descent_angle = parameters.descent_angle;
            else
                descent_angle = [];
            end

            W_i = beta_phase * W_to;

            % approach 
            [v, dv, q, n, dh, alpha, CD0, ~, beta_phase] = phase_approach(alt_i, speed, descent_angle, W_to, W_i, S);
            beta_w_iplus1_2_w_i(1, i) = beta_phase;
            twr_range(:, i) = master_equation(v, dv, q, n, dh, alpha, CD0, wsr_range, beta);

        elseif strcmp(phase_type, 'loiter')
            % extract parameters
            if isfield(parameters, 'alt_i')
                alt_i = parameters.alt_i;
            else
                alt_i = [];
            end
            if isfield(parameters, 'time')
                time = parameters.time;
            else
                time = [];
            end
            if isfield(parameters, 'v_i')
                v_i = parameters.v_i;
            else
                v_i = [];
            end

            % Call loiter function
            W = W_to * beta_phase;
            [v, dv, q, n, dh, alpha, CD0, ~, beta_phase] = phase_loiter(alt_i, time, v_i, S, W, k1);
            beta_w_iplus1_2_w_i(1, i) = beta_phase;
            twr_range(:, i) = master_equation(v, dv, q, n, dh, alpha, CD0, wsr_range, beta);

        elseif strcmp(phase_type, 'landing')
            % extract parameters
            if isfield(parameters, 'v_i')
                v_i = parameters.v_i;
            else
                v_i = [];
            end

            % Call landing function
            [wsr_landing, beta_phase] = phase_landing(v_i,k1,k2, beta);
            beta_w_iplus1_2_w_i(1, i) = beta_phase;
            wsr_range_landing = wsr_landing * ones(1, length(wsr_range));

        elseif strcmp(phase_type, 'taxi_inout')
            % extract parameters
            if isfield(parameters, 'time')
                time = parameters.time;
            else
                time = [];
            end

            [beta_phase] = phase_taxi_inout(time, W_to,S);
            beta_w_iplus1_2_w_i(1, i) = beta_phase;
            %twr_range(:, i) = master_equation(v, dv, q, n, dh, alpha, CD0, wsr_range, beta);

        elseif strcmp(phase_type, 'takeoff')
           % extract parameters
            if isfield(parameters, 'height_obs')
                height_obs = parameters.height_obs;
            else
                height_obs = [];
            end
            if isfield(parameters, 'max_takeoff_dist')
                max_takeoff_dist = parameters.max_takeoff_dist;
            else
                max_takeoff_dist = [];
            end
            
            % takeoff function for high drag
            [TWR_range, beta_phase] = phase_takeoff(height_obs, max_takeoff_dist, S, W_to, T_sl, k1,k2, wsr_range);
            beta_w_iplus1_2_w_i(1, i) = beta_phase;
            twr_range(:, i) = TWR_range;

            % takeoff for high thrust
            [TWR_range, beta_phase] = phase_takeoff2_high_thrust(height_obs, max_takeoff_dist, S, W_to, k1,k2, wsr_range);
            twr_range(:, number_phases + number_constraints + 1) = TWR_range;

        end
    end

        % Iterate through the additional constraints provided
    for j = 1:number_constraints
        constraint_type = additionalConstraints.getConstraintType(j);
        params = additionalConstraints.getConstraintParameters(j);

        if strcmp(constraint_type, 'service_ceiling')
            [v, dv, q, n, dh, alpha, CD0] = constraint_service_ceilling(params.alt_service_ceilling, params.min_climb_rate, params.mach);
            twr_range(:, number_phases + j) = master_equation(v, dv, q, n, dh, alpha, CD0, wsr_range, beta);
        elseif strcmp(constraint_type, 'engine_inoperative_takeoff')
            TWR_range = constraint_engine_inoperative_takeoff(S, W_to, wsr_range, params.climb_gradient);
            twr_range(:, number_phases + j) = TWR_range;
        elseif strcmp(constraint_type, 'approach')
            [v, dv, q, n, dh, alpha, CD0, ~] = constraint_approach(params.max_landing_weight, params.altitude, params.approach_speed, params.descent_angle);
            twr_range(:, number_phases + j) = master_equation(v, dv, q, n, dh, alpha, CD0, wsr_range, beta);
        elseif strcmp(constraint_type, 'max_mach')
            [v, dv, q, n, dh, alpha, CD0] = constraint_max_mach(params.mach, params.alt_i);
            twr_range(:, number_phases + j) = master_equation(v, dv, q, n, dh, alpha, CD0, wsr_range, beta);
        elseif strcmp(constraint_type, 'steep_turn')
            [v, dv, q, n, dh, alpha, CD0] = constraint_steep_turn(params.alt, params.mach, params.bank_angle_deg);
            twr_range(:, number_phases + j) = master_equation(v, dv, q, n, dh, alpha, CD0, wsr_range, beta);
        end
    end
   %{
    % constraint for engine inoperative during takeoff
    [TWR_range] = constraint_engine_inoperative_takeoff(S, W_to,wsr_range);
    twr_range(:, number_phases + 1) = TWR_range;
    
    % compute constraint for approach
    [v, dv, q, n, dh, alpha, CD0, W_i] = constraint_approach();
    beta = W_i/W_to;
    %twr_range(:, number_phases + 5) = master_equation(v, dv, q, n, dh, alpha, CD0, wsr_range, beta);

    % constraint for steep turn
    [v, dv, q, n, dh, alpha, CD0] = constraint_steep_turn();
    beta = 1;
    twr_range(:, number_phases + 4) = master_equation(v, dv, q, n, dh, alpha, CD0, wsr_range, beta);
   %}
    % Search for the max TWR for each value of WSR such that WSR < wsr_landing
    valid_indices = wsr_range < wsr_landing;
    restricted_twr_range = twr_range(valid_indices, :);
    max_twr_each_wsr = max(restricted_twr_range, [], 2);
    [min_of_max_twr, min_index] = min(max_twr_each_wsr);
    wsr_at_min_of_max_twr = wsr_range(min_index);

    % Output
    wsr_cvg = wsr_at_min_of_max_twr;
    twr_cvg = min_of_max_twr;

    %% plot if final iteration
    
    if k == max_iteration
        % Create figure
        figure;
        hold on;

        % Plot the constraints for each phase and additional constraints
      
        for i = 1:number_phases + number_constraints + 1
            %special case for landing
            if i < number_phases + 1 
                phase_type = missionProfile.getPhaseType(i);
                if strcmp(phase_type, 'landing')
                    xline(wsr_landing, '--r', 'DisplayName',  ['Phase ', phase_type]); 
                   
                else
                    plot(wsr_range, twr_range(:, i), 'DisplayName', ['Phase ', phase_type]);
                end
            elseif i < number_phases + number_constraints + 1
                constraint_type = additionalConstraints.getConstraintType(i-number_phases); 
                plot(wsr_range, twr_range(:, i), 'DisplayName', ['Constraint ', constraint_type]);
            else
                plot(wsr_range, twr_range(:, i), 'DisplayName', ['Constraint ', 'takeoff such that T >> D+R']);
                %{
                if i == number_phases + 1
                    plot(wsr_range, twr_range(:, i), 'DisplayName', 'constraint for anomaly during takeoff');
                elseif i == number_phases + 2
                    plot(wsr_range, twr_range(:, i), 'DisplayName', 'constraint for service ceilling');
                elseif i == number_phases + 3
                    plot(wsr_range, twr_range(:, i), 'DisplayName', 'constraint for maximum mach number');
                elseif i == number_phases + 4
                    plot(wsr_range, twr_range(:, i), 'DisplayName', 'constraint for steep turn');
                elseif i == number_phases + 5
                    plot(wsr_range, twr_range(:, i), 'DisplayName', 'constraint for approach');
                elseif i == number_phases + 6
                    plot(wsr_range, twr_range(:, i), 'DisplayName', 'takeoff constraint for T >> D +R');
                end
                %}            
            end

        end

        
        % Plot the convergence point
        plot(wsr_cvg, twr_cvg, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r', 'DisplayName', 'Design Point');
        
        new_valid_indices = wsr_range > 30 & wsr_range < wsr_landing;
        new_restricted_twr_range = twr_range(new_valid_indices, :);
        new_max_twr_each_wsr = max(new_restricted_twr_range, [], 2);
 
        x_fill = [wsr_range(new_valid_indices), fliplr(wsr_range(new_valid_indices))];
        y_fill = [new_max_twr_each_wsr', ones(1, length(new_max_twr_each_wsr))];
        % Perform the fill to shade the area above max_twr_each_wsr
        fill(x_fill, y_fill, 'r', 'FaceAlpha', 0.2, 'EdgeColor', 'none', 'DisplayName', 'Design Space')

        % Formatting the plot
        xlabel('Wing loading (WSR)');
        ylabel('Thrust loading (TWR)');
        title('Constraint Plots Across All Phases');
        legend('show');
        xlim([0, max(wsr_range)]);
        ylim([0, 1]);  
        grid on;
        
        % Prepare the x and y data for filling
        y_limits = ylim;
        ymax = y_limits(2)+1;

        hold off;
    %end

end
