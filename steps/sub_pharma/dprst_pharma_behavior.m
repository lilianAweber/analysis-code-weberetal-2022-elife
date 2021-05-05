function [behavTablePla, behavTableDA, behavTableACh] = dprst_pharma_behavior( options )
%DPRST_PHARMA_BEHAVIOR Creates a table summarizing the number of errors,
%misses, and the average reaction time of all participants in the visual
%distraction task, per drug group.
%   IN:     optionally:
%           options         - the struct that contains all analysis options
%   OUT:    behavTable      - overview table size 3 x nSubjects

if nargin < 1
    options = dprst_set_analysis_options;
end

[~, paths] = dprst_subjects(options);

if ~exist(paths.pharmabehavfold, 'dir')
    mkdir(paths.pharmabehavfold);
end

% determine subject IDs for drug groups
groups = dprst_pharma_form_drug_groups_anonym(paths, options);

%% placebo group
iSub = 0;
subjectIdArray = setdiff(groups{1}.subjIDs, options.noBehav.subjectIDs);
% loop through subjects and get their stats
for idCell = subjectIdArray
    id = char(idCell);
    iSub = iSub +1;
    fprintf('\nWorking on subject %s...\n', id);

    details = dprst_subjects(id, options);
    bFile = dir(details.behavresults);
    behav = getfield(load(fullfile(details.behavroot, bFile.name)), 'behav');

    rt(iSub) = behav.rt;
    err(iSub) = behav.errors;
    miss(iSub) = behav.misses;
    hitRate(iSub) = behav.hitrate;
    errRate(iSub) = behav.errorrate;
        
    clear behav;
end

% table and plot
behavTablePla = table(rt', err', miss', hitRate', errRate', ...
                    'RowNames', subjectIdArray', ...
                    'VariableNames', ...
                    {'meanRTs', 'nErrors', 'nMisses', 'hitRate', 'errRate'});
clear rt err miss hitRate errRate;
save(fullfile(paths.pharmabehavfold, 'behavior_Pla.mat'), 'behavTablePla');

% plot
fh1 = dprst_plot_overview_behavior(behavTablePla, options);
savefig(fh1, fullfile(paths.pharmabehavfold, 'behavior_overview_Pla.fig'));


%% dopamine group
iSub = 0;
subjectIdArray = setdiff(groups{2}.subjIDs, options.(options.part).noBehavIDs);
% loop through subjects and get their stats
for idCell = subjectIdArray
    id = char(idCell);
    iSub = iSub +1;
    fprintf('\nWorking on subject %s...\n', id);

    details = dprst_subjects(id, options);
    bFile = dir(details.behavresults);
    behav = getfield(load(fullfile(details.behavroot, bFile.name)), 'behav');

    rt(iSub) = behav.rt;
    err(iSub) = behav.errors;
    miss(iSub) = behav.misses;
    hitRate(iSub) = behav.hitrate;
    errRate(iSub) = behav.errorrate;
        
    clear behav;
end

% table and plot
behavTableDA = table(rt', err', miss', hitRate', errRate', ...
                    'RowNames', subjectIdArray', ...
                    'VariableNames', ...
                    {'meanRTs', 'nErrors', 'nMisses', 'hitRate', 'errRate'});
clear rt err miss hitRate errRate;
save(fullfile(paths.pharmabehavfold, 'behavior_DA.mat'), 'behavTableDA');

% plot
fh3 = dprst_plot_overview_behavior(behavTableDA, options);
savefig(fh3, fullfile(paths.pharmabehavfold, 'behavior_overview_DA.fig'));

%% ACh group
iSub = 0;
subjectIdArray = setdiff(groups{3}.subjIDs, options.(options.part).noBehavIDs);
% loop through subjects and get their stats
for idCell = subjectIdArray
    id = char(idCell);
    iSub = iSub +1;
    fprintf('\nWorking on subject %s...\n', id);

    details = dprst_subjects(id, options);
    bFile = dir(details.behavresults);
    behav = getfield(load(fullfile(details.behavroot, bFile.name)), 'behav');

    rt(iSub) = behav.rt;
    err(iSub) = behav.errors;
    miss(iSub) = behav.misses;
    hitRate(iSub) = behav.hitrate;
    errRate(iSub) = behav.errorrate;
        
    clear behav;
end

% table and plot
behavTableACh = table(rt', err', miss', hitRate', errRate', ...
                    'RowNames', subjectIdArray', ...
                    'VariableNames', ...
                    {'meanRTs', 'nErrors', 'nMisses', 'hitRate', 'errRate'});
