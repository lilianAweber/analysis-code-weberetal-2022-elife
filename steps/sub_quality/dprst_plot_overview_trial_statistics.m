function figureHandle = dprst_plot_overview_trial_statistics(subNames, nTrialsInitial, nEyeblinks, ...
    nArtefacts, nBadchannels, nGoodTrialsTone, nEyeartefacts)
%DPRST_PLOT_OVERVIEW_TRIAL_STATISTICS Plots an overview of the number of trials per subject which
%had to be excluded in the preprocessing (including bad channels and final number of good trials)
%using barplots for one condition in the DPRST study. 
%

%-- preparation -----------------------------------------------------------------------------------%
if nargin < 7
    plotOption = 'ssp';
    nRows = 5;
else
    plotOption = 'reject';
    nRows = 6;
end

% arbitrary thresholds
thrshTrialsInitial = 1800;
thrshEyeblinksUp = 400;
thrshEyeblinksDown = 100;
thrshArtefacts = 100;
thrshBadchannels = 1;
thrshGoodTrialsTone = 1500;
thrshEyeartefacts = 400;

nSubjects = numel(nEyeblinks);
xAxis = 1: nSubjects;

%-- plotting --------------------------------------------------------------------------------------%
figureHandle = figure; hold on;

%% nTrialsInitial
subplot(nRows, 1, 1);
hold on; 

% barplot
bar(nTrialsInitial, 'FaceColor', [0.1 .6 .9]);

% threshold
plot([0 nSubjects+1],[thrshTrialsInitial thrshTrialsInitial], 'red');

% subjects crossing the lower threshold
subIdx = nTrialsInitial < thrshTrialsInitial;
if ~isempty(subIdx)
    text(xAxis(subIdx), nTrialsInitial(subIdx) -50, char(subNames{subIdx}), ...
    'horizontalAlignment', 'center', 'Color', 'white');
end

xlim([0 nSubjects+1]);
ylim([min(nTrialsInitial)-100 max(nTrialsInitial)+50]);

title('Number of initial trials', 'FontSize', 12);

%% nEyeblinks
subplot(nRows, 1, 2);
hold on; 

% barplot
bar(nEyeblinks, 'FaceColor', [0.25 .55 .79]);

% thresholds
plot([0 nSubjects+1],[thrshEyeblinksUp thrshEyeblinksUp], 'red');
plot([0 nSubjects+1],[thrshEyeblinksDown thrshEyeblinksDown], 'red');

% subjects crossing the upper threshold
subIdx1 = nEyeblinks > thrshEyeblinksUp;
if ~isempty(subIdx1)
    text(xAxis(subIdx1), nEyeblinks(subIdx1) +30, char(subNames{subIdx1}), ...
    'horizontalAlignment', 'center');
end

% subjects crossing the lower threshold
subIdx2 = nEyeblinks < thrshEyeblinksDown;
if ~isempty(subIdx2)
    text(xAxis(subIdx2), nEyeblinks(subIdx2) -30, char(subNames{subIdx2}), ...
    'horizontalAlignment', 'center', 'Color', 'white');
end

xlim([0 nSubjects+1]);
ylim([0 max(nEyeblinks)+80]);

title('Number of detected eyeblinks', 'FontSize', 12);

%% nArtefacts
subplot(nRows, 1, 3);
hold on; 

% barplot
bar(nArtefacts, 'FaceColor', [0.9 .5 .5]);

% threshold
plot([0 nSubjects+1],[thrshArtefacts thrshArtefacts], 'red');

% subjects crossing the threshold
subIdx = nArtefacts > thrshArtefacts;
if ~isempty(subIdx)
    text(xAxis(subIdx), nArtefacts(subIdx) +30, char(subNames{subIdx}), ...
    'horizontalAlignment', 'center');
end

xlim([0 nSubjects+1]);
ylim([0 max(nArtefacts)+80]);

title('Number of bad trials (artefacts)', 'FontSize', 12);


%% nBadchannels
subplot(nRows, 1, 4);
hold on; 

% barplot
bar(nBadchannels, 'FaceColor', [1.0 0.4 0.4]);

% threshold
plot([0 nSubjects+1],[thrshBadchannels thrshBadchannels], 'red');

% subjects crossing the threshold
subIdx = nBadchannels > thrshBadchannels;
if ~isempty(subIdx)
    text(xAxis(subIdx), nBadchannels(subIdx) +1, char(subNames{subIdx}), ...
    'horizontalAlignment', 'center');
end

xlim([0 nSubjects+1]);
ylim([0 max(nBadchannels)+3]);

title('Number of bad channels', 'FontSize', 12);


%% nGoodtrials
subplot(nRows, 1, 5);
hold on; 

% barplot
bar(nGoodTrialsTone, 'FaceColor', [0.2 0.6 0.4]);

% threshold
plot([0 nSubjects+1],[thrshGoodTrialsTone thrshGoodTrialsTone], 'red');

% subjects crossing the threshold
subIdx = nGoodTrialsTone < thrshGoodTrialsTone;
if ~isempty(subIdx)
    text(xAxis(subIdx), nGoodTrialsTone(subIdx) -50, char(subNames{subIdx}), ...
    'horizontalAlignment', 'center', 'Color', 'white');
end

xlim([0 nSubjects+1]);
ylim([min(nGoodTrialsTone)-100 max(nGoodTrialsTone)+10]);

title('Number of remaining good trials', 'FontSize', 12);

%% nEyeartefacts
switch plotOption
    case 'reject'
        subplot(nRows, 1, nRows);
        hold on; 

        % barplot
        bar(nEyeartefacts, 'FaceColor', [0.4 0.2 0.6]);

        % threshold
        plot([0 nSubjects+1],[thrshEyeartefacts thrshEyeartefacts], 'red');

        % subjects crossing the threshold
        subIdx = nEyeartefacts > thrshEyeartefacts;
        if ~isempty(subIdx)
            text(xAxis(subIdx), nEyeartefacts(subIdx) +50, char(subNames{subIdx}), ...
            'horizontalAlignment', 'center');
        end

        xlim([0 nSubjects+1]);
        ylim([min(nEyeartefacts)-10 max(nEyeartefacts)+100]);

        title('Number of excluded trials due to eyeblinks', 'FontSize', 12);
end


end