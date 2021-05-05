function loop_dprst_plot_diffWaves_mismatch_pharma( options )
%LOOP_DPRST_PLOT_DIFFWAVES_MISMATCH_PHARMA

if nargin < 1
    options = dprst_set_analysis_options;
end

[~, paths] = dprst_subjects(options);

mmnType = 'mismatch';


switch options.part
    case 'anta'
        daName = 'Amisulpride';
        achName = 'Biperiden';
        options.erp.channels = {'FCz', 'Fp2', 'O1' ... for paper
            ...'Fp2', ... Bip>Ami 188
            ...'FCz', 'FC5', 'POz', 'PO3', 'O1' ... (neg version of Fp2)
            ...'C4', 'CP4', ... (Bip>Pla at 224 within mask)
            };
    case 'agon'
        daName = 'Levodopa';
        achName = 'Galantamine';
        options.erp.channels = {'F1', 'Fz', 'F2', 'FC1', 'FCz', 'FC2', ...
            'C1', 'Cz', 'C2', 'CP1', 'CPz', 'TP9', 'TP7', 'P7', 'TP10'};
end

for iChan = 1: numel(options.erp.channels)
    gaPla = getfield(load(fullfile(paths.pharmaerpfold, 'Placebo', ...
        ['tnu_ga_' options.erp.type '_' options.erp.channels{iChan} '.mat'])), 'ga');
    gaDA = getfield(load(fullfile(paths.pharmaerpfold, daName, ...
        ['tnu_ga_' options.erp.type '_' options.erp.channels{iChan} '.mat'])), 'ga');
    gaACh = getfield(load(fullfile(paths.pharmaerpfold, achName, ...
        ['tnu_ga_' options.erp.type '_' options.erp.channels{iChan} '.mat'])), 'ga');
    
    %if ~isfield(gaPla, 'mismatch')
        if ~isfield(gaPla, 'standards')
            gaPla = dprst_compute_mismatch_ERPs(gaPla);
            gaDA = dprst_compute_mismatch_ERPs(gaDA);
            gaACh = dprst_compute_mismatch_ERPs(gaACh);
        end
        gaPla = dprst_compute_mismatch_diffWaves(gaPla);
        gaDA = dprst_compute_mismatch_diffWaves(gaDA);
        gaACh = dprst_compute_mismatch_diffWaves(gaACh);
    %end

    h = dprst_plot_diffWaves_pharma(gaPla, gaDA, gaACh, ...
        options.erp.channels{iChan}, mmnType, options);
    savefig(h, fullfile(paths.pharmaerpfold, ...
        ['all_ga_sem_diffWaves_' options.erp.type '_mismatch_' options.erp.channels{iChan} '.fig']));
end

%close all

end