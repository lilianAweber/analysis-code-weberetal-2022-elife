function loop_dprst_plot_stability_ERPs_pharma( options )
%LOOP_DPRST_PLOT_STABILITY_ERPS_PHARMA

if nargin < 1
    options = dprst_set_analysis_options;
end

[~, paths] = dprst_subjects(options);
switch options.part
    case 'anta'
        options.erp.channels = {...
            'Fp1', 'Pz', ... % for paper
            ...'Pz', 'POz', 'P2', 'Fp1', 'Oz', ...
            ...'C3', 'CP3', 'C1'... % neg. effect of stability at 124ms in Bip, not Pla
            }; 
        DA = 'Amisulpride';
        ACh = 'Biperiden';
    case 'agon'
        options.erp.channels = {...
            'Fz', 'F2', 'AF7', 'P5', 'C5', 'P4', ... % for paper
            ...'Fz', 'F1', 'F2', 'F3', 'AF3', 'AF4', ... main effect vol>sta 292ms
            ...'C5', 'T7', 'CP5', 'C3', 'FC5', 'FC3', 'FC1', ... Pla>Ami 288ms
            ...'AF7', 'Fp1', 'P5', 'PO3', 'P3' ... % Bip>Pla 228ms
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
    
    h = dprst_plot_stability_ERPs_pharma(gaPla, gaAmi, gaBip, options.erp.channels{iChan}, DA, ACh);
    savefig(h, fullfile(paths.pharmaerpfold, ...
        ['all_ga_sem_' options.erp.type '_stability_' options.erp.channels{iChan} '.fig']));
end

%close all

end