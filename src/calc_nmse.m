function nmse_db = calc_nmse(y_est, y_ref)
%CALC_NMSE  Normalized mean square error in dB between a model and a reference.
nmse_db = 10 * log10(sum(abs(y_est(:) - y_ref(:)).^2) / sum(abs(y_ref(:)).^2));
end
