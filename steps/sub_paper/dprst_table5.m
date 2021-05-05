function [ data ] = dprst_table5( options, savePath )
%DPRST_TABLE5 Collects behavioral results in study 2 (agon) for the ERP 
%paper.
%   IN:     options     - the struct that holds all analysis options
%           savePath    - where to save the images and data

options.part = 'agon';
[~, paths] = dprst_subjects(options);

tabPath = fullfile(savePath, 'table_5_agon_behav');
mkdir(tabPath);
resultsDir = paths.pharmabehavfold;
matStruct = fullfile(resultsDir, 'results_behavior_pharma.mat');
copyfile(matStruct, tabPath);
r = getfield(load(matStruct), 'results');
data.behav = r;

% save all paper-relevant data for this table
save(fullfile(tabPath, 'tabdata.mat'), 'data');

end

