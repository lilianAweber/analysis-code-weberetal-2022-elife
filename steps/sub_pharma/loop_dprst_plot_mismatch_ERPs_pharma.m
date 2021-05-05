function loop_dprst_plot_mismatch_ERPs_pharma( options )
%LOOP_DPRST_PLOT_MISMATCH_ERPS_PHARMA

if nargin < 1
    options = dprst_set_analysis_options;
end

[~, paths] = dprst_subjects(options);
switch options.part
    case 'anta'
        options.erp.channels = {'FCz', 'TP9', ... for paper
            ...'Fp2' ...
            };
        DA = 'Amisulpride';
        ACh = 'Biperiden';
    case 'agon'
        options.erp.channels = {'FCz', 'TP9', ... for paper
            ...'F1', 'Fz', 'F2', 'FC1', 'FCz', 'FC2', ...
            ...'C1', 'Cz', 'C2', 'CP1', 'CPz', 'TP9', 'TP7', 'P7', 'TP10' ...
            };
        DA = 'Levodopa';
        ACh = 'Galantamine';
end

for iChan = 1: numel(options.erp.channels)
    gaPla = getfield(load(fullfile(paths.pharmaerpfold, 'Placebo', ...
        ['tnu_ga_' options.erp.type '_' options.erp.channels{iChan} '.mat'])), 'ga');
    gaAmi = getfield(load(fullfile(paths.pharmaerpfold, DA, ...
        ['tnu_ga_' options.erp.type '_' options.erp.channels{iChan} '.mat'])), 'ga');
    gaBip = getfield(load(fullfile(paths.pharmaerpfold, ACh, ...
        ['tnu_ga_' options.erp.type '_' options.erp.channels{iChan} '.mat'])), 'ga');
    
    h = dprst_plot_mismatch_ERPs_pharma(gaPla, gaAmi, gaBip, options.erp.channels{iChan}, DA, ACh);
    savefig(h, fullfile(paths.pharmaerpfold, ...
        ['all_ga_sem_' options.erp.type '_mismatch_' options.erp.channels{iChan} '.fig']));
end

close all

end