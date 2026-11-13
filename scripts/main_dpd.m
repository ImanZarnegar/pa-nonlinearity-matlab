%% PA with memory + OFDM test signal + memory polynomial DPD (ILA)
% Run:  startup; run scripts/main_dpd.m
cfg = pa_config();
rng(cfg.seed);

[x, info] = ofdm_generate(cfg.ofdm);
pa = @(u) pa_memory(u, cfg);
d = cfg.dpd;

y_off = pa(x);                                   % PA without DPD
u = dpd_ila(x, pa, d.K, d.Q, d.gain, d.n_iter);  % predistorted drive
y_on = pa(u);                                    % PA with DPD

acpr = @(s) calc_acpr(s, info.bw_norm, cfg.acpr_offset);
fprintf('PAPR of input    : %.1f dB\n', 20*log10(max(abs(x)) / sqrt(mean(abs(x).^2))));
fprintf('ACPR  no DPD     : %.1f dB\n', acpr(y_off));
fprintf('ACPR  with DPD   : %.1f dB\n', acpr(y_on));
fprintf('EVM   no DPD     : %.2f %%\n', calc_evm(y_off, info));
fprintf('EVM   with DPD   : %.2f %%\n', calc_evm(y_on, info));

[~, P_in, f]  = acpr(x);
[~, P_off]    = acpr(y_off);
[~, P_on]     = acpr(y_on);
norm_db = @(P, ref) 10*log10(P / max(ref));

fig = figure('Name', 'DPD', 'Position', [100 100 900 500]);
hold on; grid on;
plot(f, norm_db(P_off, P_off), 'LineWidth', 1.2);
plot(f, norm_db(P_on, P_off), 'LineWidth', 1.2);
plot(f, norm_db(P_in, P_in) , 'k--', 'LineWidth', 1.0);
xline([-1 1] * cfg.acpr_offset * info.bw_norm, ':');
xlabel('Normalized frequency'); ylabel('PSD [dB]');
title('Output spectrum: OFDM through PA with memory');
legend('PA without DPD', 'PA with DPD (ILA)', 'Input signal');
if ~exist(cfg.results_dir, 'dir'), mkdir(cfg.results_dir); end
exportgraphics(fig, fullfile(cfg.results_dir, cfg.dpd_figure_name), 'Resolution', 150);
