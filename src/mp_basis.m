function B = mp_basis(x, K, Q)
%MP_BASIS  Basis matrix of the memory polynomial (MP) model.
x = x(:);
n = numel(x);
orders = 1:2:K;
B = zeros(n, (Q + 1) * numel(orders));
idx = 0;
for q = 0:Q
    xq = [zeros(q, 1); x(1:n-q)];
    for k = orders
        idx = idx + 1;
        B(:, idx) = xq .* abs(xq) .^ (k - 1);
    end
end
end

