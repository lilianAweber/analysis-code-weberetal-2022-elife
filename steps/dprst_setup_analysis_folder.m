function dprst_setup_analysis_folder(options)
%DPRST_SETUP_ANALYSIS_FOLDER Creates project directory tree and collects
%data for the DPRST MMN EEG analysis

if nargin < 1
    options = dprst_set_analysis_options;
end

%-- create folder tree ----------------------------------------------------------------------------%
if ~exist(options.workdir, 'dir')
    mkdir(options.workdir);
end

cd(options.workdir);
diary('analysis_setup.log');

for subfolder = {'anta', 'agon', 'config', 'design'}
    if ~exist(fullfile(options.workdir, char(subfolder)), 'dir')
        mkdir(fullfile(options.workdir, char(subfolder)));
    end
end

for subfolder = {'anta', 'agon'}
    if ~exist(fullfile(options.workdir, char(subfolder), 'subjects'), 'dir')
        mkdir((fullfile(options.workdir, char(subfolder), 'subjects')));
    end
end
disp(['Created analysis folder tree at ' options.workdir]);

%-- experimental paradigm info ----------------------------------------------------------------------------------%
dprst_copy_raw_experimental_data_into_analysis_folder(options);
disp('Copied experimental paradigm info file to analysis subfolder design');

%-- raw eeg data ----------------------------------------------------------------------------------%
dprst_copy_raw_subject_data_into_analysis_folder(options);
disp('Copied raw EEG data to analysis subfolder subjects');

%-- pharma xls sheets ----------------------------------------------------------------------------------%
dprst_copy_raw_pharma_data_into_analysis_folder(options);
disp('Copied pharma data to part-specific analysis subfolder pharma');

end

