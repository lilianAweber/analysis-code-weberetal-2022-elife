function loop_dprst_behav_and_preproc( options )
%% Loops over subjects in DPRST study and runs behavioral analysis and preprocessing %%

if nargin < 1
    options = dprst_set_analysis_options;
end

for idCell = options.(options.part).subjectIDs
    id = char(idCell);
    
    fprintf('\n\n --------- Working on: %s ---------\n\n', id);

    % prepare SPM, like always
    spm('Defaults', 'EEG');

    %% Behavior in distraction task
    dprst_analyze_behavior(id, options);

    %% Preprocessing of EEG data (in sensor space)
    options.preproc.analysis = 'sensor';
    options.preproc.eyeblinktreatment = 'ssp';
    dprst_preprocessing_ssp(id, options);

    %% ERP analysis (run here for EEG data quality check only)
    options.erp.type = 'roving';
    dprst_erp(id, options);
end

end
