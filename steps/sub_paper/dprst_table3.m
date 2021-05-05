function [ data ] = dprst_table3( options, savePath )
%DPRST_TABLE3 Collects all data points needed to create table 3 of the ERP 
%paper: interaction effects mismatch*stability in study 1 (anta).
%   IN:     options     - the struct that holds all analysis options
%           savePath    - where to save the images and data

options.part = 'anta';
[~, paths] = dprst_subjects(options);

tabPath = fullfile(savePath, 'table_3_anta_interaction');
mkdir(tabPath);

% collect data for tab. 3A: positive interaction effect
resultsDir = fullfile(paths.pharmastatserp, '3');
csvTable = fullfile(resultsDir, 'table_contrast1_T_peakFWE.csv');
copyfile(csvTable, fullfile(tabPath, '1_anta_positive_interaction.csv'));
T = readtable(csvTable);
data.interact.pos = T;

% collect data for tab. 3B: negative interaction effect
resultsDir = fullfile(paths.pharmastatserp, '3');
csvTable = fullfile(resultsDir, 'table_contrast2_T_peakFWE.csv');
copyfile(csvTable, fullfile(tabPath, '2_anta_negative_interaction.csv'));
T = readtable(csvTable);
data.interact.neg = T;

% save all paper-relevant data for this table
save(fullfile(tabPath, 'tabdata.mat'), 'data');

end

