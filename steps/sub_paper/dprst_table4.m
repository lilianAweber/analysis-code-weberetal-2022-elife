function [ data ] = dprst_table4( options, savePath )
%DPRST_TABLE4 Collects all data points needed to create table 4 of the ERP 
%paper: effects of stable mismatch in study 1 (anta).
%   IN:     options     - the struct that holds all analysis options
%           savePath    - where to save the images and data

options.part = 'anta';
[~, paths] = dprst_subjects(options);

tabPath = fullfile(savePath, 'table_4_anta_stable_mismatch');
mkdir(tabPath);
resultsDir = fullfile(paths.pharmastatserp, '6');

%{
% collect data for tab. 4A: positive effetc of mismatch
csvTable = fullfile(resultsDir, 'table_contrast1_T_peakFWE.csv');
copyfile(csvTable, tabPath);
T = readtable(csvTable);
data.mismatch.pos = T;

% collect data for tab. 4B: negative effect of mismatch
csvTable = fullfile(resultsDir, 'table_contrast2_T_peakFWE.csv');
copyfile(csvTable, tabPath);
T = readtable(csvTable);
data.mismatch.neg = T;
%}

% collect data for tab. 4A: Pla > Bip
csvTable = fullfile(resultsDir, 'table_contrast5_T_peakFWE.csv');
copyfile(csvTable, tabPath);
T = readtable(csvTable);
data.mismatch.plaBip = T;

% collect data for tab. 4B: Bip > Pla
csvTable = fullfile(resultsDir, 'table_contrast6_T_peakFWE.csv');
copyfile(csvTable, tabPath);
T = readtable(csvTable);
data.mismatch.bipPla = T;

% collect data for tab. 4C: Ami > Bip
csvTable = fullfile(resultsDir, 'table_contrast8_T_peakFWE.csv');
copyfile(csvTable, tabPath);
T = readtable(csvTable);
data.mismatch.amiBip = T;

% save all paper-relevant data for this table
save(fullfile(tabPath, 'tabdata.mat'), 'data');

end

