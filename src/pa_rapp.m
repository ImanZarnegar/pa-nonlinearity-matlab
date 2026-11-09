function amam = pa_rapp(r, p)
%PA_RAPP  Rapp memoryless PA model (AM/AM only, no phase distortion).
%   amam = PA_RAPP(r, p) with p = cfg.rapp (gain, a_sat, smoothness):
%     amam = g*r ./ (1 + (g*r/a_sat).^(2s)).^(1/(2s))
%   Reference: C. Rapp, "Effects of HPA-nonlinearity on a 4-DPSK/OFDM
%   signal for a digital sound broadcasting system," ESA, 1991.
arguments
    r (:,1) double {mustBeNonnegative}
    p (1,1) struct
end
s2 = 2 * p.smoothness;
amam = p.gain .* r ./ (1 + (p.gain .* r ./ p.a_sat).^s2).^(1 / s2);
end
