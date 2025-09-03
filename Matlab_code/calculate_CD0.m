function CD0 = calculate_CD0(mach,h)
    %{
    Input
        h - (feet)
        mach - (no dim)
    Output 
        CD0 - (no dim)
    %}
% calculate CD0
CD0 = 0.0311 * ((1 / sqrt(1 - mach^2) - 1.273)^2) ...
      - 0.0027 / sqrt(1 - mach^2) ...
      + 7.86e-8 * h + 0.0215;
end