function dprst_scalpmap_collections( options )
%DPRST_SCALPMAP_COLLECTIONS This function creates additional scalpmaps that
%are presented in the DPRST ERP paper (figures 3 and 4).

if nargin < 1
    options = dprst_set_analysis_options;
end

options.part = 'anta';
[~, paths] = dprst_subjects(options);
spm('defaults', 'eeg')

% We start by creating the series of scalpmaps for the simple mismatch
% effects as shown in figure 4D
cd(fullfile(paths.pharmastatserp, '1'))

mkdir('scalpmaps_drugs_timepoints');

% First, we need to create contrasts con_0021.nii, con_0022.nii, and 
% con_0023.nii which are the simple effects "mismatch in drug group x":
matlabbatch = [];
matlabbatch{1}.spm.stats.con.spmmat = cellstr(fullfile(paths.pharmastatserp, '1', 'SPM.mat'));
matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = 'mismatch placebo';
matlabbatch{1}.spm.stats.con.consess{1}.tcon.convec = [1];
matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.consess{2}.tcon.name = 'mismatch amisulpride';
matlabbatch{1}.spm.stats.con.consess{2}.tcon.convec = [0 1];
matlabbatch{1}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.consess{3}.tcon.name = 'mismatch biperiden';
matlabbatch{1}.spm.stats.con.consess{3}.tcon.convec = [0 0 1];
matlabbatch{1}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.delete = 0;
spm_jobman('run',matlabbatch);

% Now, we choose the timepoints at which we want to plot the scalpmap
timePoints = [164 176 204 224];
limits = [-5 5];

img.name = 'mismatch_placebo';
img.file = 'con_0021.nii';
dprst_plot_scalpmaps_per_timepoint(timePoints, img, limits, options)

img.name = 'mismatch_amisulpride';
img.file = 'con_0022.nii';
dprst_plot_scalpmaps_per_timepoint(timePoints, img, limits, options)

img.name = 'mismatch_biperiden';
img.file = 'con_0023.nii';
dprst_plot_scalpmaps_per_timepoint(timePoints, img, limits, options)

% We move all png files to subdirectory now
movefile('*.png', 'scalpmaps_drugs_timepoints')
cd('scalpmaps_drugs_timepoints');
movefile('colmap_scalpmap_mismatch_placebo_at_164ms.png', ...
    'colmap_scalpmaps_mismatch.png')
delete('colmap_scalpmap_mismatch_*')


% Finally, we also create a scalpmap of the effect of biperiden versus
% placebo at 212ms and call it "scalpmap_interaction_bip_pla_at_212ms.png"
% and save it in the interaction directory. This is needed for figure 3C.

cd(fullfile(paths.pharmastatserp, '3'))

timePoints = 212;
limits = [-3 3];

img.name = 'interaction_bip_pla';
img.file = 'con_0006.nii';

dprst_plot_scalpmaps_per_timepoint(timePoints, img, limits, options)

