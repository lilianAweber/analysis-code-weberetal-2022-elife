function options = dprst_set_analysis_options
%DPRST_SET_ANALYSIS_OPTIONS Analysis options function for DPRST project
%   Run this function from the working directory of the analysis (the
%   project folder).
%   IN:     -
%   OUT:    options     - a struct with all analysis parameters for the
%                       different steps of the analysis.

%%%---- ENTER YOUR PATHS HERE -----------------------------------------%%%
% This is the base root for both raw data and analysis (you can skip this
% if you have your raw data in a completely different place than the 
% processed data):
options.maindir = '/media/law/Elements/DPRST/';
% This is the directory where you want the data analysis to happen and 
% where all the results will be stored (the last folder will be created
% automatically, so you can give this analysis a name here):
options.workdir = fullfile(options.maindir, 'prj', 'volmmn_eeg');
% This is the directory where you have put the raw data that came with
% this code (e.g. raw/exp, raw/pharma, and raw/TNU_DPRST_0000 etc.):
options.rawdir  = fullfile(options.maindir, 'raw');
%%%--------------------------------------------------------------------%%%

options.task = 'MMN';
options.part = 'anta'; %'anta', 'agon'
options.parts = {'anta', 'agon'};

%-- subject IDs ----------------------------------------------------------%
options = dprst_get_subjectID_lists(options);

%-- behavior -------------------------------------------------------------%
options.behav.subjectIDs = options.(options.part).subjectIDs;
options.behav.overwrite  = 1;
options.behav.minRT      = 100/1000; % in s
options.behav.maxRT      = 2000/1000; % in s

options.behav.minPerform = 0;
options.behav.maxPerform = 0.7;
options.behav.maxMoney   = 6;
                           
%-- preprocessing --------------------------------------------------------%
options.preproc.subjectIDs      = options.(options.part).subjectIDs;
options.preproc.overwrite       = 0; % whether to overwrite any prev. prepr
options.preproc.keep            = 1; % whether to keep intermediate data

options.preproc.analysis        = 'sensor'; % sensor space or source space (changes preproc)

options.preproc.rereferencing       = 'average'; % average, nose (i.e., no reref)
options.preproc.keepotherchannels   = 1;
options.preproc.lowpassfreq         = 30;
options.preproc.highpassfreq        = 0.1;
options.preproc.downsamplefreq      = 250;

options.preproc.trialdef            = 'tone'; % tone, oddball
options.preproc.trlshift            = 25; % set to 125 for pilots in anta
options.preproc.epochwin            = [-100 400];
options.preproc.baselinecorrection  = 0;

options.preproc.eyeblinktreatment   = 'ssp'; % 'reject', 'ssp'
options.preproc.mrifile             = 'subject';
options.preproc.eyeblinkchannels    = {'VEOG'};
options.preproc.eyeblinkthreshold   = 5; % for SD thresholding: in standard deviations, for amp in uV
options.preproc.windowForEyeblinkdetection = 3; % first event of interest (and optionally last)

options.preproc.eyeblinkmode        = 'eventbased'; % uses EEG triggers for trial onsets
options.preproc.eyeblinkwindow      = 0.5; % in s around blink events
options.preproc.eyeblinktrialoffset = 0.1; % in s: EBs won't hurt <100ms after tone onset
options.preproc.eyeblinkEOGchannel  = 'VEOG'; % EOG channel (name/idx) to plot
options.preproc.eyebadchanthresh    = 0.4; % prop of bad trials due to EBs

options.preproc.eyeconfoundcomps    = 1;
options.preproc.eyecorrectionchans  = {'Fp1', 'Fz', 'AF8', 'T7', 'Oz'};
options.preproc.preclean.doFilter           = true;
options.preproc.preclean.lowPassFilterFreq  = 10;
options.preproc.preclean.doBadChannels      = false;
options.preproc.preclean.doBadTrials        = true;
options.preproc.preclean.doRejection        = true;
options.preproc.preclean.badtrialthresh     = 500;
options.preproc.preclean.badchanthresh      = 0.5;
options.preproc.preclean.rejectPrefix       = 'cleaned_';

options.preproc.badtrialthresh      = 75; % in microVolt
options.preproc.badchanthresh       = 0.2; % prop of bad trials (artefacts)

