function [ data ] = dprst_table_s1( options, savePath )
%DPRST_TABLE_S1 Collects all data points needed to create table S1 of the ERP 
%paper: effects of stability in study 1 (anta) and 2 (agon).
%   IN:     options     - the struct that holds all analysis options
%           savePath    - where to save the images and data

tabPath = fullfile(savePath, 'table_s1_stability');
mkdir(tabPath);

options.part = 'anta';
[~, paths] = dprst_subjects(options);
resultsDir = fullfile(paths.pharmastatserp, '2');

% collect data for tab. S1A: positive effect of stability in anta
csvTable = fullfile(resultsDir, 'table_contrast1_T_peakFWE.csv');
copyfile(csvTable, fullfile(tabPath, '1_anta_positive_stability.csv'));
T = readtable(csvTable);
data.stability.antaPos = T;

options.part = 'agon';
[~, paths] = dprst_subjects(options);
resultsDir = fullfile(paths.pharmastatserp, '2');

% collect data for tab. S1B: negative effect of stability in agon
csvTable = fullfile(resultsDir, 'table_contrast2_T_peakFWE.csv');
copyfile(csvTable, fullfile(tabPath, '2_agon_negative_stability.csv'));
T = readtable(csvTable);
data.stability.agonNeg = T;

% collect data for tab. S1C: Pla > Lev
csvTable = fullfile(resultsDir, 'table_contrast3_T_peakFWE.csv');
copyfile(csvTable, fullfile(tabPath, '3_agon_pla_lev.csv'));
T = readtable(csvTable);
data.stability.agonPlaLev = T;

% collect data for tab. S1D: Gal > Pla
csvTable = fullfile(resultsDir, 'table_contrast6_T_peakFWE.csv');
copyfile(csvTable, fullfile(tabPath, '4_agon_gal_pla.csv'));
T = readtable(csvTable);
data.stability.agonGalPla = T;

% save all paper-relevant data for this table
save(fullfile(tabPath, 'tabdata.mat'), 'data');

end

