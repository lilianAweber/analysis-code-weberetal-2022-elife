function dprst_copy_raw_pharma_data_into_analysis_folder( options )

if ~exist(options.workdir, 'dir')
    error('Working directory not found on this computer')
end

if ~exist(options.rawdir, 'dir')
    error('Raw data location not found on this computer')
end

% source: where are the raw data currently
rawDataSource   = fullfile(options.rawdir, 'pharma');

% destination: where should I put them
destAnta     = fullfile(options.workdir, 'anta', 'pharma');
destAgon     = fullfile(options.workdir, 'agon', 'pharma');

if ~exist(destAnta, 'dir')
    mkdir(destAnta);
end
if ~exist(destAgon, 'dir')
    mkdir(destAgon);
end

% copy over all pharma and gene data
antaSources = dir(fullfile(rawDataSource, 'dprst_anta_*.mat'));
agonSources = dir(fullfile(rawDataSource, 'dprst_agon_*.mat'));
for iFile = 1: numel(antaSources)
    copyfile(fullfile(rawDataSource, antaSources(iFile).name), ...
        fullfile(destAnta, antaSources(iFile).name));
end
for iFile = 1: numel(agonSources)
    copyfile(fullfile(rawDataSource, agonSources(iFile).name), ...
        fullfile(destAgon, agonSources(iFile).name));
end

disp('Copied raw pharma data');
