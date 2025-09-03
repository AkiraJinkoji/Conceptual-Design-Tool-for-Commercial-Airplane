function v_ktas = convert_KEAS2KTAS(v_keas, altitude)
    [~, ~, ~, ~, ~, ~, sigma] = air_condition(altitude);
    v_ktas = v_keas/sqrt(sigma);
end
    