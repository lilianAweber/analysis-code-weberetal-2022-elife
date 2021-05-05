function [ data ] = dprst_table_s2( options, savePath )
%DPRST_TABLE_S2 Collects all data points needed to create table S2 of the ERP 
%paper: effects of mismatch in study 1 (anta) with reduced N.
%   IN:     options     - the struct that holds all analysis options
%           savePath    - where to save the images and data

options.part = 'anta';
[~, paths] = dprst_subjects(options);

tabPath = fullfile(savePath, 'table_s2_anta_reducedN');
mkdir(tabPath);

% collect data for tab. S2A: positive effect of mismatch
resultsDir = fullfile(paths.pharmastatserpredn, '1');
csvTable = fullfile(resultsDir, 'table_contrast1_T_peakFWE.csv');
copyfile(csvTable, fullfile(tabPath, '1_positive_mismatch.csv'));
T = readtable(csvTable);
data.mismatch.pos = T;

% collect data for tab. S2B: negative effect of mismatch
csvTable = fullfile(resultsDir, 'table_contrast2_T_peakFWE.csv');
copyfile(csvTable, fullfile(tabPath, '2_negative_mismatch.csv'));
T = readtable(csvTable);
data.mismatch.neg = T;

% collect data for tab. S2C: Ami > Bip
csvTable = fullfile(resultsDir, 'table_contrast8_T_peakFWE.csv');
copyfile(csvTable, fullfile(tabPath, '3_mismatch_ami_bip.csv'));
T = readtable(csvTable);
data.mismatch.amiBip = T;

% collect data for tab. S2D: positive interaction effect
resultsDir = fullfile(paths.pharmastatserpredn, '3');
csvTable = fullfile(resultsDir, 'table_contrast1_T_peakFWE.csv');
copyfile(csvTable, fullfile(tabPath, '4_positive_interaction.csv'));
T = readtable(csvTable);
data.interact.pos = T;

% collect data for tab. S2E: negative interaction effect
csvTable = fullfile(resultsDir, 'table_contrast2_T_peakFWE.csv');
copyfile(csvTable, fullfile(tabPath, '5_negative_interaction.csv'));
T = readtable(csvTable);
data.interact.neg = T;

%{
% collect data for tab. S2F: positive effect of stable mismatch
resultsDir = fullfile(paths.pharmastatserpredn, '6');
csvTable = fullfile(resultsDir, 'table_contrast1_T_peakFWE.csv');
copyfile(csvTable, fullfile(tabPath, '6_positive_stable_mismatch.csv'));
T = readtable(csvTable);
data.stabMismatch.pos = T;

% collect data for tab. S2G: negative effect of stable mismatch
csvTable = fullfile(resultsDir, 'table_contrast2_T_peakFWE.csv');
copyfile(csvTable, fullfile(tabPath, '7_negative_stable_mismatch.csv'));
T = readtable(csvTable);
data.stabMismatch.neg = T;
%}

% collect data for tab. S2F: positive effect of stability
resultsDir = fullfile(paths.pharmastatserpredn, '2');
csvTable = fullfile(resultsDir, 'table_contrast1_T_peakFWE.csv');
copyfile(csvTable, fullfile(tabPath, '6_positive_stability.csv'));
T = readtable(csvTable);
data.stability.pos = T;

%% these are only sig. within the mask - create custom tables?
%{
resultsDir = fullfile(paths.pharmastatserpredn, '6');
% collect data for tab. 4C: Pla > Bip
csvTable = fullfile(resultsDir, 'table_contrast5_T_peakFWE.csv');
copyfile(csvTable, tabPath);
T = readtable(csvTable);
data.stabMismatch.plaBip = T;

% collect data for tab. 4D: Bip > Pla
csvTable = fullfile(resultsDir, 'table_contrast6_T_peakFWE.csv');
copyfile(csvTable, tabPath);
T = readtable(csvTable);
data.stabMismatch.bipPla = T;

% collect data for tab. 4E: Ami > Bip
csvTable = fullfile(resultsDir, 'table_contrast8_T_peakFWE.csv');
copyfile(csvTable, tabPath);
T = readtable(csvTable);
data.stabMismatch.amiBip = T;
%}

% save all paper-relevant data for this table
save(fullfile(tabPath, 'tabdata.mat'), 'data');

end

