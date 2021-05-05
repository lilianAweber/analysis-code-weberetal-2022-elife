function loop_dprst_plot_diffWaves_stability_pharma( options )
%LOOP_DPRST_PLOT_DIFFWAVES_STABILITY_PHARMA

if nargin < 1
    options = dprst_set_analysis_options;
end

[~, paths] = dprst_subjects(options);

mmnType = 'stability';

switch options.part
    case 'anta'
        daName = 'Amisulpride';
        achName = 'Biperiden';
        options.erp.channels = {'Pz', 'POz', 'P2', 'Fp1', 'Oz'}; % no diffs
    case 'agon'
        daName = 'Levodopa';
        achName = 'Galantamine';
        options.erp.channels = {'AF7', 'P5', 'C5', 'P4' ... for paper
            ...'F2', 'CP4', 'P4', ... negative effects
            ...'C5', 'T7', 'CP5', 'C3', 'FC5', 'FC3', 'FC1', ... Pla>Ami 288
            ...'AF7', 'Fp1', 'P5', 'PO3', 'P3', ... Bip>Pla 228
            };
end

for iChan = 1: numel(options.erp.channels)
    gaPla = getfield(load(fullfile(paths.pharmaerpfold, 'Placebo', ...
        ['tnu_ga_' options.erp.type '_' options.erp.channels{iChan} '.mat'])), 'ga');
    gaDA = getfield(load(fullfile(paths.pharmaerpfold, daName, ...
        ['tnu_ga_' options.erp.type '_' options.erp.channels{iChan} '.mat'])), 'ga');
    gaACh = getfield(load(fullfile(paths.pharmaerpfold, achName, ...
        ['tnu_ga_' options.erp.type '_' options.erp.channels{iChan} '.mat'])), 'ga');
    
    if ~isfield(gaPla, 'stability')
        if ~isfield(gaPla, 'stable')
            gaPla = dprst_compute_stability_ERPs(gaPla);
            gaDA = dprst_compute_stability_ERPs(gaDA);
            gaACh = dprst_compute_stability_ERPs(gaACh);
        end
        gaPla = dprst_compute_stability_diffWaves(gaPla);
        gaDA = dprst_compute_stability_diffWaves(gaDA);
        gaACh = dprst_compute_stability_diffWaves(gaACh);
    end

    h = dprst_plot_diffWaves_pharma(gaPla, gaDA, gaACh, ...
        options.erp.channels{iChan}, mmnType, options);
    savefig(h, fullfile(paths.pharmaerpfold, ...
        ['all_ga_sem_diffWaves_' options.erp.type '_stability_' options.erp.channels{iChan} '.fig']));
end

%close all

end