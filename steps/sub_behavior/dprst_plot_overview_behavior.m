function figureHandle = dprst_plot_overview_behavior( behavTable, options )
%DPRST_PLOT_OVERVIEW_TRIAL_STATISTICS Plots an overview of the number of trials per subject which
%had to be excluded in the preprocessing (including bad channels and final number of good trials)
%using barplots for one condition in the DPRST study. 
%

%-- preparation -----------------------------------------------------------------------------------%
nRows = 3;
meanRTs = behavTable.meanRTs*1000;
subNames = behavTable.Properties.RowNames;
nErrors = behavTable.nErrors;
nMisses = behavTable.nMisses;

% arbitrary thresholds
switch options.part
    case 'anta'
        thrshErrors = 9; % is a threshold of 25% error rate for n=36 trials
        thrshMisses = 9; % is a threshold of 75% hit rate for n=36 trials
    case 'agon'
        thrshErrors = 23; % is a threshold of 25% error rate for n=90 trials
        thrshMisses = 23; % is a threshold of 75% hit rate for n=90 trials
end
thrshMeanRT = 700;

nSubjects = numel(nErrors);
xAxis = 1: nSubjects;

%-- plotting --------------------------------------------------------------------------------------%
figureHandle = figure; hold on;

%% nTrialsInitial
subplot(nRows, 1, 1);
hold on; 

% barplot
bar(meanRTs, 'FaceColor', [0.1 .6 .9]);

% threshold
plot([0 nSubjects+1],[thrshMeanRT thrshMeanRT], 'red');

% subjects crossing the threshold
subIdx = meanRTs > thrshMeanRT;
if ~isempty(subIdx)
    text(xAxis(subIdx), meanRTs(subIdx) +25, char(subNames{subIdx}), ...
    'horizontalAlignment', 'center', 'Color', 'black');
end

xlim([0 nSubjects+1]);
ylim([min(meanRTs)-100 max(meanRTs)+50]);

title('Mean reaction time in ms', 'FontSize', 12);

%% nErrors
subplot(nRows, 1, 2);
hold on; 

% barplot
bar(nErrors, 'FaceColor', [0.25 .55 .79]);

% threshold
plot([0 nSubjects+1],[thrshErrors thrshErrors], 'red');

% subjects crossing the upper threshold
subIdx1 = nErrors > thrshErrors;
if ~isempty(subIdx1)
    text(xAxis(subIdx1), nErrors(subIdx1) +2, char(subNames{subIdx1}), ...
    'horizontalAlignment', 'center');
end

xlim([0 nSubjects+1]);
ylim([0 max(nErrors)+3]);

title('Number of false alarms and wrong choices', 'FontSize', 12);

%% nMisses
subplot(nRows, 1, 3);
hold on; 

% barplot
bar(nMisses, 'FaceColor', [0.9 .5 .5]);

% threshold
plot([0 nSubjects+1],[thrshMisses thrshMisses], 'red');

% subjects crossing the threshold
subIdx = nMisses > thrshMisses;
if ~isempty(subIdx)
    text(xAxis(subIdx), nMisses(subIdx) +2, char(subNames{subIdx}), ...
    'horizontalAlignment', 'center');
end

xlim([0 nSubjects+1]);
ylim([0 max(nMisses)+3]);

title('Number of missed openings', 'FontSize', 12);





end