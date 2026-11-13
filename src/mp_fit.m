function c = mp_fit(x, y, K, Q)
%MP_FIT  Least-squares memory polynomial (MP) coefficients.
c = mp_basis(x, K, Q) \ y(:);
end

