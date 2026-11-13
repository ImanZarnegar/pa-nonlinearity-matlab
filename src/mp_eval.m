function y = mp_eval(x, c, K, Q)
%MP_EVAL  Output of the memory polynomial model for input x and coefficients c.
y = mp_basis(x, K, Q) * c(:);
end

