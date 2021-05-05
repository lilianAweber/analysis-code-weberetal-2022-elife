function h = dprst_plot_stability_ERPs_pharma(gaPla, gaDA, gaACh, chanName, DA, ACh)
%DPRST_PLOT_STABILITY_ERPS_PHARMA Plots average waveforms for stable and
%volatile phases for a given sensor across drug groups in the DPRST study.
%   IN:     gaPla, gaDA, gaACh  - the grand average structs for the 3 drug
%                               groups
%           chanName            - string with name of sensor
%   OUT:    h                   - handle to the figure

cols = dprst_define_colors;

condNames = {'stable', 'volatile'};
lineColors = [cols.medgray; cols.darkgray];
lineWidth = 2;

if ~isfield(gaPla, 'stable')
    gaPla = dprst_compute_stability_ERPs(gaPla);
    gaDA = dprst_compute_stability_ERPs(gaDA);
    gaACh = dprst_compute_stability_ERPs(gaACh);
end

tmpPla = dprst_compute_stability_diffDiffWaves(gaPla);
gaPlaDiff.diff = tmpPla.stabilityDiff;
gaPlaDiff.time = gaPla.time; 
tmpDA = dprst_compute_stability_diffDiffWaves(gaDA);
gaDADiff.diff = tmpDA.stabilityDiff;
gaDADiff.time = gaDA.time;
tmpACh = dprst_compute_stability_diffDiffWaves(gaACh);
gaAChDiff.diff = tmpACh.stabilityDiff;
gaAChDiff.time = gaACh.time;

h = figure; hold on;

subplot(3, 1, 1); hold on;
dprst_plot_grandmean_with_sem(gaPla, condNames, lineColors, lineWidth);
dprst_plot_grandmean_with_sem(gaPlaDiff, {'diff'}, [1 0 1], 1);
titleStr = ['Stability ERPs at ' chanName ': Placebo'];
title(titleStr);

subplot(3, 1, 2); hold on;
dprst_plot_grandmean_with_sem(gaDA, condNames, lineColors, lineWidth);
dprst_plot_grandmean_with_sem(gaDADiff, {'diff'}, [1 0 1], 1);
titleStr = ['Stability ERPs at ' chanName ': ' DA];
title(titleStr);

subplot(3, 1, 3); hold on;
dprst_plot_grandmean_with_sem(gaACh, condNames, lineColors, lineWidth);
dprst_plot_grandmean_with_sem(gaAChDiff, {'diff'}, [1 0 1], 1);
titleStr = ['Stability ERPs at ' chanName ': ' ACh];
title(titleStr);

linkaxes

h.Position = [1129 70 695 813];

end