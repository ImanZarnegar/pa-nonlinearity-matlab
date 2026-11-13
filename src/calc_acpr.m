function [acpr_db, P, f] = calc_acpr(x, bw_norm, offset, nfft)
%CALC_ACPR  Adjacent channel power ratio (worst of lower/upper channel).
%   [acpr_db, P, f] = CALC_ACPR(x, bw_norm, offset, nfft)
%   bw_norm : channel bandwidth / sampling rate (info.bw_norm)
%   offset  : adjacent channel center offset in units of the channel
%             bandwidth (e.g. 1.5 leaves a guard gap of half a channel)
%   nfft    : spectrum resolution (default 4096)
%   ACPR = 10*log10( P_adjacent / P_main ), more negative is better.
arguments
    x (:,1) double
    bw_norm (1,1) double {mustBePositive}
    offset (1,1) double {mustBePositive}
    nfft (1,1) double = 4096
end
[P, f] = psd_welch(x, nfft);
band = @(c) sum(P(abs(f - c) <= bw_norm / 2));
acpr_db = 10 * log10(max(band(offset * bw_norm), band(-offset * bw_norm)) / band(0));
end
