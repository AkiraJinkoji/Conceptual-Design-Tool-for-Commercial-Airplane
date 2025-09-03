function Wf2Wi = calculate_wf2wi_breguet_range(range, TSFC, v, L_D_frac)
    g0 = 32.17405; %ft/s2
    Wf2Wi = exp(-range*TSFC/v /L_D_frac); %based on Breguet's range equation
end