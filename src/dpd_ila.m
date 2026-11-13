function [u, c] = dpd_ila(x, pa_fun, K, Q, G, n_iter)
%DPD_ILA  Digital predistortion by indirect learning architecture (ILA).
%   [u, c] = DPD_ILA(x, pa_fun, K, Q, G, n_iter)
%   x      : desired (undistorted) complex baseband input, column
%   pa_fun : function handle, y = pa_fun(u), the PA (or its measurement)
%   K, Q   : memory polynomial order (odd) and memory depth
%   G      : target linear gain of the cascade DPD + PA (linear)
%   n_iter : number of ILA iterations
%   u      : predistorted signal to send into the PA
%   c      : MP coefficients of the predistorter
%
%   Each iteration measures the PA output y = pa_fun(u), trains a
%   postdistorter that maps y/G back to u (least squares MP fit) and copies
%   it in front of the PA. G must be small enough that G*max|x| stays below
%   the PA saturation output, otherwise the PA cannot deliver it.
u = x(:);
for it = 1:n_iter
    y = pa_fun(u);
    c = mp_fit(y / G, u, K, Q);
    u = mp_eval(x, c, K, Q);
end
end
