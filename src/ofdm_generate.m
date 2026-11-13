function [x, info] = ofdm_generate(c)
%OFDM_GENERATE  Oversampled CP-OFDM test signal (5G NR-like, 16-QAM).
%   [x, info] = OFDM_GENERATE(c) with c = cfg.ofdm. Uses the global random
%   stream, so call rng(seed) first. Steps: random 16-QAM on c.n_active
%   subcarriers (DC skipped) -> IFFT of size nfft*osf (oversampling) -> cyclic
%   prefix -> PAPR clipping -> scaling to rms c.rms_in.
%   x    : complex baseband column vector
%   info : fields nfft, osf, ncp, n_symbols, sym_len, active (subcarrier
%          indices), symbols (n_active x n_symbols ideal 16-QAM), bw_norm
%          (occupied bandwidth / sampling rate)
N = c.nfft * c.osf;
half = c.n_active / 2;
active = [-half:-1, 1:half].';
levels = [-3 -1 1 3];
S = (levels(randi(4, c.n_active, c.n_symbols)) + ...
     1j * levels(randi(4, c.n_active, c.n_symbols))) / sqrt(10);

X = zeros(N, c.n_symbols);
X(mod(active, N) + 1, :) = S;
tx = ifft(X, [], 1) * N;
ncp_s = c.ncp * c.osf;
txc = [tx(end-ncp_s+1:end, :); tx];

x = txc(:);
x = x / sqrt(mean(abs(x).^2));
x = papr_clip(x, c.papr_clip_db);
x = x * c.rms_in / sqrt(mean(abs(x).^2));

info.nfft = c.nfft;
info.osf = c.osf;
info.ncp = c.ncp;
info.n_symbols = c.n_symbols;
info.sym_len = (c.nfft + c.ncp) * c.osf;
info.active = active;
info.symbols = S;
info.bw_norm = c.n_active / N;
end
