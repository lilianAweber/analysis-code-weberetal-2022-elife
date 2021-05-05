function dprst_plot_grandmean_with_sem(gaData, condNames, lineColors, lineWidth)
%DPRST_PLOT_GRANDMEAN_WITH_SEM Plots Grand Averages with shaded Error Bars
%   This function plots the grand averages and its standard errors of
%   the mean on the corresponding time axis for one or more conditions. It
%   plots the means of all conditions with their respective confidence
%   interval (1.96 * standard error of the mean) as patches around the mean
%   ERPs. Grand averages and SEMs have to be computed in advance.
%   IN:     gaData      - Data struct with one field per condition, containing
%                         GA and SEM data.
%           condNames   - CellArray of condition/session/line names for the
%                       legend.
%           lineColors  - (nLines x 3) matrix of RGB colors for the lines.
%           lineWidth   - Line width for the lines.
%   OUT:    -

if nargin < 5
    diffFlag = 0;
end

nLines = numel(condNames);

plotHandles = [];
timeAxis = gaData.time;

for iLine = 1: nLines
    sem = gaData.(char(condNames{iLine})).error;
    line = gaData.(char(condNames{iLine})).mean;
    if strcmp(condNames{iLine}, 'mmn')
        line = -line;
    end
    sem = sem * 1.96; % 95% confidence interval
    
    H(iLine) = tnueeg_line_with_shaded_errorbar(timeAxis, line, sem, ...
        {'Color', lineColors(iLine, :), 'LineWidth', lineWidth}, 1);
    
    plotHandles = [plotHandles H(iLine).mainLine];
end

legend(plotHandles, condNames{:});
%ylim([-1.7 1.5]);
ylabel('Field intensity (in \muV)');
xlim([timeAxis(1) timeAxis(end)]);
xlabel('Time (ms after tone onset)');
grid on;

end

