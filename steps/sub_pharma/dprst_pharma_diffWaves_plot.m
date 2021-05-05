function h = dprst_pharma_diffWaves_plot(gaPla, gaDA, gaACh, chanName, options)
%DPRST_PHARMA_DIFFWAVES_PLOT Plots the grand averages the difference wave
%of standard and deviant conditions along with their SEM for all drug
%groups of one arm of the DPRST study.
%   IN:     ga          - variable with GA and SEM data for all conditions
%           chanName    - string with name of the channel
%           options     - the struct that holds all analysis options

if nargin < 3
    options = dprst_set_analysis_options;
end

cols = dprst_define_colors;
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
ga1.Placebo  = gaPla.mmn;
ga1.(drugDA) = gaDA.mmn;
ga1.time = gaPla.time;
condNames1 = condNames([1 2]);
lineColors1 = [cols.placebo; cols.dopamine];

ga2.Placebo  = gaPla.mmn;
ga2.(drugACh) = gaACh.mmn;
ga2.time = gaPla.time;
condNames2 = condNames([1 3]);
lineColors2 = [cols.placebo; cols.acetylcholine];

% Plot with placebo/DA and placebo/ACh comparison
h = figure; hold on;
titleStr = ['Difference waves (Sta-Dev) at ' chanName];
title(titleStr);

subplot(1, 2, 1); hold on;
dprst_plot_grandmean_with_sem(ga1, condNames1, lineColors1, lineWidth);
title(titleStr)

subplot(1, 2, 2); hold on;
dprst_plot_grandmean_with_sem(ga2, condNames2, lineColors2, lineWidth);
title(titleStr)

h.Position = [459 565 1086 392];
end