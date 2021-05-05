function dprst_1stlevel_erp_roving_phases(id, options)
%DPRST_1STLEVEL_ERP_ROVING_PHASES Computes the first level contrast images 
%for ERP effects for the roving_phases design in the DPRST study.
%   IN:     options - the struct that holds all analysis options
%   OUT:    --

% general analysis options
if nargin < 1
    options = dprst_set_analysis_options;
end

% this function only works with these options, make sure they are set
if ~strcmp(options.erp.type, 'phases_roving') || ...
        ~strcmp(options.conversion.mode, 'ERP 1stlevel') || ...
        ~strcmp(options.stats.mode, 'ERP 1stlevel')
    error('Check erp, conversion, and stats options - not compatible with chosen function!')
end

% paths and files
[details, ~] = dprst_subjects(id, options);

imageString = '^smoothed_condition_';

% record what we're doing
diary(details.logfile);
tnueeg_display_analysis_step_header(...
    ['firstlevel erpstats ' options.erp.type], options.part, id, options.stats);

try
    % check for previous statistics
    load(details.erpspmfile);
    disp(['Group stats for ERPs in ' options.erp.type ...
        ' ERPs have been computed before.']);
    if options.stats.overwrite
        delete(paths.erpspmfile);
        disp('Overwriting...');
        error('Continue to group stats ERP step');
    else
        disp('Nothing is being done.');
    end
catch
    disp(['Computing group stats for ERPs in ' ...
        options.erp.type  ' design...']);
    
    % make sure we have a results directory
    facdir = details.erpstatsfold;
    if ~exist(facdir, 'dir')
        mkdir(facdir);
    end
    
    % specify the factors of interest
    factorNames             = {'Stability (stable, volatile)', ...
                               'Deviance (standard, deviant)'};
    factorLevels            = [2 2];
    factorDependence        = [0 0]; % both factors are within-subject, but because we're running a 1st level GLM, we treat them as independent
    factorVarianceUnequal   = [1 1]; % we allow for non-sphericity (as we would in an unpaired two-sample t-test)
    
    % smoothed images of averaged ERP data per condition in each subject serve as input to 2nd 
    % level statistics
    cellData(1).levels = [1; 1]; % Stable standards
    cellData(2).levels = [1; 2]; % Stable deviants
    cellData(3).levels = [2; 1]; % Volatile standards
    cellData(4).levels = [2; 2]; % Volatile deviants
    
    %-- data --------------------------------------------------------------------------------------%    
    % select all smoothed images per condition for this participant
    for iCell = 1: numel(cellData)
        cellData(iCell).scans = cellstr(spm_select('ExtFPListRec', details.convroot, ...
            [imageString options.erp.conditions{iCell} '*'], Inf));
    end
        
    %-- full factorial: factors Deviance and Stability --------------------------------------------%
    % use existing 2nd level stats function for this
    dprst_1stlevel_erp_roving_phases_fullfactorial(facdir, ...
        factorNames, factorLevels, factorDependence, factorVarianceUnequal, cellData)
    fprintf('\nComputed 1st-level stats for phases_roving ERPs for subject %s \n', id);
end
cd(options.workdir);

diary OFF
end



