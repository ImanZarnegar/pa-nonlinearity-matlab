function y = pa_memory(x, cfg)
%PA_MEMORY  Wideband PA with memory effects (Wiener-Hammerstein structure).
x = x(:);
xf = filter(cfg.memory.h_in, 1, x);
yn = pa_saleh_cx(xf, cfg.saleh);
y  = filter(cfg.memory.h_out, 1, yn);
end
