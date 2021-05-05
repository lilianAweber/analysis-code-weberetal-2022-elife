function behav = dprst_analyze_behavior( id, options )
%DPRST_ANALYZE_BEHAVIOR Analyzes reaction times, errors and misses in the 
%visual distraction task for one subject of the DPRST study
%   IN:     id  - subject identifier string, e.g. '0001'
%   OUT:    --

if nargin < 2
    options = dprst_set_analysis_options;
end

fprintf('\n\n --------- Working on: %s ---------\n\n', id);

details = dprst_subjects(id, options);

% record what we're doing
diary(details.logfile);
tnueeg_display_analysis_step_header('behavior', 'dprst', id, options.behav);

if ismember(id, options.(options.part).noBehavIDs)
    fprintf('No behavioral data available for subject %s. Aborting...\n\n', id);
    behav = [];
    diary OFF
    return
end

try
    % check for previous analysis
    behav = getfield(load(details.behavresults), 'behav');
    disp(['Behavior of subject ' id ' has been analyzed before.']);
    if options.behav.overwrite
        clear behav;
        disp('Overwriting...');
        error('Continue to analysis script');
    else
        disp('Nothing is being done.');
    end
catch
    disp(['Analyzing behavior for subject ' id ' ...']);

    % load raw behavioral data
    load(fullfile(details.behavfile), 'MMN');

    % analyze performance
    if ismember(id, options.anta.pilotIDs)
        behav = dprst_calculate_performance_pilots(MMN, ...
            details.responseButtons, options.behav);
    else
        behav = dprst_calculate_performance(MMN, ...
            details.responseButtons, options.behav);
    end
    behav.id = id;
        
    fprintf(['\nSubject %s had a mean reaction time of %3.0f ms,\n' ...
        'missed %d square openings (hit rate of %3.1f %%),\n' ...
        'and responded incorrectly %d times.\n\n'], ...
        behav.id, behav.rt*1000, ...
        behav.misses, behav.hitrate*100, behav.errors);

    % save results
    save(details.behavresults, 'behav');
end
cd(options.workdir);
close all

diary OFF
end