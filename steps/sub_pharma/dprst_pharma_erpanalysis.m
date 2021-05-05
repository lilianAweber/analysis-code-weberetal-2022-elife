function dprst_pharma_erpanalysis(options)
%DPRST_PHARMA_ERPANALYSIS Computes the grandaverages of ERPs per drug group
%in the DPRST study.
%   IN:     options - the struct that holds all analysis options
%   OUT:    --

% general analysis options
if nargin < 1
    options = dprst_set_analysis_options;
end

% paths and files
[~, paths] = dprst_subjects(options);

% record what we're doing
diary(paths.logfile);
tnueeg_display_analysis_step_header('pharma erpanalysis', 'dprst', ...
    'all', options.erp);

if ~exist(paths.pharmaerpfold, 'dir')
    mkdir(paths.pharmaerpfold)
end

% Prepare SPM, as always
spm('Defaults', 'EEG');

try
    % check for previous erpanalysis
    finalFig = fullfile(paths.pharmaerpfold, ...
        ['all_ga_sem_' options.erp.type '_' chanName '.fig']);
    openfig(finalFig)
    disp(['Grand averages of ' options.erp.type ' ERPs for pharma have been ' ...
        'computed before.']);
    if options.erp.overwrite
        disp('Overwriting...');
        error('Continue to grand average step');
    else
        disp('Nothing is being done.');
    end
catch
    disp(['Computing grand averages of ' options.erp.type  ...
        ' ERPs for pharma analysis...']);
    
    % determine subject IDs per drug group
    groups = dprst_pharma_form_drug_groups_anonym(paths, options);    

    for drugGroup = 1: numel(groups)
        % make sure we have a results directory
        GAroot = fullfile(paths.pharmaerpfold, char(groups{drugGroup}.label));
        if ~exist(GAroot, 'dir')
            mkdir(GAroot);
            cd(GAroot);
        end

        %% all conditions
        % averaged ERP data in one condition in each subject
        % serve as input to 2nd level grand averages 
        nSubjects = numel(groups{drugGroup}.subjIDs);
        erpfiles = cell(nSubjects, 1);
        for sub = 1: nSubjects
            subID = char(groups{drugGroup}.subjIDs{sub});
            details = dprst_subjects(subID, options);
            erpfiles{sub, 1} = details.erpfile;
        end

        % compute the grand averages and variance estimates for selected electrodes
        for iCh = 1: numel(options.erp.channels)
            channel = char(options.erp.channels{iCh});
            ga = tnueeg_grandmean_with_error(erpfiles, channel, 1);
            save(fullfile(paths.pharmaerpfold, char(groups{drugGroup}.label), ...
            ['tnu_ga_' options.erp.type '_' options.erp.channels{iCh} '.mat']), 'ga');
        end
        
        %% difference Waves
        switch options.erp.type
            case {'roving', 'fair'}
                % averaged ERP data in one condition in each subject
                % serve as input to 2nd level grand averages 
                nSubjects = numel(groups{drugGroup}.subjIDs);
                erpfiles = cell(nSubjects, 1);
                for sub = 1: nSubjects
                    subID = char(groups{drugGroup}.subjIDs{sub});
                    details = dprst_subjects(subID, options);
                    erpfiles{sub, 1} = details.difffile;
                end

                % compute the grand averages and variance estimates for selected electrodes
                for iCh = 1: numel(options.erp.channels)
                    channel = char(options.erp.channels{iCh});
                    ga = tnueeg_grandmean_with_error(erpfiles, channel, 1);
                    save(fullfile(paths.pharmaerpfold, char(groups{drugGroup}.label), ...
                    ['tnu_ga_diffWaves_' options.erp.type '_' options.erp.channels{iCh} '.mat']), 'ga');
                end

                % compute the grand averages for all electrodes using SPM
                D = tnueeg_grandmean_spm(erpfiles, paths.spmganame);
                move(D, fullfile(paths.pharmaerpfold, char(groups{drugGroup}.label), ...
                    [paths.spmganame '_diffWaves.mat']));
                disp(['Computed grand average difference waves of ' options.erp.type ...
                    ' ERPs for drug group ' char(groups{drugGroup}.label) '.']);
        end
    end
    
    % plot the drug groups together, per channel
    for iCh = 1: numel(options.erp.channels)
        channel = char(options.erp.channels{iCh});
        
        %% all conditions
        gaPla = getfield(load(fullfile(paths.pharmaerpfold, char(groups{1}.label), ...
        ['tnu_ga_' options.erp.type '_' channel '.mat'])), 'ga');

        gaDA = getfield(load(fullfile(paths.pharmaerpfold, char(groups{2}.label), ...
        ['tnu_ga_' options.erp.type '_' channel '.mat'])), 'ga');

        gaACh = getfield(load(fullfile(paths.pharmaerpfold, char(groups{3}.label), ...
        ['tnu_ga_' options.erp.type '_' channel '.mat'])), 'ga');

        saveName = fullfile(paths.pharmaerpfold, ['all_ga_sem_' options.erp.type '_' channel '.fig']);
        h = dprst_pharma_grandmean_plot(gaPla, gaDA, gaACh, channel, options);
        savefig(h, saveName);
        
        %% difference waves
        switch options.erp.type
            case {'roving', 'fair'}
                gaPla = getfield(load(fullfile(paths.pharmaerpfold, char(groups{1}.label), ...
                ['tnu_ga_diffWaves_' options.erp.type '_' channel '.mat'])), 'ga');

                gaDA = getfield(load(fullfile(paths.pharmaerpfold, char(groups{2}.label), ...
                ['tnu_ga_diffWaves_' options.erp.type '_' channel '.mat'])), 'ga');

                gaACh = getfield(load(fullfile(paths.pharmaerpfold, char(groups{3}.label), ...
                ['tnu_ga_diffWaves_' options.erp.type '_' channel '.mat'])), 'ga');

                saveName = fullfile(paths.pharmaerpfold, ['all_ga_diffWaves_sem_' options.erp.type '_' channel '.fig']);
                h = dprst_pharma_diffWaves_plot(gaPla, gaDA, gaACh, channel, options);
                savefig(h, saveName);
        end
    end
    close all;
end
cd(options.workdir);

diary OFF
end



