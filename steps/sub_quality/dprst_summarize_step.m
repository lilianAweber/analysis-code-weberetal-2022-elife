function dprst_summarize_step( stepStr, options )
%DPRST_SUMMARIZE_STEP Summarizes plots from all subjects for one processing step and saves this info
%in a pdf document.
%   IN:     stepStr - step identifier string, e.g. 'coregistration'
%           options - the struct that holds all analysis options
%   OUT:    -

[~, paths] = dprst_subjects(options);

qualityRoot = paths.qualityfold;
stepRoot    = fullfile(qualityRoot, stepStr);
if ~exist(qualityRoot, 'dir')
    mkdir(qualityRoot)
end
if ~exist(stepRoot, 'dir')
    mkdir(stepRoot)
end

for iSub = 1: numel(options.(options.part).subjectIDs)
    id = char(options.(options.part).subjectIDs{iSub});
    details = dprst_subjects(id, options);

    figureTitle = ['DPRST subject ' id];
    switch lower(stepStr)
        case {'ebdetect', 'ebdetection', 'eyeblinkdetection'}
            tnueeg_add_title_to_figure(details.ebdetectfig, figureTitle, stepRoot, 'png');
        case {'ebconf', 'ebconfounds', 'eyeblinkconfounds'}
            tnueeg_add_title_to_figure(details.ebspatialfig, figureTitle, stepRoot, 'png');
        case {'ebcorr', 'ebcorrection', 'eyeblinkcorrection'}
            tnueeg_add_title_to_figure(details.ebcorrectfig, figureTitle, stepRoot, 'png');        
        case {'ebreject', 'eboverlap', 'eyeblinkrejection', 'eyeblinkoverlap'}
            tnueeg_add_title_to_figure(details.eboverlapfig, figureTitle, stepRoot, 'png');        
        case {'coreg', 'coregistration'}
            tnueeg_add_title_to_figure(details.coregdatafig, figureTitle, stepRoot, 'png');
        case {'reg', 'regressors'}
            tnueeg_add_title_to_figure([details.regressorplots '_epsi2.fig'], figureTitle, ...
                stepRoot, 'png');
            tnueeg_add_title_to_figure([details.regressorplots '_epsi3.fig'], figureTitle, ...
                stepRoot, 'png');
        case {'mask', 'firstlevelmask'}
            tnueeg_add_title_to_figure(details.firstlevelmaskfig, figureTitle, stepRoot, 'png');
        case {'erp', 'erpfigures'}
            tnueeg_add_title_to_figure(details.erpfig, figureTitle, stepRoot, 'png');
    end
end

cd(stepRoot);
unix(['convert *.png group_check_' stepStr '.pdf']);

end