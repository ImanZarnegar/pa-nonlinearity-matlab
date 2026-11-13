function [P, f] = psd_welch(x, nfft)
%PSD_WELCH  Welch power spectrum estimate (Hann window, 50 % overlap).
%   [P, f] = PSD_WELCH(x, nfft) returns the two-sided spectrum P (linear
%   power, centered at DC) and the normalized frequency f in cycles/sample
%   (-0.5 .. 0.5). Implemented without toolboxes.
x = x(:);
w = 0.5 - 0.5 * cos(2 * pi * (0:nfft-1).' / nfft);
step = nfft / 2;
nseg = floor((numel(x) - nfft) / step) + 1;
P = zeros(nfft, 1);
for s = 1:nseg
    seg = x((s-1)*step + (1:nfft)) .* w;
    P = P + abs(fftshift(fft(seg))).^2;
end
P = P / nseg;
f = (-nfft/2:nfft/2-1).' / nfft;
end
