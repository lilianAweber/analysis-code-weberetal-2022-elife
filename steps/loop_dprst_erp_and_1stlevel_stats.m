function loop_dprst_erp_and_1stlevel_stats( options )
%% Loops over subjects in DPRST study and runs ERP analysis and subject-level stats %%

if nargin < 1
    options = dprst_set_analysis_options;
end

for idCell = options.(options.part).subjectIDs
    id = char(idCell);
    
    fprintf('\n\n --------- Working on: %s ---------\n\n', id);

    % prepare SPM, like always
    spm('Defaults', 'EEG');

    %% ERP analysis 
    % averaging
    options.erp.type = 'phases_roving';
    dprst_erp(id, options);
    
    % conversion to images for 1st level stats
    options.conversion.mode = 'ERP 1stlevel';
    options.erp.conditions = {'stabSta', 'stabDev', 'volaSta', 'volaDev'};
    dprst_conversion(id, options);

    % run 1st level GLM
    options.stats.mode = 'ERP 1stlevel';
    dprst_1stlevel_erp_roving_phases(id, options)
    
end

end
