%% todo
% need beta
% need K1, K2
function twr_range = master_equation(v, dv, q, n, dh, alpha, CD0, wsr_range, beta)
    % Access k1 and k2 as constants from other_input_parameters
    k1 = other_input_parameters.k1;
    k2 = other_input_parameters.k2;
    
    % Constants
    g0 = 32.174; % ft/s^2

    % convert q from lb.ft-1.s-2 to slug;ft-1.s-2
    %q = q/g0;
    
    % Initialize output array for TWR values
    twr_range = zeros(size(wsr_range)); % Preallocate for performance
    
    % Loop over each value in wsr_range to calculate TWR for each
    for i = 1:length(wsr_range)
        WSR = wsr_range(i);
        twr_range(i) = (beta / alpha) * ( ...
            q / (beta * WSR) * ( ...
            k1 * (n * beta * WSR / q)^2 + ...
            k2 * (n * beta * WSR / q) + ...
            CD0 ) + ...
            (1 / v) * (dh) + dv/g0);
    end
end
