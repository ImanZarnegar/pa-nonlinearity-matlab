function [y, amam, ampm] = pa_saleh(r, p)
%PA_SALEH  Saleh memoryless PA model (AM/AM and AM/PM).
%   [y, amam, ampm] = PA_SALEH(r, p) for real input amplitudes r >= 0.
%   p is the struct cfg.saleh with fields alpha_a, beta_a, alpha_phi, beta_phi.
%     amam = alpha_a*r ./ (1 + beta_a*r.^2)            output amplitude
%     ampm = alpha_phi*r.^2 ./ (1 + beta_phi*r.^2)     phase shift [rad]
%     y    = amam .* exp(1j*ampm)                      complex output
%   Reference: A. Saleh, "Frequency-independent and frequency-dependent
%   nonlinear models of TWT amplifiers," IEEE Trans. Commun., 1981.
arguments
    r (:,1) double {mustBeNonnegative}
    p (1,1) struct
end
amam = p.alpha_a .* r ./ (1 + p.beta_a .* r.^2);
ampm = p.alpha_phi .* r.^2 ./ (1 + p.beta_phi .* r.^2);
y = amam .* exp(1j * ampm);
end
