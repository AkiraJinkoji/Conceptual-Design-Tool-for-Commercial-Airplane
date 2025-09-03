function [T_sl_final, W_to_final, S_final, w_e_final, w_f_final] = CA_MA_iteration(max_iteration, missionProfile, otherParameters, additionalConstraints)
    
    % initialize parmaters
    w_c = otherParameters.crew_weight;
    w_p = otherParameters.payload_weight;
    w_to = otherParameters.W_to_guess;
    S = otherParameters.S_guess;
    T_sl = otherParameters.T_sl_guess;
    disp(w_to)
    for k = 1:1:max_iteration      
        
        fprintf('Begin iteration %d\n', k);
        
        number_phases = length(missionProfile.Phases);

        % update constraint analysis and S, T_sl
        [twr_cvg, wsr_cvg,beta_w_iplus1_2_w_i] = constraints_plots(missionProfile,additionalConstraints,w_to, S,T_sl,k, max_iteration);
        
        beta_w_iplus1_2_w_i;
        % update empty weight fraction
        EWF = calculate_EWF(w_to);
    
        % update fuel weight fraction
        [beta_w_i_2_w_to,FWF] = calculate_FWF(beta_w_iplus1_2_w_i);
    
        % update takeoff weight
        w_to = (w_c + w_p)/(1-FWF-EWF);

        % T_sl and S
        T_sl  = twr_cvg * w_to;
        S = w_to/wsr_cvg;

        % empty and fuel weight
        w_e = w_to*EWF;
        w_f = w_to*FWF;

        fprintf('Results of iteration %d\n', k);
        w_c
        w_p
        twr_cvg
        wsr_cvg
        T_sl
        S
        w_to
        EWF
        FWF
    end

    % plot the weights breakdown pie chart
    weights = [w_p, w_c, w_f, w_e];  % Percentages for payload, crew, fuel, empty weight
    labels = {'Payload Weight', 'Crew Weight', 'Fuel Weight', 'Empty Weight'};
    figure;
    pie(weights, labels);
    title('Weight breakdown of the aircraft');

    % plot the evalution of beta
    figure;
    hold on;
    list_phases = get_list_phases(missionProfile);
    plot(1:1:length(beta_w_i_2_w_to), beta_w_i_2_w_to);
    title('Evolution of weight fraction W/Wto during the mission');
    xlabel('Mission phases');
    ylabel('Weight fraction W/Wto');
    set(gca, 'XTick', 1:length(list_phases), 'XTickLabel', list_phases, 'XTickLabelRotation', 45);
    xlim([0, length(beta_w_i_2_w_to)]);
    ylim([0, 1]);
    grid on;
    hold off;



    % display final results
    disp('final results');
    twr_final = twr_cvg
    wsr_final = wsr_cvg 
    T_sl_final = T_sl
        S_final = S
    W_to_final = w_to
    w_f_final = w_f
    w_e_final = w_e
end