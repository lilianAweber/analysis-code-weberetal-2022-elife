function [ data ] = dprst_erp_paper_figure_s2( options, savePath )
%DPRST_ERP_PAPER_FIGURE_S2 Collects all images and data points needed to 
%create figure S2 of the ERP paper: stability effects in study 2
%   IN:     options     - the struct that holds all analysis options
%           savePath    - where to save the images and data
%   OUT:    data        - data needed for labels in the figure

options.part = 'agon';
[~, paths] = dprst_subjects(options);

figPath = fullfile(savePath, 'figure_s2_agon_stability');
mkdir(figPath);

% Panel A needs:
% contour overlay 
% scalpmap 1
% scalpmap 2
% colorbar
% data: peak; sig. timewindows; scalpmap timepoints?

% collect data for fig. S2A: SPM results for stability
resultsDir = fullfile(paths.pharmastatserp, '2');
figDir = fullfile(figPath, 'panelA');
mkdir(figDir);

% for stability, we're showing 2 clusters
copyfile(fullfile(resultsDir, 'con2_contours', ...
    'contour_T_plevel_FWE_p0.05_cluster1*.png'), figDir);
copyfile(fullfile(resultsDir, 'con2_scalpmaps', ...
    'scalpmaps_spmT_0007_plevel_ft_cluster1*.png'), figDir);
copyfile(fullfile(resultsDir, 'con2_scalpmaps', ...
    'scalpmaps_spmT_0007_plevel_ft_cluster2*.png'), figDir);
copyfile(fullfile(resultsDir, 'con2_scalpmaps', ...
    'colmap_scalpmaps_spmT_0007_plevel_ft_cluster1*.png'), figDir);

con = getfield(load(fullfile(resultsDir, 'con2_T_peakFWE.mat')), 'con');

% we're marking the sig. timewindows of two clusters in yellow:
data.stability.peak1      = con.clusters(1).peak; % early cluster (268ms)
data.stability.timewin1   = con.clusters(1).timewin;
data.stability.peak2      = con.clusters(2).peak; % late cluster (384ms)
data.stability.timewin2   = con.clusters(2).timewin;

% Panel B needs:
% ERPs Fz
% ERPs F2
% legend conditions
% legend drugs

% collect data for fig. S2B: ERP plots for stability
resultsDir = paths.pharmaerpfold;
figDir = fullfile(figPath, 'panelB');
mkdir(figDir);

% we plot Fz and F2
copyfile(fullfile(resultsDir, ...
    'all_ga_sem_phases_roving_stability_Fz.fig'), figDir);
copyfile(fullfile(resultsDir, ...
    'all_ga_sem_phases_roving_stability_F2.fig'), figDir);
copyfile(fullfile(resultsDir, ...
    'legends_conditions_diff.png'), figDir);
copyfile(fullfile(resultsDir, ...
    'legends_drugs.png'), figDir);


% Panel C needs:
% ERPs AF7, P5, C5, P4
% scalpmap Gal>Pla at 204ms + colorbar
% scalpmap Pla>Lev at 264ms + colorbar
% legend drugs

% collect data for fig. S2C: pharma effects on stability
resultsDir = fullfile(paths.pharmastatserp, '2');
resultsDirErp = paths.pharmaerpfold;
figDir = fullfile(figPath, 'panelC');
mkdir(figDir);


copyfile(fullfile(resultsDir, 'con6_scalpmaps', ...
    'scalpmaps_spmT_0012_plevel_ft_cluster1*.png'), figDir);
copyfile(fullfile(resultsDir, 'con6_scalpmaps', ...
    'colmap_scalpmaps_spmT_0012_plevel_ft_cluster1*.png'), figDir);
copyfile(fullfile(resultsDir, 'con3_scalpmaps', ...
    'scalpmaps_spmT_0009_plevel_ft_cluster1*.png'), figDir);
copyfile(fullfile(resultsDir, 'con3_scalpmaps', ...
    'colmap_scalpmaps_spmT_0009_plevel_ft_cluster1*.png'), figDir);

% we plot AF7, P5, C5, and P4
copyfile(fullfile(resultsDirErp, ...
    'all_ga_sem_diffWaves_phases_roving_stability_AF7.fig'), figDir);
copyfile(fullfile(resultsDirErp, ...
    'all_ga_sem_diffWaves_phases_roving_stability_P5.fig'), figDir);
copyfile(fullfile(resultsDirErp, ...
    'all_ga_sem_diffWaves_phases_roving_stability_C5.fig'), figDir);
copyfile(fullfile(resultsDirErp, ...
    'all_ga_sem_diffWaves_phases_roving_stability_P4.fig'), figDir);
copyfile(fullfile(resultsDirErp, ...
    'legends_drugs.png'), figDir);

% save relevant data
save(fullfile(figPath, 'figdata.mat'), 'data');

end

