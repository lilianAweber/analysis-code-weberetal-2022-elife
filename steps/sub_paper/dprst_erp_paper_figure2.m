function [ data ] = dprst_erp_paper_figure2( options, savePath )
%DPRST_ERP_PAPER_FIGURE2 Collects all images and data points needed to 
%create figure 2 of the ERP paper: mismatch effects in study 1
%   IN:     options     - the struct that holds all analysis options
%           savePath    - where to save the images and data
%   OUT:    data        - data needed for labels in the figure

options.part = 'anta';
[~, paths] = dprst_subjects(options);

figPath = fullfile(savePath, 'figure_2_anta_mismatch');
mkdir(figPath);

% Panel A needs:
% contour overlay 
% scalpmap 1
% scalpmap 2
% colorbar
% data: peak; sig. timewindows; scalpmap timepoints?

% collect data for fig. 2A: SPM results for mismatch 
resultsDir = fullfile(paths.pharmastatserp, '1');
figDir = fullfile(figPath, 'panelA');
mkdir(figDir);

% for mismatch, we're showing 2 clusters (out of xx)
copyfile(fullfile(resultsDir, 'con1_contours', ...
    'contour_T_plevel_FWE_p0.05_cluster1*.png'), figDir);
copyfile(fullfile(resultsDir, 'con1_scalpmaps', ...
    'scalpmaps_spmT_0006_plevel_ft_cluster1*.png'), figDir);
copyfile(fullfile(resultsDir, 'con1_scalpmaps', ...
    'scalpmaps_spmT_0006_plevel_ft_cluster3*.png'), figDir);
copyfile(fullfile(resultsDir, 'con1_scalpmaps', ...
    'colmap_scalpmaps_spmT_0006_plevel_ft_cluster1*.png'), figDir);

con = getfield(load(fullfile(resultsDir, 'con1_T_peakFWE.mat')), 'con');

% we're marking the sig. timewindows of three clusters in yellow:
data.mismatch.peak1      = con.clusters(1).peak; % main cluster
data.mismatch.timewin1   = con.clusters(1).timewin;
data.mismatch.peak2      = con.clusters(3).peak; % middle cluster (276ms)
data.mismatch.timewin2   = con.clusters(3).timewin;
data.mismatch.peak3      = con.clusters(2).peak; % late cluster (400ms)
data.mismatch.timewin3   = con.clusters(2).timewin;

% Panel B needs:
% ERPs FCz
% ERPs TP9
% legend conditions
% legend drugs

% collect data for fig. 2B: ERP plots for mismatch
resultsDir = paths.pharmaerpfold;
figDir = fullfile(figPath, 'panelB');
mkdir(figDir);

% we plot FCz and TP9
copyfile(fullfile(resultsDir, ...
    'all_ga_sem_phases_roving_mismatch_FCz.fig'), figDir);
copyfile(fullfile(resultsDir, ...
    'all_ga_sem_phases_roving_mismatch_TP9.fig'), figDir);
copyfile(fullfile(resultsDir, ...
    'legends_conditions_diff.png'), figDir);
copyfile(fullfile(resultsDir, ...
    'legends_drugs.png'), figDir);

% save relevant data
save(fullfile(figPath, 'figdata.mat'), 'data');

end

