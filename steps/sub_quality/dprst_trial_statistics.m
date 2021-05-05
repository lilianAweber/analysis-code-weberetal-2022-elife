function trialStatsTable = dprst_trial_statistics( options )
%DPRST_TRIAL_STATISTICS Creates a table summarizing the number of artefactual, excluded and 
%remaining trials per subject in the dprst study and creates an overview plot.
%   IN:     optionally:
%           options         - the struct that contains all analysis options
%   OUT:    tableArtefacts  - overview table size 10 x nSubjects

if nargin < 1
    options = dprst_set_analysis_options;
end

[~, paths] = dprst_subjects(options);

if ~exist(paths.qualityroot, 'dir')
    mkdir(paths.qualityroot);
end

iSub = 0;

% loop through subjects and get their stats
for idCell = options.(options.part).subjectIDs
    id = char(idCell);
    iSub = iSub +1;

    details = dprst_subjects( id, options );
    load(details.trialstats);

    nTrialsInitial(iSub) = trialStats.nTrialsInitial;
    nEyeblinks(iSub) = trialStats.numEyeblinks;
    nArtefacts(iSub) = trialStats.numArtefacts;
    nBadChannels(iSub) = trialStats.badChannels.numBadChannels;
    nGoodTrialsTone(iSub) = trialStats.nTrialsFinal.tone;
    switch options.preproc.eyeblinktreatment
        case 'reject'
            nEyeartefactsTone(iSub) = trialStats.numEyeartefacts.tone;
    end

end

% table and plot
switch options.preproc.eyeblinktreatment
        case 'reject'
            % table
            trialStatsTable = table(nTrialsInitial', ...
                                    nEyeblinks', ...
                                    nEyeartefactsTone',...
                                    nArtefacts', nBadChannels', ...
                                    nGoodTrialsTone', ...
                                    'RowNames', options.(options.part).subjectIDs', ...
                                    'VariableNames', {'nTrialsInitial', ...
                                    'nEyeblinks', ...
                                    'nEyeartefactsTone',...
                                    'nAdditionalArtefacts', 'nBadChannels', ...
                                    'nGoodTrialsTone'});
            % plot
            fh = dprst_plot_overview_trial_statistics(options.(options.part).subjectIDs, nTrialsInitial, ...
                nEyeblinks, nArtefacts, nBadChannels, nGoodTrialsTone, nEyeartefactsTone);

        case 'ssp'
            % table
            trialStatsTable = table(nTrialsInitial', ...
                                    nEyeblinks', ...
                                    nArtefacts', nBadChannels', ...
                                    nGoodTrialsTone', ...
                                    'RowNames', options.(options.part).subjectIDs', ...
                                    'VariableNames', {'nTrialsInitial', ...
                                    'nEyeblinks', ...
                                    'nAdditionalArtefacts', 'nBadChannels', ...
                                    'nGoodTrialsTone'});
            % plot
            fh = dprst_plot_overview_trial_statistics(options.(options.part).subjectIDs, nTrialsInitial, ...
                nEyeblinks, nArtefacts, nBadChannels, nGoodTrialsTone);

end

if ~exist(paths.qualityfold, 'dir')
    mkdir(paths.qualityfold);
end

save(paths.trialstatstab, 'trialStatsTable');
saveas(fh, paths.trialstatsfig, 'fig');
saveas(fh, paths.trialstatsfig, 'png');

end
