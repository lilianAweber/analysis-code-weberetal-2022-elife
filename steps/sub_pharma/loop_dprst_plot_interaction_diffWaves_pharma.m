function loop_dprst_plot_interaction_diffWaves_pharma( options )
%LOOP_DPRST_PLOT_INTERACTION_DIFFWAVES_PHARMA

if nargin < 1
    options = dprst_set_analysis_options;
end

[~, paths] = dprst_subjects(options);
options.erp.channels = {'C1', 'C2'... for paper v2
    ...'C1', 'F1', 'P8', 'TP9', 'CP1', 'F3', ... for paper v1
    ...'C3', 'C1', 'Cz', 'C2', 'CP3', 'CP1', ...
    ...'AF3', 'F3', 'F1', 'P8', 'TP9'...
    };

for iChan = 1: numel(options.erp.channels)
    gaPla = getfield(load(fullfile(paths.pharmaerpfold, 'Placebo', ...
        ['tnu_ga_' options.erp.type '_' options.erp.channels{iChan} '.mat'])), 'ga');
    gaDA = getfield(load(fullfile(paths.pharmaerpfold, 'Amisulpride', ...
        ['tnu_ga_' options.erp.type '_' options.erp.channels{iChan} '.mat'])), 'ga');
    gaACh = getfield(load(fullfile(paths.pharmaerpfold, 'Biperiden', ...
        ['tnu_ga_' options.erp.type '_' options.erp.channels{iChan} '.mat'])), 'ga');
    
    h = dprst_plot_interaction_diffWaves_pharma(gaPla, gaDA, gaACh, options.erp.channels{iChan});
    savefig(h, fullfile(paths.pharmaerpfold, ...
        ['all_ga_sem_' options.erp.type '_interaction_' options.erp.channels{iChan} '.fig']));
end

%close all

end