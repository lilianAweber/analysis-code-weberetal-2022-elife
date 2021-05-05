function [] = dprst_report_spm_results_pharma_erpstats_with_genes(options, flag)
%DPRST_REPORT_SPM_RESULTS_PHARMA_ERPSTATS_WITH_GENES Creates contour
%overlays and scalpmaps for pharma and genetic effects of interest in the
%DPRST study.
%   IN:     options - the struct that holds all analysis options
%           flag    - string indicating the part ('anta', 'agon')
%   OUT:    --

% general analysis options
if nargin < 1
    options = dprst_set_analysis_options;
    flag = options.part;
end
if ischar(options)
    flag = options;
    options = dprst_set_analysis_options;
end
% sanity check
if ismember(flag, options.parts) && ~strcmp(flag, options.part)
    disp(['Changing options.part field to ' flag]);
    options.part = flag;
end

switch options.part
    case 'anta'
        da = 'Ami';
        ach = 'Bip';
    case 'agon'
        da = 'Lev';
        ach = 'Gal';
end

gene = options.pharma.gene;
switch gene
    case 'COMT'
        drug = da;
    case 'ChAt'
        drug = ach;
end

% paths and files
[~, paths] = dprst_subjects(options);

% record what we're doing
diary(paths.logfile);
tnueeg_display_analysis_step_header(['results report pharma ERPs: ' flag], 'dprst', ...
    'all', options.stats);

% loop over effects of interest
effectsOfInterest = {'mismatch', 'stability', ...
    'interaction', ...
    'stable_mismatch', 'volatile_mismatch'...
    };
effectIndices = [1:3 6 7]; % 4 and 5 look at stability effects within
% standards and deviants, not of interest for ERP paper

for iEff = 1: numel(effectsOfInterest)
    effectName = effectsOfInterest{iEff};
    iEffect = effectIndices(iEff);

    % scalpmap images of first contrast
    pngFiles = fullfile(paths.pharmastatserp, iEffect, ...
        'con1_scalpmaps', 'scalpmaps_*.png');

    contrasts{1}.title = ['positive effect of ' effectName];
    contrasts{1}.idx = 6;  
    contrasts{2}.title = ['negative effect of ' effectName];
    contrasts{2}.idx = 7;  
    contrasts{3}.title = [effectName ': Pla > ' da];
    contrasts{3}.idx = 9;  
    contrasts{4}.title = [effectName ': ' da ' > Pla'];
    contrasts{4}.idx = 10;  
    contrasts{5}.title = [effectName ': Pla > ' ach];
    contrasts{5}.idx = 11;  
    contrasts{6}.title = [effectName ': ' ach ' > Pla'];
    contrasts{6}.idx = 12;  
    contrasts{7}.title = [effectName ': ' da ' > ' ach];
    contrasts{7}.idx = 13;  
    contrasts{8}.title = [effectName ': ' ach ' > ' da];
    contrasts{8}.idx = 14;  
         
    contrasts{9}.title = [effectName ': ' gene ': Pla > ' drug];
    contrasts{9}.idx = 15;  
    contrasts{10}.title = [effectName ': ' gene ': ' drug ' > Pla'];
    contrasts{10}.idx = 16; 
    contrasts{11}.title = [effectName ': ' gene ' in Pla pos'];
    contrasts{11}.idx = 17; 
    contrasts{12}.title = [effectName ': ' gene ' in Pla neg'];
    contrasts{12}.idx = 18; 
    contrasts{13}.title = [effectName ': ' gene ' in ' drug ' pos'];
    contrasts{13}.idx = 19; 
    contrasts{14}.title = [effectName ': ' gene ' in ' drug ' neg'];
    contrasts{14}.idx = 20; 
    
    nVoxMin = 1;

    try
        % check for previous results report
        listDir = dir(pngFiles);
        list = {listDir(~[listDir.isdir]).name};
        if ~isempty(list)
            disp(['2nd level results for ERPs of ' options.erp.type ...
            ' for gene covariate ' options.pharma.gene ...
            ' type in part ' options.part ...
            ' have been reported before.']);
            if options.stats.overwrite
                disp('Overwriting...');
                error('Continue to results report step');
            else
                disp('Nothing is being done.');
            end
        else
            error('Cannot find previous report');
        end
    catch
        disp(['Reporting 2nd level results for ERPs in ' ...
            options.part ' part using the ' ...
            options.erp.type  ' definition for gene covariate ' ...
            options.pharma.gene]);

        % p value thresholding
        switch options.stats.pValueMode
            case 'clusterFWE'
                u = 0.001;
                thresDesc = 'none';
            case 'peakFWE'
                u = 0.05;
                thresDesc = 'FWE';
        end
        
        % go through all contrasts
        for iCon = 1: numel(contrasts)

            xSPM = struct;
            xSPM.swd      = fullfile(paths.pharmastatserp, num2str(iEffect));
            xSPM.title    = contrasts{iCon}.title;
            xSPM.Ic       = contrasts{iCon}.idx;
            xSPM.n        = 1;
            xSPM.Im       = [];
            xSPM.pm       = [];
            xSPM.Ex       = [];
            xSPM.u        = u;
            xSPM.k        = 0;
            xSPM.thresDesc = thresDesc;

            %-- save results table as csv ------------------------------------%
            xSPM = dprst_write_table_results(xSPM, iCon, ...
                options.stats.pValueMode, false, nVoxMin);
            % save xSPM for later convenience
            save(fullfile(xSPM.swd, ...
                ['xSPM_contrast' num2str(iCon) '_' xSPM.STAT '_' options.stats.pValueMode '.mat']), ...
                'xSPM');

            %-- significant clusters: info & plotting ------------------------%
            locs = xSPM.XYZ;
            % only continue if there are surviving voxels
            if ~isempty(locs)
                % extract all plotting-relevant contrast info 
                con = tnueeg_extract_contrast_results(xSPM, ...
                    [options.part ':'], nVoxMin);

                save(fullfile(con.swd, ...
                    ['con' num2str(iCon) '_' con.stat '_' options.stats.pValueMode '.mat']), ...
                    'con');

                % plot all contour overlays & scalpmaps
                cd(con.swd);
                contoursFolder = ['con' num2str(iCon) '_contours'];
                scalpmapsFolder = ['con' num2str(iCon) '_scalpmaps'];
                mkdir(contoursFolder);
                mkdir(scalpmapsFolder);

                % reduce blobs in xSPM to the significant ones
                sigIdx = [];
                for iSigClus = 1: con.nClusters.sig
                    [~, iA] = intersect(xSPM.XYZ', con.clusters(iSigClus).allvox', 'rows');
                    sigIdx = [sigIdx; iA];
                end
                xSPM.XYZ = xSPM.XYZ(:, sigIdx);
                xSPM.Z = xSPM.Z(sigIdx);
                
                cd(contoursFolder);
                tnueeg_overlay_contours_per_cluster(xSPM, con);

                % plot all scalpmaps 
                cd('..');
                cd(scalpmapsFolder);
                conf = dprst_configure_scalpmaps(con, options, xSPM.STAT, abs(max(xSPM.Z)));
                tnueeg_scalpmaps_per_cluster(con, conf);
            end        
        end
        
        %% MASKS %%
        % create a mask from the positive and negative average effect
        effectDir = fullfile(paths.pharmastatserp, num2str(iEffect));
        avgMask = dprst_create_average_effect_mask(effectDir, effectName, options);   
    end
    
end
cd(options.workdir);

diary OFF
end
