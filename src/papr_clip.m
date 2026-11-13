function y = papr_clip(x, papr_db)
%PAPR_CLIP  Hard clipping (crest factor reduction) to a given PAPR.
%   y = PAPR_CLIP(x, papr_db) limits |x| to rms(x)*10^(papr_db/20) and keeps
%   the phase. papr_db = Inf leaves the signal unchanged.
a = sqrt(mean(abs(x).^2)) * 10^(papr_db / 20);
r = abs(x);
scale = ones(size(x));
over = r > a;
scale(over) = a ./ r(over);
y = x .* scale;
end
