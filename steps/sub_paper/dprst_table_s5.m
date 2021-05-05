function [ data ] = dprst_table_s5( options, savePath )
%DPRST_TABLE_S5 Collects all data points needed to create table S5 of the ERP 
%paper: genetic effects on mismatch in study 2 (agon).
%   IN:     options     - the struct that holds all analysis options
%           savePath    - where to save the images and data

options.part = 'agon';

tabPath = fullfile(savePath, 'table_s5_agon_genes');
mkdir(tabPath);

options.pharma.genesAsCovariate = 1;

% CHAT effects on volatile mismatch
options.pharma.gene = 'ChAt';
[~, paths] = dprst_subjects(options);
resultsDir = fullfile(paths.pharmastatserp, '7');

% collect data for tab. S5A: CHAT in Pla (pos.)
csvTable = fullfile(resultsDir, 'table_contrast11_T_peakFWE.csv');
copyfile(csvTable, fullfile(tabPath, '1_CHAT_volMMN_pla_pos.csv'));
T = readtable(csvTable);
data.CHAT.volMMN.plaPos = T;

% COMT effects on mismatch
options.pharma.gene = 'COMT';
[~, paths] = dprst_subjects(options);
resultsDir = fullfile(paths.pharmastatserp, '7');

% collect data for tab. S5B: COMT in Pla (neg.)
csvTable = fullfile(resultsDir, 'table_contrast12_T_peakFWE.csv');
copyfile(csvTable, fullfile(tabPath, '2_COMT_volMMN_pla_neg.csv'));
T = readtable(csvTable);
data.COMT.volMMN.plaNeg = T;

% save all paper-relevant data for this table
save(fullfile(tabPath, 'tabdata.mat'), 'data');

end

