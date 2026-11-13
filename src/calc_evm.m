function [evm_pct, rx] = calc_evm(y, info)
%CALC_EVM  Error vector magnitude of an OFDM signal after the PA.
%   [evm_pct, rx] = CALC_EVM(y, info) removes the cyclic prefix, applies an
%   FFT per symbol, scales with one complex gain (least squares, removes
%   gain and phase offset) and compares with the ideal 16-QAM symbols:
%       EVM = sqrt( sum|rx - ref|^2 / sum|ref|^2 ) * 100 %
%   y must be time aligned with the transmitted signal (same length).
%   rx: equalized received symbols (n_active x n_symbols).
N = info.nfft * info.osf;
Y = reshape(y(:), info.sym_len, info.n_symbols);
Y = Y(info.ncp * info.osf + 1:end, :);
F = fft(Y, [], 1) / N;
D = F(mod(info.active, N) + 1, :);
R = info.symbols;
g = (R(:)' * D(:)) / (R(:)' * R(:));
rx = D / g;
evm_pct = 100 * sqrt(sum(abs(rx(:) - R(:)).^2) / sum(abs(R(:)).^2));
end
