function dprst_copy_raw_experimental_data_into_analysis_folder( options )
%DPRST_COPY_RAW_EXPERIMENTAL_DATA_INTO_ANALYSIS_FOLDER

% collect source files
expDataSource1   = fullfile(options.rawdir, 'exp', 'paradigm_bopars.mat');
expDataSource2   = fullfile(options.rawdir, 'exp', 'sequence.mat');
expDataSource3   = fullfile(options.rawdir, 'exp', 'probability_structure_phases.fig');
expDataSource4   = fullfile(options.rawdir, 'exp', 'probability_structure_phases.png');

% copy to destination folder
expDataDest     = fullfile(options.workdir, 'design');
copyfile(expDataSource1, expDataDest);
copyfile(expDataSource2, expDataDest);
copyfile(expDataSource3, expDataDest);
copyfile(expDataSource4, expDataDest);

end