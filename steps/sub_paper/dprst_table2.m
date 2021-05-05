function [ data ] = dprst_table2( options, savePath )
%DPRST_TABLE2 Collects all data points needed to create table 2 of the ERP 
%paper: effects of mismatch in study 1 (anta).
%   IN:     options     - the struct that holds all analysis options
%           savePath    - where to save the images and data

options.part = 'anta';
[~, paths] = dprst_subjects(options);

tabPath = fullfile(savePath, 'table_2_anta_mismatch');
mkdir(tabPath);
resultsDir = fullfile(paths.pharmastatserp, '1');

% collect data for tab. 2A: positive effetc of mismatch
csvTable = fullfile(resultsDir, 'table_contrast1_T_peakFWE.csv');
copyfile(csvTable, tabPath);
T = readtable(csvTable);
data.mismatch.pos = T;

% collect data for tab. 2B: negative effetc of mismatch
csvTable = fullfile(resultsDir, 'table_contrast2_T_peakFWE.csv');
copyfile(csvTable, tabPath);
T = readtable(csvTable);
data.mismatch.neg = T;

% collect data for tab. 2C: Ami > Bip
csvTable = fullfile(resultsDir, 'table_contrast8_T_peakFWE.csv');
copyfile(csvTable, tabPath);
T = readtable(csvTable);
data.mismatch.amiBip = T;

% save all paper-relevant data for this table
save(fullfile(tabPath, 'tabdata.mat'), 'data');

end

