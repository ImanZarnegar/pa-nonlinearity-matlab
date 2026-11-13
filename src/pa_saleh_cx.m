function y = pa_saleh_cx(x, p)
%PA_SALEH_CX  Saleh model for complex baseband input (AM/AM + AM/PM).
x = x(:);
[~, amam, ampm] = pa_saleh(abs(x), p);
y = amam .* exp(1j * (angle(x) + ampm));
end
