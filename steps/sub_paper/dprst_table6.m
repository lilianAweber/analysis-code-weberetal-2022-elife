function [ data ] = dprst_table6( options, savePath )
%DPRST_TABLE6 Collects all data points needed to create table 6 of the ERP 
%paper: effects of mismatch in study 2 (agon).
%   IN:     options     - the struct that holds all analysis options
%           savePath    - where to save the images and data

options.part = 'agon';
[~, paths] = dprst_subjects(options);

tabPath = fullfile(savePath, 'table_6_agon_mismatch');
mkdir(tabPath);
resultsDir = fullfile(paths.pharmastatserp, '1');

% collect data for tab. 6A: positive effect of mismatch
csvTable = fullfile(resultsDir, 'table_contrast1_T_peakFWE.csv');
copyfile(csvTable, tabPath);
T = readtable(csvTable);
data.mismatch.pos = T;

% collect data for tab. 6B: negative effect of mismatch
csvTable = fullfile(resultsDir, 'table_contrast2_T_peakFWE.csv');
copyfile(csvTable, tabPath);
T = readtable(csvTable);
data.mismatch.neg = T;

% save all paper-relevant data for this table
save(fullfile(tabPath, 'tabdata.mat'), 'data');

end

