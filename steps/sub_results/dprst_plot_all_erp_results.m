function [] = dprst_plot_all_erp_results( options, flag )
%DPRST_PLOT_ALL_ERP_RESULTS Plots all relevant EEG channels for the various
%ERP effects in the DPRST MMN analysis
%   IN:     options - the struct that holds all analysis options
%   OUT:    --

% general analysis options
if nargin < 1
    options = dprst_set_analysis_options;
    flag = options.part;
end
if ischar(options)
    flag = options;
    options = dprst_set_analysis_options;
end
% sanity check
if ismember(flag, options.parts) && ~strcmp(flag, options.part)
    disp(['Changing options.part field to ' flag]);
    options.part = flag;
end

[~, paths] = dprst_subjects(options);

% plots for average effects
loop_dprst_plot_mismatch_ERPs_pharma(options);
loop_dprst_plot_stability_ERPs_pharma(options);
switch options.part
    case 'anta'
        loop_dprst_plot_interaction_diffWaves_pharma(options);
        % plots for drug effects
        loop_dprst_plot_diffWaves_mismatch_pharma(options);
        loop_dprst_plot_diffWaves_stable_mismatch_pharma(options);
        loop_dprst_plot_diffWaves_interaction_pharma(options);
    case 'agon'
        % plots for drug effects
        loop_dprst_plot_diffWaves_stability_pharma(options);
end
close all

% general legends for all ERP plots
col = dprst_define_colors(options.part);
lineWidthErps = 4;
[fh1, fh2, fh3, fh4] = dprst_create_legends(col, lineWidthErps);

savefig(fh1, fullfile(paths.pharmaerpfold, 'legends_conditions.fig'));
print(fh1, fullfile(paths.pharmaerpfold, 'legends_conditions.png'),'-dpng','-r1000');
savefig(fh2, fullfile(paths.pharmaerpfold, 'legends_drugs.fig'));
print(fh2, fullfile(paths.pharmaerpfold, 'legends_drugs.png'),'-dpng','-r1000');
savefig(fh3, fullfile(paths.pharmaerpfold, 'legends_conditions_diff.fig'));
print(fh3, fullfile(paths.pharmaerpfold, 'legends_conditions_diff.png'),'-dpng','-r1000');
savefig(fh4, fullfile(paths.pharmaerpfold, 'legends_conditions_stadev.fig'));
print(fh4, fullfile(paths.pharmaerpfold, 'legends_conditions_stadev.png'),'-dpng','-r1000');

cd(options.workdir);
close all

diary OFF
end
