function D = dprst_preprocessing_ssp(id, options)
%DPRST_PREPROCESSING Preprocesses one subject from the DPRST study using simple EB correction.
%   IN:     id  - subject identifier, e.g '0001'
%           optionally:
%           options - the struct that holds all analysis options
%   OUT:    D   - preprocessed data set

% general analysis options
if nargin < 2
    options = dprst_set_analysis_options;
end

options.preproc.eyeblinktreatment = 'ssp';

% paths and files
[details, paths] = dprst_subjects(id, options);

% record what we're doing
diary(details.logfile);
tnueeg_display_analysis_step_header('preprocessing_ssp', 'dprst', id, options.preproc);

% check destination folder
if ~exist(details.preproot, 'dir')
    mkdir(details.preproot);
end
cd(details.preproot);

try
    % check for previous preprocessing
    D = spm_eeg_load(details.prepfile);
    disp(['Subject ' id ' has been preprocessed before.']);
    if options.preproc.overwrite
        clear D;
        disp('Overwriting...');
        error('Continue to preprocessing script');
    else
        disp('Nothing is being done.');
    end
catch
    disp(['Preprocessing subject ' id ' ...']);

    %-- preparation ------------------------------------------------------%
    spm('defaults', 'eeg');
    spm_jobman('initcfg');

    % convert .eeg file
    D = tnueeg_convert(details.rawfile);
    fprintf('\nConversion done.\n\n');
    
    if details.cablingIssue
        montage = dprst_montage_rearrange_channels(D);
        save(details.cablemontage, 'montage');
        D = tnueeg_do_montage(D, details.cablemontage, options);
        fprintf('\nRearranged channels.\n\n');
        
        % set channel types (EEG, EOG)
        chandef = dprst_channel_definition_cabling_issue(D, details, options);
        D = tnueeg_set_channeltypes(D, chandef, options);
        fprintf('\nChanneltypes done.\n\n');
        
        % do montage (rereferencing, but keep EOG channel)
        montage = dprst_montage_for_cabling_issue(D, options);
        save(details.rerefmontage, 'montage');
        D = tnueeg_do_montage(D, details.rerefmontage, options);
        fprintf('\nMontage done.\n\n');
    else
        % set channel types (EEG, EOG)
        chandef = dprst_channel_definition(D, details, options);
        D = tnueeg_set_channeltypes(D, chandef, options);
        fprintf('\nChanneltypes done.\n\n');

        % do montage (rereferencing, but keep EOG channel)
        if ~exist(paths.montage, 'file')
            fprintf('\nCreating montage setup file ...\n');
            montage = dprst_montage(options);
            save(paths.montage, 'montage');
        else
            fprintf('\nUsing existing montage setup file ...\n');
        end
        D = tnueeg_do_montage(D, paths.montage, options);
        fprintf('\nMontage done.\n\n');
    end    
    %-- sensor locations -------------------------------------------------%
    % load digitized and corrected electrode positions
    %D = tnueeg_sensor_locations(D, paths.tnuelec);
    %fprintf('\nSensor locations done.\n\n');

    % transform into MRI space
    %D = dprst_transform_locations(D, details.fiducialmat); 
    %%save(D);
    %fprintf('\nLocation transformation done.\n\n');

    % project to 2D
    %D = tnueeg_project_to_2D(D);
    %fprintf('\n2D Projection done.\n\n');

    %-- filtering --------------------------------------------------------%
    D = tnueeg_filter(D, 'high', options);
    D = tnueeg_downsample(D, options);
    D = tnueeg_filter(D, 'low', options);
    fprintf('\nFilters & Downsampling done.\n\n');

    %-- eye blink detection ----------------------------------------------%
    % subject-specific EB detection thresholds
    options.preproc.eyeblinkthreshold = details.eyeblinkthreshold;

    [Dm, trialStats.numEyeblinks] = tnueeg_eyeblink_detection_spm(D, options);
    savefig(details.ebdetectfig);
    fprintf('\nEye blink detection done.\n\n');
    
    %-- eye blink epoching and confounds ----------------------------------------------------------%
    Db = tnueeg_epoch_blinks(Dm, options);
    fprintf('\nEpoching to eye blinks done.\n\n');
    
    % preclean the EB epochs to get better confound estimates
    Dbc = dprst_preclean_eyeblink_epochs(Db, details, options);
    
    Dbc = tnueeg_get_spatial_confounds(Dbc, options);
    savefig(details.ebspatialfig);
    fprintf('\nSpatial confounds done.\n\n');
    
    %-- experimental epoching --------------------------------------------%
    if ~exist(paths.trialdef, 'file')
        trialdef = dprst_trial_definition(paths, options);
    else
        load(paths.trialdef);
    end
    D = tnueeg_epoch_experimental(Dm, trialdef, options);
    fprintf('\nExperimental epoching done.\n\n');
    
    trialStats.nTrialsInitial = ntrials(D);
    
    %-- eye blink correction & headmodel ---------------------------------%
    if options.preproc.preclean.doBadChannels
        badPrecleanChannels = badchannels(Dbc);
        if ~isempty(badPrecleanChannels)
            fprintf('\nMarking %s channels as bad due to precleaning.', ...
                num2str(numel(badPrecleanChannels)));
            D = badchannels(D, badPrecleanChannels, ones(1, numel(badPrecleanChannels)));
        end
    end
    D = tnueeg_add_spatial_confounds(D, Dbc, options);
    fprintf('\nAdding spatial confounds done.\n\n');

    %fid = load(details.fiducialmat);
    %hmJob = tnueeg_headmodel_job(D, fid, details, options);
    %spm_jobman('run', hmJob);  
    %D = reload(D);
    %fprintf('\nHeadmodel done.\n\n');

    Dc = tnueeg_eyeblink_correction_simple(D, options);
    fprintf('\nSimple eye blink correction done.\n\n');

    %hmJob = tnueeg_headmodel_job(Dc, fid, details, options);
    %spm_jobman('run', hmJob);
    %Dc = reload(Dc);
    %fprintf('\nFinal headmodel done.\n\n');
    
    %-- final artefact rejection ------------------------------------------------------------------%
    [Da, trialStats.numArtefacts, trialStats.idxArtefacts, trialStats.badChannels] = ...
        tnueeg_artefact_rejection_threshold(Dc, options);
    fprintf('\nArtefact rejection done.\n\n');
    
    %-- finish -----------------------------------------------------------%
    D = move(Da, details.prepfilename);
    trialStats.nTrialsFinal = tnueeg_count_good_trials(D);
    save(details.trialstats, 'trialStats');
    
    disp('   ');
    disp(['Detected ' num2str(trialStats.numEyeblinks) ' eye blinks for subject ' id]);
    disp(['Rejected ' num2str(trialStats.numArtefacts) ' additional bad trials.']);
    disp(['Marked ' num2str(trialStats.badChannels.numBadChannels) ' channels as bad.']);
    disp([num2str(trialStats.nTrialsFinal.all) ' remaining good trials in D.']);
    fprintf('\nPreprocessing done: subject %s in task DPRST-MMN.\n', id);
    disp('   ');
    disp('*----------------------------------------------------*');
    disp('   ');
end

cd(options.workdir);
close all

diary OFF
end
