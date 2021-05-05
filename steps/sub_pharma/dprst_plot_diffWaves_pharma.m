function h = dprst_plot_diffWaves_pharma(gaPla, gaDA, gaACh, chanName, mmnType, options)
%DPRST_PLOT_DIFFWAVES_PHARMA Plots the grand averages the difference wave
%of any mmnType conditions along with their SEM for all drug
%groups of one arm of the DPRST study.
%   IN:     ga          - variable with GA and SEM data for all conditions
%           chanName    - string with name of the channel
%           mmnType     - name of difference wave in the GA object
%           options     - the struct that holds all analysis options

if nargin < 3
    options = dprst_set_analysis_options;
end

cols = dprst_define_colors(options.part);
lineWidth = 2;

switch options.part
    case 'anta'
        drugDA = 'Amisulpride';
        drugACh = 'Biperiden';
        condNames = {'Placebo', 'Amisulpride', 'Biperiden'};
    case 'agon'
        drugDA = 'Levodopa';
        drugACh = 'Galantamine';
        condNames = {'Placebo', 'Levodopa', 'Galantamine'};
end

% Form two new ga objects
ga1.Placebo  = gaPla.(mmnType);
ga1.(drugDA) = gaDA.(mmnType);
ga1.time = gaPla.time;
condNames1 = condNames([1 2]);
lineColors1 = [cols.placebo; cols.dopamine];

ga2.Placebo  = gaPla.(mmnType);
ga2.(drugACh) = gaACh.(mmnType);
ga2.time = gaPla.time;
condNames2 = condNames([1 3]);
lineColors2 = [cols.placebo; cols.acetylcholine];

ga3.(drugDA)  = gaDA.(mmnType);
ga3.(drugACh) = gaACh.(mmnType);
ga3.time = gaPla.time;
condNames3 = condNames([2 3]);
lineColors3 = [cols.dopamine; cols.acetylcholine];

% Plot with placebo/DA and placebo/ACh comparison
h = figure; hold on;
titleStr = ['Difference waves at ' chanName];
title(titleStr);

subplot(3, 1, 1); hold on;
dprst_plot_grandmean_with_sem(ga1, condNames1, lineColors1, lineWidth);
title(titleStr)

subplot(3, 1, 2); hold on;
dprst_plot_grandmean_with_sem(ga2, condNames2, lineColors2, lineWidth);
title(titleStr)

subplot(3, 1, 3); hold on;
dprst_plot_grandmean_with_sem(ga3, condNames3, lineColors3, lineWidth);
title(titleStr)

linkaxes

h.Position = [309 221 449 697];
end