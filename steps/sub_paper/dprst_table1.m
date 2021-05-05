function [ data ] = dprst_table1( options, savePath )
%DPRST_TABLE1 Collects behavioral results in study 1 (anta) for the ERP 
%paper.
%   IN:     options     - the struct that holds all analysis options
%           savePath    - where to save the images and data

options.part = 'anta';
[~, paths] = dprst_subjects(options);

tabPath = fullfile(savePath, 'table_1_anta_behav');
mkdir(tabPath);
resultsDir = paths.pharmabehavfold;
matStruct = fullfile(resultsDir, 'results_behavior_pharma.mat');
copyfile(matStruct, tabPath);
r = getfield(load(matStruct), 'results');
data.behav = r;

% save all paper-relevant data for this table
save(fullfile(tabPath, 'tabdata.mat'), 'data');

end

