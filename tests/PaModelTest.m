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
    end
end
