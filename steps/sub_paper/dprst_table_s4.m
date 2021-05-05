function [ data ] = dprst_table_s4( options, savePath )
%DPRST_TABLE_S4 Collects all data points needed to create table S4 of the ERP 
%paper: genetic effects on mismatch in study 1 (anta).
%   IN:     options     - the struct that holds all analysis options
%           savePath    - where to save the images and data

options.part = 'anta';

tabPath = fullfile(savePath, 'table_s4_anta_genes');
mkdir(tabPath);

options.pharma.genesAsCovariate = 1;

% CHAT effects on volatile mismatch
options.pharma.gene = 'ChAt';
[~, paths] = dprst_subjects(options);
resultsDir = fullfile(paths.pharmastatserp, '7');

% collect data for tab. S4A: CHAT: Pla > Bip 
csvTable = fullfile(resultsDir, 'table_contrast9_T_peakFWE.csv');
copyfile(csvTable, fullfile(tabPath, '1_CHAT_volMMN_pla_bip.csv'));
T = readtable(csvTable);
data.CHAT.volMMN.plaBip = T;

% collect data for tab. S4B: CHAT in Pla (pos.)
csvTable = fullfile(resultsDir, 'table_contrast11_T_peakFWE.csv');
copyfile(csvTable, fullfile(tabPath, '2_CHAT_volMMN_pla_pos.csv'));
T = readtable(csvTable);
data.CHAT.volMMN.plaPos = T;

% collect data for tab. S4C: CHAT in Bip (neg.)
csvTable = fullfile(resultsDir, 'table_contrast14_T_peakFWE.csv');
copyfile(csvTable, fullfile(tabPath, '3_CHAT_volMMN_bip_neg.csv'));
T = readtable(csvTable);
data.CHAT.volMMN.bipNeg = T;

% COMT effects on mismatch
options.pharma.gene = 'COMT';
[~, paths] = dprst_subjects(options);
resultsDir = fullfile(paths.pharmastatserp, '1');

% collect data for tab. S4D: COMT in Ami (pos.)
csvTable = fullfile(resultsDir, 'table_contrast13_T_peakFWE.csv');
copyfile(csvTable, fullfile(tabPath, '4_COMT_MMN_ami_pos.csv'));
T = readtable(csvTable);
data.COMT.MMN.amiPos = T;

% collect data for tab. S4E: COMT in Ami (neg.)
csvTable = fullfile(resultsDir, 'table_contrast14_T_peakFWE.csv');
copyfile(csvTable, fullfile(tabPath, '5_COMT_MMN_ami_neg.csv'));
T = readtable(csvTable);
data.COMT.MMN.amiNeg = T;

% COMT effects on stable mismatch
resultsDir = fullfile(paths.pharmastatserp, '6');

% collect data for tab. S4F: COMT in Ami (neg.)
csvTable = fullfile(resultsDir, 'table_contrast14_T_peakFWE.csv');
copyfile(csvTable, fullfile(tabPath, '6_COMT_stabMMN_ami_neg.csv'));
T = readtable(csvTable);
data.COMT.stabMMN.amiNeg = T;

% save all paper-relevant data for this table
save(fullfile(tabPath, 'tabdata.mat'), 'data');

end

