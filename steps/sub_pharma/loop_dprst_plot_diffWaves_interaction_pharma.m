function loop_dprst_plot_diffWaves_interaction_pharma( options )
%LOOP_DPRST_PLOT_DIFFWAVES_INTERACTION_PHARMA

if nargin < 1
    options = dprst_set_analysis_options;
end

[~, paths] = dprst_subjects(options);

mmnType = 'interactDiff';
options.erp.channels = {...
    'C2'}; %Pla>Bip 232

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
    
    if ~isfield(gaPla, 'interactDiff')
        gaPla = dprst_compute_interaction_diffDiffWaves(gaPla);
        gaDA = dprst_compute_interaction_diffDiffWaves(gaDA);
        gaACh = dprst_compute_interaction_diffDiffWaves(gaACh);
    end
    

    h = dprst_plot_diffWaves_pharma(gaPla, gaDA, gaACh, ...
        options.erp.channels{iChan}, mmnType, options);
    savefig(h, fullfile(paths.pharmaerpfold, ...
        ['all_ga_sem_diffWaves_' options.erp.type '_interaction_' options.erp.channels{iChan} '.fig']));
end

%close all

end