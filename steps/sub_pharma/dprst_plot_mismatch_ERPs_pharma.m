function h = dprst_plot_mismatch_ERPs_pharma(gaPla, gaDA, gaACh, ...
    chanName, daName, achName)
%DPRST_PLOT_MISMATCH_ERPS_PHARMA Plots average waveforms for standards and
%deviants for a given sensor across drug groups in the DPRST study.
%   IN:     gaPla, gaDA, gaACh  - the grand average structs for the 3 drug
%                               groups
%           chanName            - string with name of sensor
%   OUT:    h                   - handle to the figure

cols = dprst_define_colors;

condNames = {'standards', 'deviants'};
lineColors = [cols.medgray; cols.lightred];
lineWidth = 2;

if ~isfield(gaPla, 'standards')
    gaPla = dprst_compute_mismatch_ERPs(gaPla);
    gaDA = dprst_compute_mismatch_ERPs(gaDA);
    gaACh = dprst_compute_mismatch_ERPs(gaACh);
end

tmpPla = dprst_compute_mismatch_diffDiffWaves(gaPla);
gaPlaDiff.diff = tmpPla.mismatchDiff;
gaPlaDiff.time = gaPla.time; 
tmpDA = dprst_compute_mismatch_diffDiffWaves(gaDA);
gaDADiff.diff = tmpDA.mismatchDiff;
gaDADiff.time = gaDA.time;
tmpACh = dprst_compute_mismatch_diffDiffWaves(gaACh);
gaAChDiff.diff = tmpACh.mismatchDiff;
gaAChDiff.time = gaACh.time;

h = figure; hold on;

subplot(3, 1, 1); hold on;
dprst_plot_grandmean_with_sem(gaPla, condNames, lineColors, lineWidth);
dprst_plot_grandmean_with_sem(gaPlaDiff, {'diff'}, [0 0 0], 1);
titleStr = ['Average mismatch ERPs at ' chanName ': Placebo'];
title(titleStr);

subplot(3, 1, 2); hold on;
dprst_plot_grandmean_with_sem(gaDA, condNames, lineColors, lineWidth);
dprst_plot_grandmean_with_sem(gaDADiff, {'diff'}, [0 0 0], 1);
titleStr = ['Average mismatch ERPs at ' chanName ': ' daName];
title(titleStr);

subplot(3, 1, 3); hold on;
dprst_plot_grandmean_with_sem(gaACh, condNames, lineColors, lineWidth);
dprst_plot_grandmean_with_sem(gaAChDiff, {'diff'}, [0 0 0], 1);
titleStr = ['Average mismatch ERPs at ' chanName ': ' achName];
title(titleStr);

linkaxes

h.Position = [1129 70 695 813];

end