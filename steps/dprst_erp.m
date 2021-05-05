function D = dprst_erp(id, options, doPlot)
%DPRST_ERP Computes ERPs for one subject from the DPRST study.
%   IN:     id                  - subject identifier, e.g '0001'
%           doPlot (optional)   - 1 for plotting subject's ERP and saving a
%                               figure, 0 otherwise
%   OUT:    D                   - difference wave ERP file

% plotting yes or no
if nargin < 3
    doPlot = 1;
end

% general analysis options
if nargin < 2
    options = dprst_set_analysis_options;
end

% paths and files
[details, paths] = dprst_subjects(id, options);

% prepare spm
spm('defaults', 'EEG');

% record what we're doing
diary(details.logfile);
tnueeg_display_analysis_step_header('erp', options.part, id, options.erp);

try
    % check for previous ERP analyses
    D = spm_eeg_load(details.erpfile);
    disp(['Subject ' id ' has been averaged before.']);
    if options.erp.overwrite
        clear D;
        disp('Overwriting...');
        error('Continue to ERP script');
    else
        disp('Nothing is being done.');
    end
catch
    fprintf('\nAveraging subject %s ...\n\n', id);

    %-- preparation -------------------------------------------------------------------------------%
    % check destination folder
    if ~exist(details.erpfold, 'dir')
        mkdir(details.erpfold);
    end
    cd(details.erpfold);

    % work on final preprocessed file
    D = spm_eeg_load(details.prepfile);
    
    %-- redefinition ------------------------------------------------------------------------------%
    condlist = dprst_trial_definition_erp(paths, options);
    switch options.preproc.eyeblinktreatment
        case 'reject'
            condlist = dprst_correct_conditions_for_eyeblinktrials(condlist, details.trialstats);
    end
    D = tnueeg_redefine_conditions(D, condlist);
    D = copy(D, details.redeffile);
    % condition-specific trial statistics
    nTrials = tnueeg_count_good_trials(D);
    save(details.erptrialstats, 'nTrials');

    %-- averaging ---------------------------------------------------------------------------------%
    D = tnueeg_average(D, options.erp.averaging);
    D = copy(D, details.avgfile);
    fprintf('\nAveraged over trials for subject %s\n', id);

    % in case of robust filtering: re-apply the low-pass filter
    switch options.erp.averaging
        case 'r'
            % make sure we don't delete ERP files during filtering
            options.preproc.keep = 1;
            D = tnueeg_filter(D, 'low', options);
            D = copy(D, details.filfile);
            fprintf('\nRe-applied the low-pass filter for subject %s\n', id);
        case 's'
            % do nothing
    end
    D = copy(D, details.erpfile);
    
    %-- ERP plot ----------------------------------------------------------------------------------%
    chanlabel = options.erp.plotchannel;
    switch options.erp.type
        case {'roving', 'fair'}
            triallist = {'standard', 'Standard Tones', [0 0 1]; ...
                        'deviant', 'Deviant Tones', [1 0 0]};
        case {'phases_roving', 'phases_oddball', 'phases_fair'}
            triallist = {'stabSta', 'Standards in stable phases', [0 0 1]; ...
                        'stabDev', 'Deviants in stable phases', [1 0 0]; ...
                        'volaSta', 'Standards in volatile phases', [0.5 0.5 1]; ...
                        'volaDev', 'Deviants in volatile phases', [1 0.5 0.5]};
        case {'lowhighEpsi2', 'lowhighEpsi3'}
            triallist = {'low', 'Lowest PE values', [0 0 1]; ...
                        'high', 'Highest PE values', [1 0 0]};
        case 'versions'
            triallist = {'sta1', 'First repetition', [0 0 1]; ...
                        'dev2', 'Change after 1st repetition', [1 0 0]};
        case 'fair2'
            triallist = {'sta2', 'Standards after 1 repetition', [0.5 0.5 1]; ...
                        'dev2', 'Deviants after 1 repetition', [1 0.5 0.5]; ...
                        'sta_sel', 'Standards after more repetitions', [0 0 1]; ...
                        'dev_sel', 'Deviants after more repetitions', [1 0 0]};
    end
    if doPlot
        h = tnueeg_plot_subject_ERPs(D, chanlabel, triallist);
        h.Children(2).Title.String = ['Subject ' id ': ' options.erp.type ' ERPs'];
        savefig(h, details.erpfig);
        fprintf('\nSaved an ERP plot for subject %s\n\n', id);    
    end
    
    %-- difference waves --------------------------------------------------------------------------%
    switch options.erp.type
        case {'roving', 'fair'}
            % preparation for computing the difference wave
            % determine condition order within the D object
            idxStan = indtrial(D, 'standard');
            idxDev = indtrial(D, 'deviant');

            % set weights such that we substract standard trials from deviant
            % trials, give the new condition a name
            weights = zeros(1, ntrials(D));
            weights(idxDev) = 1;
            weights(idxStan) = -1;
            condlabel = {'mmn'};

            % sanity check for logfile
            disp('Difference wave will be computed using:');
            disp(weights);
            disp('as weights on these conditions:');
            disp(conditions(D));

            % compute the actual contrast
            D = tnueeg_contrast_over_epochs(D, weights, condlabel, options);
            copy(D, details.difffile);
            fprintf('\nComputed the difference wave for subject %s\n\n', id);
    end
end

close all
cd(options.workdir);

diary OFF
end
