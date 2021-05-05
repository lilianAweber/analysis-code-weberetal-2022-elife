function dprst_quality_check( options )
%DPRST_QUALITY_CHECK Performs all quality checks for the dprst study.
%   IN:     optionally:
%           options         - the struct that contains all analysis options
%   OUT:    -

% general analysis options
if nargin < 1
    options = dprst_set_analysis_options;
end

% paths and files
[~, paths] = dprst_subjects(options);

% prepare SPM;
spm('Defaults', 'EEG');

% create result directory
if ~exist(paths.qualityroot, 'dir')
    mkdir(paths.qualityroot);
end

% Collect trial numbers
dprst_trial_statistics(options);

% Eye-blink treatment
dprst_summarize_step('eyeblinkdetection', options);
dprst_summarize_step('eyeblinkconfounds', options);
dprst_report_step_posthoc('eyeblinkcorrection', options);
dprst_summarize_step('eyeblinkcorrection', options);

% ERP
options.erp.type = 'roving';
dprst_summarize_step('erp', options);


end
