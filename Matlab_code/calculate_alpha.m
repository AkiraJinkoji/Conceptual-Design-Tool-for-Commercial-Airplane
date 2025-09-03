function alpha = calculate_alpha(mach, sigma)
% sigma, the ambient density ratio relative to standard sea level condition
% calculate CD0
alpha = (0.568 + 0.25 * (1.2 - mach)^3) * sigma^(0.6);
end