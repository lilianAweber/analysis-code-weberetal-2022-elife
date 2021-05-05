function loop_dprst_plot_diffWaves_stable_mismatch_pharma( options )
%LOOP_DPRST_PLOT_DIFFWAVES_STABLE_MISMATCH_PHARMA

if nargin < 1
    options = dprst_set_analysis_options;
end

[~, paths] = dprst_subjects(options);

mmnType = 'stableDiff';
options.erp.channels = {'F3', 'C2', 'Fz', ...
    ...'AF7', 'C2', 'C4', ... Pla>Bip 232
    ...'AF7', 'Fz', ... Pla>Bip 280
    ...'C2', 'C4', 'FC2', 'FC4', ... Bip>Pla 236
    ...'AF7', 'Fp1', ... Ami>Bip 228 (mask)
    ...'Fp2', 'FC5', 'FC3', 'F5', 'F3' ... Bip>Ami 188
    }; 

switch options.part
    case 'anta'
        daName = 'Amisulpride';
        achName = 'Biperiden';
    case 'agon'
        daName = 'Levodopa';
        achName = 'Galantamine';
end

for iChan = 1: numel(options.erp.channels)
    gaPla = getfield(load(fullfile(paths.pharmaerpfold, 'Placebo', ...
        ['tnu_ga_' options.erp.type '_' options.erp.channels{iChan} '.mat'])), 'ga');
    gaDA = getfield(load(fullfile(paths.pharmaerpfold, daName, ...
        ['tnu_ga_' options.erp.type '_' options.erp.channels{iChan} '.mat'])), 'ga');
    gaACh = getfield(load(fullfile(paths.pharmaerpfold, achName, ...
        ['tnu_ga_' options.erp.type '_' options.erp.channels{iChan} '.mat'])), 'ga');
    
    if ~isfield(gaPla, 'stableDiff')
        gaPla = dprst_compute_interaction_diffWaves(gaPla);
        gaDA = dprst_compute_interaction_diffWaves(gaDA);
        gaACh = dprst_compute_interaction_diffWaves(gaACh);
    end

    h = dprst_plot_diffWaves_pharma(gaPla, gaDA, gaACh, ...
        options.erp.channels{iChan}, mmnType, options);
    savefig(h, fullfile(paths.pharmaerpfold, ...
        ['all_ga_sem_diffWaves_' options.erp.type '_stable_mismatch_' options.erp.channels{iChan} '.fig']));
end

%close all

end