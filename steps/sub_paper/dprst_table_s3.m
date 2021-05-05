function [ data ] = dprst_table_s3( options, savePath )
%DPRST_TABLE_S3 Collects all data points needed to create table 5 of the ERP 
%paper: effects of mismatch in study 2 (agon) with reduced N.
%   IN:     options     - the struct that holds all analysis options
%           savePath    - where to save the images and data

options.part = 'agon';
[~, paths] = dprst_subjects(options);

tabPath = fullfile(savePath, 'table_s3_agon_reducedN');
mkdir(tabPath);

% collect data for tab. S3A: positive effect of mismatch
resultsDir = fullfile(paths.pharmastatserpredn, '1');
csvTable = fullfile(resultsDir, 'table_contrast1_T_peakFWE.csv');
copyfile(csvTable, fullfile(tabPath, '1_positive_mismatch.csv'));
T = readtable(csvTable);
data.mismatch.pos = T;

% collect data for tab. S3B: negative effect of mismatch
csvTable = fullfile(resultsDir, 'table_contrast2_T_peakFWE.csv');
copyfile(csvTable, fullfile(tabPath, '2_negative_mismatch.csv'));
T = readtable(csvTable);
data.mismatch.neg = T;

% collect data for tab. S3C: negative effect of stability
resultsDir = fullfile(paths.pharmastatserpredn, '2');
csvTable = fullfile(resultsDir, 'table_contrast2_T_peakFWE.csv');
copyfile(csvTable, fullfile(tabPath, '3_negative_stability.csv'));
T = readtable(csvTable);
data.stability.pos = T;

% collect data for tab. S3D: Pla > Lev
csvTable = fullfile(resultsDir, 'table_contrast3_T_peakFWE.csv');
copyfile(csvTable, fullfile(tabPath, '4_stability_pla_lev.csv'));
T = readtable(csvTable);
data.stability.plaLev = T;

%% not significant anymore - report p anyway?
%{
% collect data for tab. S3E: Gal > Pla
csvTable = fullfile(resultsDir, 'table_contrast6_T_peakFWE.csv');
copyfile(csvTable, fullfile(tabPath, '5_stability_gal_pla.csv'));
T = readtable(csvTable);
data.stability.galPla = T;
%}

% save all paper-relevant data for this table
save(fullfile(tabPath, 'tabdata.mat'), 'data');

end