%-- erp ------------------------------------------------------------------%
options.erp.subjectIDs 	= options.(options.part).subjectIDs;
options.erp.overwrite   = 0; % whether to overwrite any previous erp

options.erp.type        = 'phases_roving'; % roving, phases_oddball, 
                                           % phases_roving, 'lowhighEpsi2',
                                           % 'lowhighEpsi3', 'versions'
switch options.erp.type
    case 'roving'
        options.erp.conditions = {'standard', 'deviant'};
    case {'phases_oddball', 'phases_roving'}
        options.erp.conditions = {'stabSta', 'stabDev', ...
            'volaSta', 'volaDev'};
    case {'lowhighEpsi2', 'lowhighEpsi3'}
        options.erp.conditions = {'lowPE', 'highPE'};
end
options.erp.plotchannel = 'Fz';
options.erp.averaging   = 's'; % s (standard), r (robust)
switch options.erp.averaging
    case 'r'
        options.erp.addfilter = 'f';
    case 's'
        options.erp.addfilter = '';
end

options.erp.percentPE           = 10;
options.erp.contrastWeighting   = 1;
options.erp.contrastPrefix      = 'diff_';
options.erp.contrastName        = 'mmn';
options.erp.channels            = {'Fp1', 'Fp2' ,'F3' ,'F4', ...
                                    'C3', 'C4', 'P3', 'P4', 'O1', ...
                                    'O2', 'F7', 'F8', 'T7', 'T8', ...
                                    'P7', 'P8', 'Fz', 'Cz', 'Pz', ...
                                    'FC1', 'FC2', 'CP1', 'CP2', ...
                                    'FC5', 'FC6', 'CP5', 'CP6', ...
                                    'FT9', 'FT10', 'TP9', 'TP10', ...
                                    'F1', 'F2', 'C1', 'C2', 'P1', ...
                                    'P2', 'AF3', 'AF4', 'FC3', ...
                                    'FC4', 'CP3', 'CP4', 'PO3', ...
                                    'PO4', 'F5', 'F6', 'C5', 'C6', ...
                                    'P5', 'P6', 'AF7'    'AF8', ...
                                    'FT7', 'FT8', 'TP7', 'TP8', ...
                                    'PO7', 'PO8', 'FCz', 'CPz', ...
                                    'Oz', 'POz'};

%-- conversion2images ----------------------------------------------------%
options.conversion.subjectIDs       = options.(options.part).subjectIDs;
options.conversion.overwrite        = 0; % whether to overwrite prev. conv.

options.conversion.mode             = 'ERP 1stlevel'; %'ERPs', 'modelbased', 
                                                    %'diffWaves',
                                                    %'singletrial_epoch',
                                                    %'ERP 1stlevel'
options.conversion.space            = 'sensor';
switch options.conversion.mode
    case {'modelbased', 'ERPs', 'diffWaves', 'ERP 1stlevel'}
        options.conversion.convPrefix   = 'whole';
        options.conversion.convTimeWindow   = [100 400];
    case 'singletrial_epoch'
        options.conversion.convPrefix   = 'epoch';
        options.conversion.convTimeWindow   = [-100 400];
end

switch options.conversion.mode
    case {'ERPs', 'ERP 1stlevel'}
        options.conversion.conditions = options.erp.conditions;
    otherwise
        options.conversion.conditions = cell(1, 0);
end
options.conversion.smooKernel = [16 16 0]; % only smooting in sensor space,
                                           % temporal via filtering

%-- stats ----------------------------------------------------------------%
options.stats.subjectIDs    = options.(options.part).subjectIDs;
options.stats.overwrite     = 1; % whether to overwrite any previous stats

options.stats.mode          = 'ERP 1stlevel'; % options as conversion
options.stats.pValueMode    = 'peakFWE';
options.stats.exampleID     = '0107';

%-- pharma ---------------------------------------------------------------%
options.pharma.subjectIDs   = options.(options.part).subjectIDs;
options.pharma.overwrite    = 0;

% for drug covariates: mean center within group, allow for interaction with
% factor drug - do the mean-centering manually!
options.pharma.drugLevelCovariate = 1; % 0 - none, 1 - two separate, 2 - one
options.pharma.meanCenterDrugCovariateByHand = 1; % 1 yes, 0 no
options.pharma.meanCenterDrugCovariate = 5; % 1 for overall mean centering, 
                                            % 2 for within drug group, 
                                            % 5 for no mean centering!