clear rt err miss hitRate errRate;
save(fullfile(paths.pharmabehavfold, 'behavior_ACh.mat'), 'behavTableACh');

% plot
fh5 = dprst_plot_overview_behavior(behavTableACh, options);
savefig(fh5, fullfile(paths.pharmabehavfold, 'behavior_overview_ACh.fig'));

%% plot them together: NotBoxPlot plots for RTs, hit rates
fh10 = dprst_plot_behavior_results_pharma(...
    behavTablePla, behavTableDA, behavTableACh, options);
savefig(fh10, fullfile(paths.pharmabehavfold, ...
    [options.part '_behavior_noBoxPlot_HR_RT.fig']));

%% Summary for report
results.nSubjects = numel(behavTablePla.meanRTs) + ...
    numel(behavTableDA.meanRTs) + numel(behavTableACh.meanRTs);
results.rts_mean = mean([behavTablePla.meanRTs; ...
    behavTableDA.meanRTs; behavTableACh.meanRTs]*1000);
results.rts_std = std([behavTablePla.meanRTs; ...
    behavTableDA.meanRTs; behavTableACh.meanRTs]*1000);
results.hit_mean = mean([behavTablePla.hitRate; ...
    behavTableDA.hitRate; behavTableACh.hitRate]);
results.hit_std = std([behavTablePla.hitRate; ...
    behavTableDA.hitRate; behavTableACh.hitRate]);
results.err_mean = mean([behavTablePla.errRate; ...
    behavTableDA.errRate; behavTableACh.errRate]);
results.err_std = std([behavTablePla.errRate; ...
    behavTableDA.errRate; behavTableACh.errRate]);

results.pla_nSubjects = numel(behavTablePla.meanRTs);
results.pla_rts_mean = mean(behavTablePla.meanRTs*1000);
results.pla_rts_std  = std(behavTablePla.meanRTs*1000);
results.pla_hit_mean = mean(behavTablePla.hitRate);
results.pla_hit_std  = std(behavTablePla.hitRate);
results.pla_err_mean = mean(behavTablePla.errRate);
results.pla_err_std  = std(behavTablePla.errRate);

results.da_nSubjects = numel(behavTableDA.meanRTs);
results.da_rts_mean = mean(behavTableDA.meanRTs*1000);
results.da_rts_std  = std(behavTableDA.meanRTs*1000);
results.da_hit_mean = mean(behavTableDA.hitRate);
results.da_hit_std  = std(behavTableDA.hitRate);
results.da_err_mean = mean(behavTableDA.errRate);
results.da_err_std  = std(behavTableDA.errRate);

results.ach_nSubjects = numel(behavTableACh.meanRTs);
results.ach_rts_mean = mean(behavTableACh.meanRTs*1000);
results.ach_rts_std  = std(behavTableACh.meanRTs*1000);
results.ach_hit_mean = mean(behavTableACh.hitRate);
results.ach_hit_std  = std(behavTableACh.hitRate);
results.ach_err_mean = mean(behavTableACh.errRate);
results.ach_err_std  = std(behavTableACh.errRate);

% Statistical tests
results.anova_group = [repmat({'Pla'}, 1, numel(behavTablePla.meanRTs)) ...
                       repmat({'DA'}, 1, numel(behavTableDA.meanRTs)) ...
                       repmat({'ACh'}, 1, numel(behavTableACh.meanRTs))];

% One-way ANOVA & Kruskal-Wallis: RTs
results.rts_anova_y = ...
    [behavTablePla.meanRTs' behavTableDA.meanRTs' behavTableACh.meanRTs'];
[results.rts_anova_p, results.rts_anova_tbl, results.rts_anova_stats] = ...
    anova1(results.rts_anova_y, results.anova_group);
[results.rts_kwallis_p, results.rts_kwallis_tbl, results.rts_kwallis_stats] = ...
    kruskalwallis(results.rts_anova_y, results.anova_group);

% One-way ANOVA & Kruskal-Wallis: hit rates
results.hit_anova_y = ...
    [behavTablePla.hitRate' behavTableDA.hitRate' behavTableACh.hitRate'];
[results.hit_kwallis_p, results.hit_kwallis_tbl, results.hit_kwallis_stats] = ...
    kruskalwallis(results.hit_anova_y, results.anova_group);

save(fullfile(paths.pharmabehavfold, 'results_behavior_pharma.mat'), 'results');

close all;

end