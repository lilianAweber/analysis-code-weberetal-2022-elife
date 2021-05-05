function [ data ] = dprst_erp_paper_figure4( options, savePath )
%DPRST_ERP_PAPER_FIGURE4 Collects all images and data points needed to 
%create figure 4 of the ERP paper: interaction effects in study 1
%   IN:     options     - the struct that holds all analysis options
%           savePath    - where to save the images and data
%   OUT:    data        - data needed for labels in the figure

options.part = 'anta';
[~, paths] = dprst_subjects(options);

figPath = fullfile(savePath, 'figure_4_anta_interaction');
mkdir(figPath);

% Panel A needs:
% contour overlay 
% scalpmap 1
% colorbar
% data: peak; sig. timewindows; scalpmap timepoints?

% collect data for fig. 4A: SPM results for interaction effects
resultsDir = fullfile(paths.pharmastatserp, '3');
figDir = fullfile(figPath, 'panelA');
mkdir(figDir);

% for stability, we're showing 2 clusters
copyfile(fullfile(resultsDir, 'con1_contours', ...
    'contour_T_plevel_FWE_p0.05_cluster1*.png'), figDir);
copyfile(fullfile(resultsDir, 'con1_scalpmaps', ...
    'scalpmaps_spmT_0006_plevel_ft_cluster1*.png'), figDir);
%copyfile(fullfile(resultsDir, 'con1_scalpmaps', ...
%    'scalpmaps_spmT_0006_plevel_ft_cluster2*.png'), figDir);
copyfile(fullfile(resultsDir, 'con1_scalpmaps', ...
    'colmap_scalpmaps_spmT_0006_plevel_ft_cluster1*.png'), figDir);

con = getfield(load(fullfile(resultsDir, 'con1_T_peakFWE.mat')), 'con');

% we're marking the sig. timewindows of one cluster in yellow:
data.stability.peak      = con.clusters.peak; 
data.stability.timewin   = con.clusters.timewin;

% Panel B needs:
% ERPs C1 (interaction diffWaves)
% ERPs C2 (interaction diffWaves)
% legend conditions
% legend drugs

% collect data for fig. 4B: ERP plots for interaction effects
resultsDir = paths.pharmaerpfold;
figDir = fullfile(figPath, 'panelB');
mkdir(figDir);

% we plot C1 and C2
copyfile(fullfile(resultsDir, ...
    'all_ga_sem_phases_roving_interaction_C1.fig'), figDir);
copyfile(fullfile(resultsDir, ...
    'all_ga_sem_phases_roving_interaction_C2.fig'), figDir);
copyfile(fullfile(resultsDir, ...
    'legends_conditions_diff.png'), figDir);
copyfile(fullfile(resultsDir, ...
    'legends_drugs.png'), figDir);

% Panel C needs:
% scalpmap Bip>Pla interaction effect at 212ms
% colormap
% ERPs C2 (drug difference waves)
% legend conditions
% legend drugs

% collect data for fig. 4C: ERP plots for interaction effects drug comp.
resultsDir = fullfile(paths.pharmastatserp, '3');
resultsDirErp = paths.pharmaerpfold;
figDir = fullfile(figPath, 'panelC');
mkdir(figDir);

copyfile(fullfile(resultsDir, ...
    'scalpmap_interaction_bip_pla_at_212ms.png'), figDir);
copyfile(fullfile(resultsDir, ...
    'colmap_scalpmap_interaction_bip_pla_at_212ms.png'), figDir);

% we plot C2
copyfile(fullfile(resultsDirErp, ...
    'all_ga_sem_diffWaves_phases_roving_interaction_C2.fig'), figDir);
copyfile(fullfile(resultsDirErp, ...
    'legends_drugs.png'), figDir);


% Panel D needs:
% ERPs C1 
% ERPs C2 
% legend conditions
% legend drugs

% collect data for fig. 4D: ERP plots for interaction effects
resultsDir = paths.pharmaerpfold;
figDir = fullfile(figPath, 'panelD');
mkdir(figDir);

% we plot C1 and C2
copyfile(fullfile(resultsDir, ...
    'all_ga_sem_phases_roving_C1.fig'), figDir);
copyfile(fullfile(resultsDir, ...
    'all_ga_sem_phases_roving_C2.fig'), figDir);
copyfile(fullfile(resultsDir, ...
    'legends_conditions_stadev.png'), figDir);
copyfile(fullfile(resultsDir, ...
    'legends_drugs.png'), figDir);


% save relevant data
save(fullfile(figPath, 'figdata.mat'), 'data');

end