options.pharma.covariateDrugInteraction = 1; % 1 for yes, 0 for no

% for genes: treat as covariate, mean center within group, interaction with
% drug (optional)
options.pharma.gene         = 'COMT'; % ChAt, COMT
options.pharma.genes        = {'COMT', 'ChAt', 'ChAt2'};
options.pharma.geneGroupReduction = 1; % whether to use 2 groups (reduction=true) or 3
options.pharma.genesAsCovariate = 0; % 1 for yes, 0 for no
options.pharma.meanCenterGeneCovariate = 2; % 1 for overall mean centering, 
                                            % 2 for within drug group, 
                                            % 5 for no mean centering!
options.pharma.covariateGeneInteraction = 2; % 1 for no, 2 for yes

end

function options = dprst_get_subjectID_lists(options)

options.anta.allPPIDs    = {'0101', '0102', '0103', '0104', ...
                            '0105', '0106', '0107', '0108', ...
                            '0109', '0110', '0111', '0112', ...
                            '0113', '0114', '0115', '0116', ...
                            '0117', '0118', '0119', '0120', ...
                            '0121', '0122', '0123', '0124', ...
                            '0125', '0126', '0127', '0128', ...
                            '0129', '0130', '0131', '0132', ...
                            '0133', '0134', '0135', '0136', ...
                            '0137', '0138', '0139', '0140', ...
                            '0141', '0142', '0143', '0144', ...
                            '0145', '0146', '0147', '0148', ...
                            '0149', '0150', '0151', '0152', ...
                            '0153', '0154', '0155', '0156', ...
                            '0157', '0158', '0159', '0160', ...
                            '0161', '0162', '0163', '0164', ...
                            '0165', '0166', '0167', '0168', ...
                            '0169', '0170', '0171', '0172', ...
                            '0173', '0174', '0175', '0176', ...
                            '0177', '0178', '0179', '0180', ...
                            '0181'};
options.anta.noDataIDs   = {'0131', '0171'};
                           % 0131: no MMN; 0171: no headphones
options.anta.pilotIDs    = {'0111', '0125', '0130', '0150', ...
                            '0155', '0162'};
options.anta.noBehavIDs  = {'0162', '0163', '0173', '0177'};
% for the antagonist arm, we exclude 1) IDs that didn't perform MMN
%                                    2) pilot IDs
options.anta.subjectIDs  = setdiff(options.anta.allPPIDs, ...
                           [options.anta.noDataIDs options.anta.pilotIDs]);

options.agon.allPPIDs = {'0201', '0202', '0203', '0204', ...
                         '0205', '0206', '0207', '0208', ...
                         '0209', '0210', '0211', '0212', ...
                         '0213', '0214', '0215', '0216', ...
                         '0217', '0218', '0219', '0220', ...
                         '0221', '0222', '0223', '0224', ...
                         '0225', '0226', '0227', '0228', ...
                         '0229', '0230', '0231', '0232', ...
                         '0233', '0234', '0235', '0236', ...
                         '0237', '0238', '0239', '0240', ...
                         '0241', '0242', '0243', '0244', ...
                         '0245', '0246', '0247', '0248', ...
                         '0249', '0250', '0251', '0252', ...
                         '0253', '0254', '0255', '0256', ...
                         '0257', '0258', '0259', '0260', ...
                         '0261', '0262', '0263', '0264', ...
                         '0265', '0266', '0267', '0268', ...
                         '0269', '0270', '0271', '0272', ...
                         '0273', '0274', '0275', '0276', ...
                         '0277', '0278', '0279', '0280'};
options.agon.noDataIDs   = {'0263', '0277'};
                           % 0263: no plasma levels; 0277: diabetes
options.agon.pilotIDs    = {'0205', '0209', '0211', '0219', ...
                            '0269', '0272'};
options.agon.noBehavIDs  = {};
% for the agonist arm, we only exclude IDs whose data couldn't be used
options.agon.subjectIDs = setdiff(options.agon.allPPIDs, ...
                                  options.agon.noDataIDs);

% overall: subjectIDs without behaviour
options.noBehav.subjectIDs  = {'0162', '0163', '0173', '0177'};
end
