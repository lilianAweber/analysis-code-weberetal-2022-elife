function dprst_copy_raw_subject_data_into_analysis_folder( options )

if ~exist(options.workdir, 'dir')
    error('Working directory not found on this computer')
end

if ~exist(options.rawdir, 'dir')
    error('Raw data location not found on this computer')
end

studyParts = {'anta', 'agon'};

% source: where are the raw data currently
rawDataSource   = fullfile(options.rawdir);
srcPrefix       = 'TNU_DPRST_';
srcEegFolder    = 'eegdata';
srcMatFolder    = 'behavior';

% destination: where should I put them
rawDataDest     = fullfile(options.workdir);
destPrefix      = 'DPRST_';
destEegFolder   = 'eeg';
destMatFolder   = 'behav';

% loop over study parts and subjects
for partCell    = studyParts
    part        = char(partCell);

    for idCell  = options.(part).subjectIDs
        id      = char(idCell);
        
        % create subject directory
        subjDestDir = fullfile(rawDataDest, part, 'subjects', ...
            [destPrefix id]);
        if ~exist(subjDestDir, 'dir')
            mkdir(subjDestDir);
            mkdir(fullfile(subjDestDir, destEegFolder))
            mkdir(fullfile(subjDestDir, destMatFolder))
            mkdir(fullfile(subjDestDir, 'design'));
        end
        
        % copy over EEG data
        subjEegSource      = fullfile(rawDataSource, ...
            [srcPrefix id], srcEegFolder, [destPrefix id '*']);
        subjEegDestination = fullfile(subjDestDir, destEegFolder);
        copyfile(subjEegSource, subjEegDestination);
        
        % copy over behavioral data
        switch id
            case options.noBehav.subjectIDs
                % no behavioral data to copy for these subjects
            otherwise
                subjMatSource      = fullfile(rawDataSource, ...
                    [srcPrefix id], srcMatFolder, [destPrefix id '*.mat']);
                subjMatDestination = fullfile(subjDestDir, destMatFolder);
                copyfile(subjMatSource, subjMatDestination);
        end
        
        disp(['Copied raw EEG and mat data for subject ' id ' in study part ' part]);
    end
end