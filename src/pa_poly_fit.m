function [coeffs, y_fit] = pa_poly_fit(r, y, order)
%PA_POLY_FIT  Least-squares odd-order memoryless polynomial PA model.
%   [coeffs, y_fit] = PA_POLY_FIT(r, y, order) fits the complex baseband
%   model  y = sum_k c_k * r^(k-1) * x,  k = 1,3,...,order  where the input
%   is the real amplitude r (x = r). coeffs are complex, ordered by k.
%   r: input amplitudes (column), y: complex output, order: odd integer.
arguments
    r (:,1) double
    y (:,1) double
    order (1,1) double {mustBeInteger, mustBePositive}
end
assert(mod(order, 2) == 1, 'pa_poly_fit:order', 'Order must be odd.');
powers = 1:2:order;
basis = r .^ powers;
coeffs = basis \ y;
y_fit = basis * coeffs;
end
