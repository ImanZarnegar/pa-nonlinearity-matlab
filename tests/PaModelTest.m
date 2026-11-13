classdef PaModelTest < matlab.unittest.TestCase
    %PAMODELTEST  Unit tests for the PA modeling functions.
    methods (TestClassSetup)
        function addPaths(~)
            root = fileparts(fileparts(mfilename('fullpath')));
            addpath(fullfile(root, 'src'));
        end
    end
    methods (Test)
        function salehSmallSignalGain(tc)
            cfg = pa_config();
            [~, amam] = pa_saleh(1e-4, cfg.saleh);
            tc.verifyEqual(amam / 1e-4, cfg.saleh.alpha_a, 'RelTol', 1e-3);
        end
        function salehP1dbMatchesClosedForm(tc)
            cfg = pa_config();
            r = linspace(1e-3, 2, 20000).';
            [~, amam] = pa_saleh(r, cfg.saleh);
            r_in = find_p1db(r, amam, 1);
            expected = sqrt((10^(1/20) - 1) / cfg.saleh.beta_a);
            tc.verifyEqual(r_in, expected, 'RelTol', 1e-3);
        end
        function rappSaturatesAtAsat(tc)
            cfg = pa_config();
            amam = pa_rapp(100, cfg.rapp);
            tc.verifyEqual(amam, cfg.rapp.a_sat, 'RelTol', 1e-3);
        end
        function polyFitRecoversPolynomial(tc)
            r = linspace(0.01, 1, 200).';
            truth = [2; -0.5; 0.1];
            y = pa_poly_eval(r, truth);
            coeffs = pa_poly_fit(r, y, 5);
            tc.verifyEqual(coeffs, truth, 'AbsTol', 1e-8);
        end
        function p1dbNaNWhenLinear(tc)
            r = linspace(0.1, 1, 50).';
            tc.verifyTrue(isnan(find_p1db(r, 3 * r, 1)));
        end
        function evenOrderRejected(tc)
            tc.verifyError(@() pa_poly_fit((1:5).', (1:5).', 4), 'pa_poly_fit:order');
        end
        function mpFitRecoversCoefficients(tc)
            rng(1);
            x = 0.5 * (randn(500, 1) + 1j * randn(500, 1));
            c = [1; 0.1j; -0.05; 0.2; 0.02; -0.01j];
            y = mp_eval(x, c, 5, 1);
            tc.verifyEqual(mp_fit(x, y, 5, 1), c, 'AbsTol', 1e-8);
        end
        function evmZeroForIdealSignal(tc)
            cfg = pa_config();
            rng(cfg.seed);
            c = cfg.ofdm; c.papr_clip_db = Inf;
            [x, info] = ofdm_generate(c);
            tc.verifyLessThan(calc_evm(3 * exp(1j) * x, info), 1e-6);
        end
        function acprImprovesWithLowerDistortion(tc)
            cfg = pa_config();
            rng(cfg.seed);
            [x, info] = ofdm_generate(cfg.ofdm);
            y = pa_memory(x, cfg);
            tc.verifyLessThan(calc_acpr(x, info.bw_norm, 1.5), ...
                calc_acpr(y, info.bw_norm, 1.5));
        end
        function dpdImprovesAcprAndEvm(tc)
            cfg = pa_config();
            rng(cfg.seed);
            [x, info] = ofdm_generate(cfg.ofdm);
            pa = @(u) pa_memory(u, cfg);
            d = cfg.dpd;
            u = dpd_ila(x, pa, d.K, d.Q, d.gain, d.n_iter);
            tc.verifyLessThan(calc_acpr(pa(u), info.bw_norm, 1.5), ...
                calc_acpr(pa(x), info.bw_norm, 1.5) - 5);
            tc.verifyLessThan(calc_evm(pa(u), info), ...
                calc_evm(pa(x), info) / 3);
        end
    end
end
