% --- Analysis script for DPRST MMN ERP paper results --- %

% setup Matlab path, including SPM toolbox as provided in this repo
dprst_setup_paths;

% general analysis options, including all subject PPIDs
options = dprst_set_analysis_options;

% setting up the analysis tree
dprst_setup_analysis_folder;

% do all the analyses separately for each study arm
for partCell = {'anta', 'agon'}
    options.part = char(partCell);
    
    %% Behavioral analysis and preprocessing
    % loop over subjects for subject-specific steps
    loop_dprst_behav_and_preproc(options);
    
    % summarize quality and behavior for the whole group
    dprst_quality_check(options);
    dprst_group_behavior(options); % this isn't actually used in the paper
    
    % we exclude the following participants from further analysis due to
    % insufficient qualtiy after preprocessing:
    switch options.part
        case 'anta'
            options.anta.excludedSubjectIDs = {...
                '0160', ... (failure to effectively correct for EBs)
                '0106', ... (failure to effectively correct for EBs: bad channels)
                };
        case 'agon'
            options.agon.excludedSubjectIDs = {...
                };
    end
    
    options.(options.part).subjectIDs = ...
        setdiff(options.(options.part).subjectIDs, ...
        options.(options.part).excludedSubjectIDs);
    
    %% ERP and statistics on the first level
    % loop over subjects for subject-specific steps
    loop_dprst_erp_and_1stlevel_stats(options);
    
    %% Group analysis with full sample size
    % Group-level ERPs and statistics: average & drug effects
    loop_dprst_pharma(options, options.part);
    
    % Report SPM results & create ERP plots: no genetic effects
    options.pharma.genesAsCovariate = 0;
    dprst_report_spm_results_pharma_erpstats(options, options.part);
    dprst_plot_all_erp_results(options, options.part);
    
    % Report SPM results for genetic covariates
    options.pharma.genesAsCovariate = 1;
    options.pharma.gene = 'COMT';
    dprst_report_spm_results_pharma_erpstats_with_genes(...
        options, options.part);
    options.pharma.gene = 'ChAt';
    dprst_report_spm_results_pharma_erpstats_with_genes(...
        options, options.part);
    
    %% Reduced sample size
    % we rerun the group level ERP analysis once without the following 
    % participants due to issues with their behavioral data
    
    switch options.part
        case 'anta'
            options.anta.rerunExcludedSubjectIDs = {...
                '0176', ... (hit rate below 75%)
                '0163', ... (missing behavioral data)
                '0173', ... (missing behavioral data)
                '0177', ... (missing behavioral data)
                };
        case 'agon'
            options.agon.rerunExcludedSubjectIDs = {...
                '0209', ... (hit rate below 75%)
                };
    end
    
    options.(options.part).subjectIDs = ...
        setdiff(options.(options.part).subjectIDs, ...
        options.(options.part).rerunExcludedSubjectIDs);

    % Rerun SPM ERP stats
    options.pharma.genesAsCovariate = 0;
    dprst_pharma_erpstats_roving_phases_from_1stlevel_redN(options);
    
    % Report SPM results
    dprst_report_spm_results_pharma_erpstats_redN(options, options.part);
    
end

%% Collect paper info/figures
% First, create all additional scalpmaps that are shown in the paper
dprst_scalpmap_collections(options);
% Now collect everything into a 'paperdata' folder
dprst_collect_paper_data(options);

% For prettier paper figures, I additionally used the functions in this
% collection (to adjust line widths, tick sizes, etc.) - not necessary
% to run this for replicating the results!
% paper_figures_final;
    
