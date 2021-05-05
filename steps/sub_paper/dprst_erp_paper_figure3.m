function [ data ] = dprst_erp_paper_figure3( options, savePath )
%DPRST_ERP_PAPER_FIGURE3 Collects all images and data points needed to 
%create figure 3 of the ERP paper: drug effects on mismatch in study 1
%   IN:     options     - the struct that holds all analysis options
%           savePath    - where to save the images and data
%   OUT:    data        - data needed for labels in the figure

options.part = 'anta';
[~, paths] = dprst_subjects(options);

figPath = fullfile(savePath, 'figure_3_anta_mismatch_drug');
mkdir(figPath);

% Panel A needs:
% contour overlay 
% scalpmap 1
% colorbar
% ERP plot
% legend
% data: peak; sig. timewindows; scalpmap timepoints?

% collect data for fig. 3A: SPM results for drug on mismatch
resultsDir = fullfile(paths.pharmastatserp, '1');
resultsDirErp = paths.pharmaerpfold;
figDir = fullfile(figPath, 'panelA');
mkdir(figDir);

% for mismatch drug effects, we're showing 2 cluster with ERP
copyfile(fullfile(resultsDir, 'con8_contours', ...
    'contour_T_plevel_FWE_p0.05_cluster1*.png'), figDir);
copyfile(fullfile(resultsDir, 'con8_scalpmaps', ...
    'scalpmaps_spmT_0014_plevel_ft_cluster1*.png'), figDir);
copyfile(fullfile(resultsDir, 'con8_scalpmaps', ...
    'colmap_scalpmaps_spmT_0014_plevel_ft_cluster1*.png'), figDir);
copyfile(fullfile(resultsDirErp, ...
    'all_ga_sem_diffWaves_phases_roving_mismatch_Fp2.fig'), figDir);
copyfile(fullfile(resultsDirErp, ...
    'legends_drugs.png'), figDir);

con = getfield(load(fullfile(resultsDir, 'con8_T_peakFWE.mat')), 'con');

% we're marking the sig. timewindows of one cluster in yellow:
data.drug.peak      = con.clusters.peak; 
data.drug.timewin   = con.clusters.timewin;

% Panel B (stable mismatch) needs:
% ERPs F3, C2, Fz for stable mismatch
% scalpmaps Bip>Ami, Bip>Pla, Pla>Bip for stable mismatch
% colorbar
% legend drugs

% collect data for fig. 3B: drug effects on stable mismatch
resultsDir = fullfile(paths.pharmastatserp, '6');
resultsDirErp = paths.pharmaerpfold;
figDir = fullfile(figPath, 'panelB');
mkdir(figDir);

% we need 3 scalpmaps+colorbar and 3 ERP plots+legend
copyfile(fullfile(resultsDir, 'con8_scalpmaps', ... Bip>Ami
    'scalpmaps_spmT_0014_plevel_ft_cluster1*.png'), figDir);
copyfile(fullfile(resultsDir, 'con6_scalpmaps', ... Bip>Pla
    'scalpmaps_spmT_0012_plevel_ft_cluster1*.png'), figDir);
copyfile(fullfile(resultsDir, 'con5_scalpmaps', ... Pla>Bip
    'scalpmaps_spmT_0011_plevel_ft_cluster*.png'), figDir);
copyfile(fullfile(resultsDir, 'con8_scalpmaps', ...
    'colmap_scalpmaps_spmT_0014_plevel_ft_cluster1*.png'), figDir);

copyfile(fullfile(resultsDirErp, ...
    'all_ga_sem_diffWaves_phases_roving_stable_mismatch_F3.fig'), figDir);
copyfile(fullfile(resultsDirErp, ...
    'all_ga_sem_diffWaves_phases_roving_stable_mismatch_C2.fig'), figDir);
copyfile(fullfile(resultsDirErp, ...
    'all_ga_sem_diffWaves_phases_roving_stable_mismatch_Fz.fig'), figDir);
copyfile(fullfile(resultsDirErp, ...
    'legends_drugs.png'), figDir);

% Panel C (selected sensors) needs:
% ERP diffWaves Fp2, FCz, O1 for mismatch
% legend drugs

% collect data for fig. 3C: selected sensors for mismatch
resultsDirErp = paths.pharmaerpfold;
figDir = fullfile(figPath, 'panelC');
mkdir(figDir);

copyfile(fullfile(resultsDirErp, ...
    'all_ga_sem_diffWaves_phases_roving_mismatch_Fp2.fig'), figDir);
copyfile(fullfile(resultsDirErp, ...
    'all_ga_sem_diffWaves_phases_roving_mismatch_FCz.fig'), figDir);
copyfile(fullfile(resultsDirErp, ...
    'all_ga_sem_diffWaves_phases_roving_mismatch_O1.fig'), figDir);
copyfile(fullfile(resultsDirErp, ...
    'legends_drugs.png'), figDir);

% Panel D (scalpmaps over time) needs:
% scalpmaps at diff. time points for pla, ami, bip
% 1 colorbar

% collect data for fig. 3D: mismatch scalp distributions
resultsDir = fullfile(paths.pharmastatserp, '1', 'scalpmaps_drugs_timepoints');
figDir = fullfile(figPath, 'panelD');
mkdir(figDir);
for timePoint = [164 176 204 224]
    copyfile(fullfile(resultsDir, ...
        ['scalpmap_mismatch_placebo_at_' num2str(timePoint) 'ms.png']), figDir);
    copyfile(fullfile(resultsDir, ...
        ['scalpmap_mismatch_amisulpride_at_' num2str(timePoint) 'ms.png']), figDir);
    copyfile(fullfile(resultsDir, ...
        ['scalpmap_mismatch_biperiden_at_' num2str(timePoint) 'ms.png']), figDir);
end

copyfile(fullfile(resultsDir, ...
        'colmap_scalpmaps_mismatch.png'), figDir);

    % save relevant data
save(fullfile(figPath, 'figdata.mat'), 'data');

end

