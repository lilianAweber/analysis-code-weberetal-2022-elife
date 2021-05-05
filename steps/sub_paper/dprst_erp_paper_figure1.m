function dprst_erp_paper_figure1( options, savePath )
%DPRST_ERP_PAPER_FIGURE1 Collects all images and data points needed to 
%create figure 1 of the ERP paper: task and behavioral results
%   IN:     options     - the struct that holds all analysis options
%           savePath    - where to save the images and data
%   OUT:    data        - data needed for labels in the figure

options.part = 'anta';
[~, paths] = dprst_subjects(options);

figPath = fullfile(savePath, 'figure_1_task_behavior');
mkdir(figPath);

% Panel A needs:
% paradigm/sequence plot

% collect data for fig. 1A: Tone sequence design
resultsDir = paths.designroot;
figDir = fullfile(figPath, 'panelA');
mkdir(figDir);

% we're plotting the tone sequence only
copyfile(fullfile(resultsDir, 'probability_structure_phases.fig'), figDir);

% Panel B doesn't need any data (task design).

% Panel C & D need:
% notBoxPlot for anta & agon behavior

% collect data for fig. 1C: behavior plots
resultsDir = paths.pharmabehavfold;
figDir = fullfile(figPath, 'panelC');
mkdir(figDir);
copyfile(fullfile(resultsDir, ...
    'anta_behavior_noBoxPlot_HR_RT.fig'), figDir);

% collect data for fig. 1D: behavior plots
options.part = 'agon';
[~, paths] = dprst_subjects(options);
resultsDir = paths.pharmabehavfold;
figDir = fullfile(figPath, 'panelD');
mkdir(figDir);
copyfile(fullfile(resultsDir, ...
    'agon_behavior_noBoxPlot_HR_RT.fig'), figDir);

end

