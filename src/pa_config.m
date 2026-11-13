function cfg = pa_config()
%PA_CONFIG  Central parameters for the memoryless PA modeling project.
%   cfg = PA_CONFIG() returns a struct. All amplitudes are normalized
%   (input amplitude r = 1 corresponds to 0 dB reference).
%
%   Saleh values: A. Saleh, IEEE Trans. Commun., 1981 (TWT example).
%   Rapp values: typical solid-state PA smoothness p = 2.

cfg.seed = 42;

cfg.sweep.r_max      = 2.0;     % max input amplitude of the sweep
cfg.sweep.num_points = 2000;    % points in the amplitude sweep

cfg.saleh.alpha_a   = 2.1587;   % AM/AM small-signal gain (linear)
cfg.saleh.beta_a    = 1.1517;   % AM/AM saturation parameter
cfg.saleh.alpha_phi = 4.0033;   % AM/PM max-phase parameter (rad)
cfg.saleh.beta_phi  = 9.1040;   % AM/PM saturation parameter

cfg.rapp.gain       = 2.0;      % small-signal gain (linear)
cfg.rapp.a_sat      = 1.0;      % output saturation amplitude
cfg.rapp.smoothness = 2;        % Rapp smoothness factor p

cfg.poly.orders  = [3 5];       % odd polynomial orders to fit
cfg.poly.fit_max = 0.9;         % fit range upper bound (input amplitude)

cfg.compression_db = 1;         % compression level for P1dB

cfg.ofdm.nfft         = 256;    % FFT size (before oversampling)
cfg.ofdm.osf          = 8;      % oversampling factor
cfg.ofdm.n_active     = 200;    % active subcarriers
cfg.ofdm.ncp          = 18;     % cyclic prefix length (at nfft rate)
cfg.ofdm.n_symbols    = 60;     % OFDM symbols
cfg.ofdm.papr_clip_db = 8;      % clipping (crest factor reduction)
cfg.ofdm.rms_in       = 0.3;    % PA input rms (normalized, drives compression)

cfg.memory.h_in  = [1, 0.25-0.1j, 0.05j];   % PA input FIR (memory effect)
cfg.memory.h_out = [1, -0.15+0.1j];         % PA output FIR

cfg.dpd.K      = 7;     % MP nonlinearity order (odd)
cfg.dpd.Q      = 3;     % MP memory depth
cfg.dpd.gain   = 1.0;   % target linear gain of DPD + PA
cfg.dpd.n_iter = 3;     % ILA iterations

cfg.acpr_offset = 1.5;  % adjacent channel offset [channel bandwidths]

cfg.results_dir     = 'results';
cfg.figure_name     = 'pa_nonlinearity.png';
cfg.dpd_figure_name = 'dpd_spectrum.png';
end
