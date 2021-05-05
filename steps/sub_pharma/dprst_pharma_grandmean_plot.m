function h = dprst_pharma_grandmean_plot(gaPla, gaDA, gaACh, chanName, options)
%DPRST_PHARMA_GRANDMEAN_PLOT Plots the grand averages of several conditions togehter with their SEM for the
%DPRST study, for three drug groups.
%   IN:     ga          - variable with GA and SEM data for all conditions
%           chanName    - string with name of the channel
%           options     - the struct that holds all analysis options

if nargin < 3
    options = dprst_set_analysis_options;
end

cols = dprst_define_colors;
lineWidth = 2;

% Gather plotting info
switch options.erp.type
    case {'roving', 'fair'}
        if isfield(gaPla, 'standard')
            condNames = {'standard', 'deviant'};
            lineColors = [cols.medgray; cols.lightred];
        else
            condNames = {'mmn'};
            lineColors = [cols.turquoise];
        end
    case {'phases_oddball', 'phases_roving', 'phases_fair'}
        condNames = {'volaDev', 'stabDev', ...
            'volaSta', 'stabSta'};
        lineColors = [cols.darkred; cols.lightred; ...
            cols.darkgray; cols.medgray];
    case {'lowhighEpsi2', 'lowhighEpsi3'}
        condNames = {'low', 'high'};
        lineColors = [cols.lightred; cols.darkred];
    case 'versions'
        condNames = {'sta2', 'dev2', 'sta5', 'dev5'};
        lineColors = [cols.darkgray; cols.darkred; ...
            cols.medgray; cols.lightred];
    case 'fair2'
        condNames = {'sta2', 'dev2', 'sta_sel', 'dev_sel'};
        lineColors = [cols.darkgray; cols.darkred; ...
            cols.medgray; cols.lightred];
end

h = figure; hold on;
titleStr = [options.erp.type ' ERPs at ' chanName];
title(titleStr);

subplot(3, 1, 1);
hold on;
dprst_plot_grandmean_with_sem(gaPla, condNames, lineColors, lineWidth);
title('Placebo');

subplot(3, 1, 2);
hold on;
dprst_plot_grandmean_with_sem(gaDA, condNames, lineColors, lineWidth);
switch options.part
    case 'anta'
        title('Amisulpride');
    case 'agon'
        title('Levodopa');
end

subplot(3, 1, 3);
hold on;
dprst_plot_grandmean_with_sem(gaACh, condNames, lineColors, lineWidth);
switch options.part
    case 'anta'
        title('Biperiden');
    case 'agon'
        title('Galantamine');
end

end