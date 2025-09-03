function Wf2Wi = calculate_wf2wi_breguet_range(endurance, TSFC, L_D_frac)    
    Wf2Wi = exp(-endurance*TSFC/L_D_frac); %based on Breguet's range equation
end