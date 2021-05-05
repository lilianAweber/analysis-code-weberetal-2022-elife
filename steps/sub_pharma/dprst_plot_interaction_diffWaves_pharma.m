function h = dprst_plot_interaction_diffWaves_pharma(gaPla, gaDA, gaACh, chanName)
%DPRST_PLOT_INTERACTION_DIFFWAVES_PHARMA Plots difference waveforms for 
%stable and volatile phases for a given sensor across drug groups in the 
%DPRST study.
%   IN:     gaPla, gaDA, gaACh  - the grand average structs for the 3 drug
%                               groups
%           chanName            - string with name of sensor
%   OUT:    h                   - handle to the figure

cols = dprst_define_colors;

condNames = {'stableDiff', 'volatileDiff'};
lineColors = [cols.lightred; cols.darkred];
lineWidth = 2;

gaPla = dprst_compute_interaction_diffWaves(gaPla);
gaDA = dprst_compute_interaction_diffWaves(gaDA);
gaACh = dprst_compute_interaction_diffWaves(gaACh);

tmpPla = dprst_compute_interaction_diffDiffWaves(gaPla);
gaPlaDiff.diff = tmpPla.interactDiff;
gaPlaDiff.time = gaPla.time; 
tmpDA = dprst_compute_interaction_diffDiffWaves(gaDA);
gaDADiff.diff = tmpDA.interactDiff;
gaDADiff.time = gaDA.time;
tmpACh = dprst_compute_interaction_diffDiffWaves(gaACh);
gaAChDiff.diff = tmpACh.interactDiff;
gaAChDiff.time = gaACh.time;

h = figure; hold on;

subplot(3, 1, 1); hold on;
dprst_plot_grandmean_with_sem(gaPla, condNames, lineColors, lineWidth);
dprst_plot_grandmean_with_sem(gaPlaDiff, {'diff'}, [0 0 0], 1);
titleStr = ['Interaction (difference waves) at ' chanName ': Placebo'];
title(titleStr);

subplot(3, 1, 2); hold on;
dprst_plot_grandmean_with_sem(gaDA, condNames, lineColors, lineWidth);
dprst_plot_grandmean_with_sem(gaDADiff, {'diff'}, [0 0 0], 1);
titleStr = ['Interaction (difference waves) at ' chanName ': Amisulpride'];
title(titleStr);

subplot(3, 1, 3); hold on;
dprst_plot_grandmean_with_sem(gaACh, condNames, lineColors, lineWidth);
dprst_plot_grandmean_with_sem(gaAChDiff, {'diff'}, [0 0 0], 1);
titleStr = ['Interaction (difference waves) at ' chanName ': Biperiden'];
title(titleStr);

linkaxes;

h.Position = [1129 70 695 813];

end