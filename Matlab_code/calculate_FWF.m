function [beta_w_i_2_w_to,FWF] = calculate_FWF(beta_w_iplus1_2_w_i)
    number_phases = length(beta_w_iplus1_2_w_i);
    beta_w_i_2_w_to = zeros(number_phases,1);
    total_passed_beta_f2i = 1;
    for i = 1:1:number_phases
        total_passed_beta_f2i = total_passed_beta_f2i * beta_w_iplus1_2_w_i(i)  ;
        beta_w_i_2_w_to(i,1) =  total_passed_beta_f2i;
    end
    w_n2w_to = beta_w_i_2_w_to(number_phases,1);

    FWF = 1.05 * (1-w_n2w_to);
end


    