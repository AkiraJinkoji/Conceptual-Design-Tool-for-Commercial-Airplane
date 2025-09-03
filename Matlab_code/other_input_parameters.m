classdef other_input_parameters
    
    properties (Constant)
        g0 = 32.2; % ft/s2
        k1 = 0.0556;  % default value for k1
        k2 = -0.0197; % Default value for k2
    end
    
    properties
        payload_weight % weight of the payload
        crew_weight    % weight of the crew

        %initial guess
        W_to_guess
        S_guess
        T_sl_guess

    end
    
    
    methods

        function obj = other_input_parameters(payload_weight, crew_weight, W_to_guess, S_guess, T_sl_guess)
            obj.payload_weight = payload_weight;
            obj.crew_weight = crew_weight;
            obj.W_to_guess = W_to_guess;
            obj.S_guess = S_guess;
            obj.T_sl_guess = T_sl_guess;
        end
    end
end