function [ details, paths ] = dprst_subjects( id, options )
%DPRST_SUBJECTS Function that sets all filenames and paths
%   IN:     EITHER (for quering both general and subject-specific paths:
%           id                  - the subject number as a string, e.g. '0001'
%           options (optional)  - the struct that holds all analysis options
%           OR (for only quering general paths & files):
%           options - the struct that holds all analysis options 
%   OUT:    details     - a struct that holds all filenames and paths for
%                       the subject with subject number id
%           paths       - a struct that holds all paths and config files
%                       that are not subject-specific

%-- check input -----------------------------------------------------------------------------------%
if isstruct(id)
    options = id;
    id = 'dummy';
elseif ischar(id) && nargin < 2
    options = dprst_set_analysis_options;
end

if ismember(id, options.anta.subjectIDs)
    options.part = 'anta';
elseif ismember(id, options.agon.subjectIDs)
    options.part =  'agon';
elseif ismember(id, options.anta.pilotIDs)
    options.part =  'anta';
elseif strcmp(id, 'dummy')
    % do nothing, keep options.part as is 
else
    error('Could not determine whether id belongs to anta or agon part');
end

%-- general paths and files -----------------------------------------------------------------------%
paths.confroot      = fullfile(options.workdir, 'config');
paths.designroot    = fullfile(options.workdir, 'design');
paths.qualityroot   = fullfile(options.workdir, options.part, 'quality');
paths.qualityfold   = fullfile(paths.qualityroot, options.preproc.analysis);
paths.behavroot     = fullfile(options.workdir, options.part, 'behavior');
paths.statsroot     = fullfile(options.workdir, options.part, 'stats');   
paths.statserp      = fullfile(paths.statsroot, options.stats.mode, options.erp.type);
paths.erpspmfile    = fullfile(paths.statserp, 'SPM.mat');
paths.erproot       = fullfile(options.workdir, options.part, 'erp');
paths.erpfold       = fullfile(paths.erproot, options.erp.type, options.preproc.analysis); 
paths.spmganame     = ['spm_ga_' options.erp.type];
paths.spmgafile     = fullfile(paths.erpfold, [paths.spmganame '.mat']);
for iCh = 1: numel(options.erp.channels)
    paths.tnugafiles{iCh} = fullfile(paths.erpfold, ...
        ['tnu_ga_' options.erp.type '_' options.erp.channels{iCh} '.mat']);
end

paths.pharmaroot    = fullfile(options.workdir, options.part, 'pharma');
paths.drugLabels    = fullfile(paths.pharmaroot, ['dprst_' options.part '_drugLabels_anonym.mat']);
paths.pharmaLevels  = fullfile(paths.pharmaroot, ['dprst_' options.part '_plasmaLevels_anonym.mat']);
paths.geneLabels    = fullfile(paths.pharmaroot, ['dprst_' options.part '_geneLabels_' options.pharma.gene '_anonym.mat']);

paths.pharmaerpfold = fullfile(paths.pharmaroot, 'erp', options.erp.type);
paths.pharmabehavfold = fullfile(paths.pharmaroot, 'behav');
switch options.pharma.genesAsCovariate
    case 0
        paths.pharmastatserp = fullfile(paths.pharmaroot, 'erpstats', options.erp.type);
        paths.pharmastatserpredn = fullfile(paths.pharmaroot, 'erpstats_redN', options.erp.type);
        paths.pharmastatserpcross = fullfile(paths.pharmaroot, 'erpstats_cross', options.erp.type);
    case 1
        paths.pharmastatserp = fullfile(paths.pharmaroot, ['erpstats_' options.pharma.gene], options.erp.type);
end

% config files
paths.montage       = fullfile(paths.confroot, [options.preproc.rereferencing '_ref_montage.mat']);
paths.trialdef      = fullfile(paths.confroot, ['dprst_trialdef_' ...
                            options.preproc.trialdef '.mat']);

% design files
paths.paradigm      = fullfile(paths.designroot, ['paradigm_bopars.mat']);
                        
% logging 2nd level analyses and quality check
paths.logfile       = fullfile(options.workdir, options.part, 'secondlevel.log');
paths.trialstatstab = fullfile(paths.qualityfold, [options.preproc.analysis, '_table_trial_stats.mat']);
paths.trialstatsfig = fullfile(paths.qualityfold, [options.preproc.analysis, '_overview_trial_stats']);
paths.erptrialstatstab = fullfile(paths.qualityfold, options.erp.type, [options.preproc.analysis, '_table_trial_stats.mat']);
paths.erptrialstatsfig = fullfile(paths.qualityfold, options.erp.type, [options.preproc.analysis, '_overview_trial_stats']);
paths.behavtab      = fullfile(paths.behavroot, 'Table_behavior.mat');
paths.behavfig      = fullfile(paths.behavroot, 'Overview_behavior');
paths.behavresults  = fullfile(paths.behavroot, 'Results_behavior.mat');
paths.behavresultsfig = fullfile(paths.behavroot, 'Results_behavior');
                        
%-- subject-specific options, paths and files -----------------------------------------------------%
% special cases for behavioral analysis
switch id
    case '0132'
        details.responseButtons = {'3', '2'};
    otherwise
        details.responseButtons = {'4', '1'}; 
end

% cabling issues
switch id
    case {'0166', '0251'}
        details.cablingIssue = true;
        details.ebFilePrefix = 'cleaned_fEBbfdfMMspmeeg_';
    otherwise
        details.cablingIssue = false;
        details.ebFilePrefix = 'cleaned_fEBbfdfMspmeeg_';
end

% EB detection threshold
switch id
    case {'0113', '0211', '0218', '0236', '0254'}
        details.eyeblinkthreshold = 4;
    case {'0107', '0118', '0203', '0227', '0240', '0241', '0245', '0246', '0248', '0273'}
        details.eyeblinkthreshold = 12;
    case '0276'
        details.eyeblinkthreshold = 20;
    otherwise
        details.eyeblinkthreshold = options.preproc.eyeblinkthreshold;
end

% bad channels before EB confound estimation
switch id
    case '0106'
        details.preclean.badchannels = [39 31];
    otherwise
        details.preclean.badchannels = [];
end

% bad trials before EB confound estimation
switch id
    case '0172'
        details.preclean.badtrials = [7 8 9 56 64 83 94 118 121];
    case '0203'
        details.preclean.badtrials = [13 14 15 16];
    case '0248'
        details.preclean.badtrials = 1:50;
    case '0254'
        details.preclean.badtrials = 1:250;
    case '0276'
        details.preclean.badtrials = [31 41 42 55];
    otherwise
        details.preclean.badtrials = [];
end

% names
details.subjname     = ['DPRST_' id];

details.rawfilename    = [details.subjname '_' options.task '_task'];
details.prepfilename   = [details.subjname '_' options.task '_preproc'];
details.redefname      = ['redef_' details.subjname '_' options.erp.type];
details.avgname        = ['m' details.subjname '_' options.erp.type];
details.filname        = ['fm' details.subjname '_' options.erp.type];
details.erpname        = [details.subjname '_ERP_' options.erp.type];
details.diffname       = [details.subjname '_diffWaves_' options.erp.type];

% directories
details.subjroot  = fullfile(options.workdir, options.part, 'subjects', details.subjname);
                       
details.rawroot     = fullfile(details.subjroot, 'eeg'); 
details.mriroot     = fullfile(details.subjroot, 'mri');
details.behavroot   = fullfile(details.subjroot, 'behav');

details.preproot    = fullfile(details.subjroot, 'spm_prep', options.preproc.analysis);
details.erproot     = fullfile(details.subjroot, 'spm_erp');
details.erpfold     = fullfile(details.erproot, options.erp.type);

details.designroot  = fullfile(details.subjroot, 'design', options.preproc.analysis);
details.statsroot   = fullfile(details.subjroot, 'spm_stats');
details.erpstatsfold = fullfile(details.statsroot, options.erp.type);

switch options.conversion.mode
    case {'modelbased', 'singletrial_epoch'}
        details.convroot = fullfile(details.preproot, ...
            [options.conversion.convPrefix '_' details.prepfilename]);
    case 'ERPs'
        details.convroot = fullfile(details.erpfold, ...
            [options.conversion.convPrefix '_' details.erpname]);
    case 'diffWaves'
        details.convroot = fullfile(details.erpfold, ...
            [options.conversion.convPrefix '_' details.diffname]); 
    case 'ERP 1stlevel'
        details.convroot = fullfile(details.erpfold, ...
            [options.conversion.convPrefix '_' details.redefname]);
    
end


% files
details.logfile         = fullfile(details.subjroot, [details.subjname '.log']);
details.rawfile         = fullfile(details.rawroot, [details.rawfilename '.eeg']);
details.mrifile         = fullfile(details.mriroot, [details.subjname '_struct.nii']);
details.behavfile       = fullfile(details.behavroot, [details.subjname '_MMN_task.mat']);
details.behavresults    = fullfile(details.behavroot, [details.subjname '_behavior.mat']);
details.practfile       = fullfile(details.behavroot, [details.subjname '_MMN_practice*.mat']);

details.elecfile        = fullfile(details.subjroot, 'digit', [details.subjname '_digit.elc']);
details.correlec        = fullfile(details.subjroot, 'digit', [details.subjname '_digit.sfp']);              

details.fiducialrtf     = fullfile(details.mriroot, [details.subjname '_smri_fiducials.rtf']);
details.fiducialtxt     = fullfile(details.mriroot, [details.subjname '_smri_fiducials.txt']);
details.fiducialmat     = fullfile(details.mriroot, [details.subjname '_smri_fiducials.mat']);

details.prepfile        = fullfile(details.preproot, [details.prepfilename '.mat']);
details.cablemontage    = fullfile(details.preproot, [details.subjname '_channels_rearranged.mat']);
details.rerefmontage    = fullfile(details.preproot, [details.subjname '_montage.mat']);
details.channeldef      = fullfile(details.preproot, [details.subjname '_channeldef.mat']);
details.trialstats      = fullfile(details.preproot, [details.subjname '_trialStats.mat']);
details.ebfile          = fullfile(details.preproot, [details.ebFilePrefix details.rawfilename '.mat']);

details.redeffile       = fullfile(details.erpfold, [details.redefname '.mat']);
details.avgfile         = fullfile(details.erpfold, [details.avgname '.mat']);
details.filfile         = fullfile(details.erpfold, [details.filname '.mat']);
details.erpfile         = fullfile(details.erpfold, [details.erpname '.mat']);
details.difffile        = fullfile(details.erpfold, [details.diffname '.mat']); 
details.erptrialstats   = fullfile(details.erpfold, [details.subjname '_erpTrialStats.mat']);

%details.design          = paths.designFile;
%details.eyeDesign       = fullfile(details.designroot, ...
%                            ['design_EBcorr_' options.preproc.eyeblinktreatment '_' ...
%                            options.stats.design '_' options.stats.priors '.mat']); 
%details.subjectDesign   = fullfile(details.designroot, ...
%                            ['design_' options.preproc.eyeblinktreatment '_' ...
%                            options.stats.design '_' options.stats.priors '.mat']);      

details.erpspmfile      = fullfile(details.erpstatsfold, 'SPM.mat');

% conditions
details.convCon{1} = '';
switch options.conversion.mode
    case {'modelbased', 'singletrial_epoch'}
        details.convCon{1} = 'tone';
    case 'diffWaves' 
        switch options.erp.type
            case {'roving', 'fair'}
                details.convCon{1} = 'mmn';
        end
    case {'ERPs', 'ERP 1stlevel'}
        switch options.erp.type
            case {'roving', 'fair'}
                details.convCon{1} = 'standard';
                details.convCon{2} = 'deviant';
            case {'phases_oddball', 'phases_roving', 'phases_fair'}
                details.convCon{1} = 'stabSta';
                details.convCon{2} = 'stabDev';
                details.convCon{3} = 'volaSta';
                details.convCon{4} = 'volaDev';
            case {'lowhighEpsi2', 'lowhighEpsi3'}
                details.convCon{1} = 'low';
                details.convCon{2} = 'high';
        end
end

for i = 1: length(details.convCon)
    details.convfile{i} = fullfile(details.convroot, ['condition_' details.convCon{i} '.nii,']);
    details.smoofile{i} = fullfile(details.convroot, ['smoothed_condition_' details.convCon{i} '.nii,']);
end


% figures for quality checks (EB detection, EB correction, ERP check)
details.ebdetectfig     = fullfile(details.preproot, [details.subjname '_eyeblinkDetection.fig']);

details.ebspatialfig    = fullfile(details.preproot, [details.subjname '_eyeblinkConfounds.fig']);
details.ebcorrectfig    = fullfile(details.preproot, [details.subjname '_eyeblinkCorrection.fig']);
details.coregdatafig    = fullfile(details.preproot, [details.subjname '_coregistration_data.fig']);
details.coregmeshfig    = fullfile(details.preproot, [details.subjname '_coregistration_mesh.fig']);

details.erpfig          = fullfile(details.erpfold, [details.erpname '_' options.erp.plotchannel '.fig']);
                       

end
