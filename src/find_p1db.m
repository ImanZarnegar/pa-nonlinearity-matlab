function [r_in, r_out, gain0_db] = find_p1db(r, amplitude_out, comp_db)
%FIND_P1DB  Locate the input-referred compression point (default 1 dB).
%   [r_in, r_out, gain0_db] = FIND_P1DB(r, amplitude_out, comp_db) finds the
%   input amplitude where the gain falls comp_db below the small-signal gain
%   (linear interpolation). Returns NaN if no compression occurs in range.
%   r must be strictly increasing and positive.
arguments
    r (:,1) double {mustBePositive}
    amplitude_out (:,1) double
    comp_db (1,1) double {mustBePositive} = 1
end
gain_db = 20 * log10(amplitude_out ./ r);
gain0_db = gain_db(1);                 % smallest drive ~ small-signal gain
idx = find(gain_db <= gain0_db - comp_db, 1, 'first');
if isempty(idx) || idx == 1
    r_in = NaN; r_out = NaN; return
end
w = (gain0_db - comp_db - gain_db(idx-1)) / (gain_db(idx) - gain_db(idx-1));
r_in  = r(idx-1) + w * (r(idx) - r(idx-1));
r_out = amplitude_out(idx-1) + w * (amplitude_out(idx) - amplitude_out(idx-1));
end
