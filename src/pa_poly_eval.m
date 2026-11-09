function y = pa_poly_eval(r, coeffs)
%PA_POLY_EVAL  Evaluate odd polynomial PA model from PA_POLY_FIT coefficients.
%   y = PA_POLY_EVAL(r, coeffs) returns the complex output for amplitudes r.
arguments
    r (:,1) double
    coeffs (:,1) double
end
y = (r .^ (1:2:2*numel(coeffs)-1)) * coeffs;
end
