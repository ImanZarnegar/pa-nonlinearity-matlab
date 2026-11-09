%% Memoryless PA nonlinearity: AM/AM, AM/PM, P1dB (Saleh, Rapp, polynomial)
% Run:  startup; run scripts/main.m
cfg = pa_config();
rng(cfg.seed);

% Amplitude sweep (start >0 so the gain is defined)
r = linspace(1e-3, cfg.sweep.r_max, cfg.sweep.num_points).';
pin_db = 20 * log10(r);                         % normalized input level [dB]

% Reference models
[y_saleh, amam_saleh, ampm_saleh] = pa_saleh(r, cfg.saleh);
amam_rapp = pa_rapp(r, cfg.rapp);

% Polynomial fits to the Saleh model (inside the fit range only)
fit_mask = r <= cfg.poly.fit_max;
n_orders = numel(cfg.poly.orders);
y_poly = zeros(numel(r), n_orders);
nmse_db = zeros(1, n_orders);
for k = 1:n_orders
    coeffs = pa_poly_fit(r(fit_mask), y_saleh(fit_mask), cfg.poly.orders(k));
    y_poly(:, k) = pa_poly_eval(r, coeffs);
    err = y_poly(fit_mask, k) - y_saleh(fit_mask);
    nmse_db(k) = 10*log10(sum(abs(err).^2) / sum(abs(y_saleh(fit_mask)).^2));
    fprintf('Poly order %d: NMSE in fit range = %.1f dB\n', ...
        cfg.poly.orders(k), nmse_db(k));
end

% Compression points
[r_p1_s, a_p1_s, g0_s] = find_p1db(r, amam_saleh, cfg.compression_db);
[r_p1_r, a_p1_r, g0_r] = find_p1db(r, amam_rapp, cfg.compression_db);
fprintf('Saleh: gain %.2f dB, input P1dB = %.2f dB, output P1dB = %.2f dB\n', ...
    g0_s, 20*log10(r_p1_s), 20*log10(a_p1_s));
fprintf('Rapp : gain %.2f dB, input P1dB = %.2f dB, output P1dB = %.2f dB\n', ...
    g0_r, 20*log10(r_p1_r), 20*log10(a_p1_r));

%% Plots
fig = figure('Name', 'PA nonlinearity', 'Position', [100 100 1100 800]);
tl = tiledlayout(fig, 2, 2, 'TileSpacing', 'compact');

nexttile; hold on; grid on;
plot(pin_db, 20*log10(amam_saleh), 'LineWidth', 1.5);
plot(pin_db, 20*log10(amam_rapp), 'LineWidth', 1.5);
plot(pin_db, pin_db + g0_s, 'k--');
plot(20*log10(r_p1_s), 20*log10(a_p1_s), 'ro', 'MarkerFaceColor', 'r');
xlabel('Input level [dB]'); ylabel('Output level [dB]');
title('AM/AM'); legend('Saleh', 'Rapp', 'Linear (Saleh gain)', 'P1dB (Saleh)', ...
    'Location', 'southeast');

nexttile; hold on; grid on;
plot(pin_db, 20*log10(amam_saleh ./ r), 'LineWidth', 1.5);
plot(pin_db, 20*log10(amam_rapp ./ r), 'LineWidth', 1.5);
yline(g0_s - cfg.compression_db, 'k--');
plot(20*log10(r_p1_s), g0_s - cfg.compression_db, 'ro', 'MarkerFaceColor', 'r');
xlabel('Input level [dB]'); ylabel('Gain [dB]');
title('Gain compression'); legend('Saleh', 'Rapp', '1 dB below small-signal', ...
    'P1dB (Saleh)');

nexttile; hold on; grid on;
plot(pin_db, rad2deg(ampm_saleh), 'LineWidth', 1.5);
plot(pin_db, rad2deg(angle(y_poly(:, end))), '--', 'LineWidth', 1.2);
xlabel('Input level [dB]'); ylabel('Phase shift [deg]');
title('AM/PM (Rapp has none)'); 
legend('Saleh', sprintf('Poly order %d', cfg.poly.orders(end)), 'Location', 'northwest');

nexttile; hold on; grid on;
plot(r, amam_saleh, 'LineWidth', 1.5);
for k = 1:n_orders
    plot(r, abs(y_poly(:, k)), '--', 'LineWidth', 1.2);
end
xline(cfg.poly.fit_max, ':');
xlabel('Input amplitude'); ylabel('Output amplitude');
title('Polynomial fit vs. Saleh (dotted line = fit limit)');
legend(['Saleh', compose('Poly order %d', cfg.poly.orders)], 'Location', 'northeast');
title(tl, 'Memoryless power amplifier nonlinearity');

if ~exist(cfg.results_dir, 'dir'), mkdir(cfg.results_dir); end
exportgraphics(fig, fullfile(cfg.results_dir, cfg.figure_name), 'Resolution', 150);
