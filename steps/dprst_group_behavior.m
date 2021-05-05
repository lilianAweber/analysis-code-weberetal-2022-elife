function behavTable = dprst_group_behavior( options )
%DPRST_GROUP_BEHAVIOR Creates a table summarizing the number of errors,
%misses, and the average reaction time of all participants in the visual
%distraction task.
%   IN:     optionally:
%           options         - the struct that contains all analysis options
%   OUT:    behavTable      - overview table size 3 x nSubjects

if nargin < 1
    options = dprst_set_analysis_options;
end

[~, paths] = dprst_subjects(options);

if ~exist(paths.behavroot, 'dir')
    mkdir(paths.behavroot);
end

iSub = 0;
subjectIdArray = setdiff(options.(options.part).subjectIDs, options.(options.part).noBehavIDs);
% loop through subjects and get their stats
for idCell = subjectIdArray
    id = char(idCell);
    iSub = iSub +1;
    fprintf('\nWorking on subject %s...\n', id);

    details = dprst_subjects( id, options );
    load(fullfile(details.behavresults), 'behav');

    rt(iSub) = behav.rt;
    err(iSub) = behav.errors;
    miss(iSub) = behav.misses;
    hitRate(iSub) = behav.hitrate;
    errRate(iSub) = behav.errorrate;
        
    clear behav;
end

% table and plot
behavTable = table(rt', ...
                        err', ...
                        miss', ...
                        hitRate', ...
                        errRate', ...
                        'RowNames', subjectIdArray', ...
                        'VariableNames', {'meanRTs', ...
                        'nErrors', ...
                        'nMisses', ...
                        'hitRate', ...
                        'errRate'});
fh = dprst_plot_overview_behavior(behavTable, options);

% summary for report
results.nSubjects = numel(behavTable.meanRTs);

idxExclSubj = find(behavTable.hitRate < 0.75);
results.exSubjects = behavTable.Properties.RowNames(idxExclSubj);

results.rt_mean = mean(behavTable.meanRTs*1000);
results.rt_range = [min(behavTable.meanRTs*1000) max(behavTable.meanRTs*1000)];
results.rt_std = std(behavTable.meanRTs*1000);

results.hit_mean = mean(behavTable.hitRate*100);
results.hit_range = [min(behavTable.hitRate*100) max(behavTable.hitRate*100)];
results.hit_std = std(behavTable.hitRate*100);

results.err_mean = mean(behavTable.errRate*100);
results.err_range = [min(behavTable.errRate*100) max(behavTable.errRate*100)];
results.err_std = std(behavTable.errRate*100);

% save results
save(paths.behavtab, 'behavTable');
saveas(fh, paths.behavfig, 'fig');
saveas(fh, paths.behavfig, 'png');

save(paths.behavresults, 'results');
end
