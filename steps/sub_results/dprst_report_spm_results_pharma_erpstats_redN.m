function [] = dprst_report_spm_results_pharma_erpstats_redN( options, flag )
%DPRST_REPORT_SPM_RESULTS_PHARMA_ERPSTATS_REDN Creates contour overlays and
%scalpmaps for pharma effects of interest in the DPRST study with reduced
%sample sizes.
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

% paths and files
[~, paths] = dprst_subjects(options);

% record what we're doing
diary(paths.logfile);
tnueeg_display_analysis_step_header(['results report pharma ERPs: ' flag], ...
    'dprst', 'redN', options.stats);

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
    pngFiles = fullfile(paths.pharmastatserpredn, num2str(iEffect), ...
        'con1_scalpmaps', 'scalpmaps_*.png');

    contrasts{1}.title = ['positive effect of ' effectName];
    contrasts{1}.idx = 6;  
    contrasts{2}.title = ['negative effect of ' effectName];
    contrasts{2}.idx = 7;  
    contrasts{3}.title = [effectName ': Pla > Ami'];
    contrasts{3}.idx = 9;  
    contrasts{4}.title = [effectName ': Ami > Pla'];
    contrasts{4}.idx = 10;  
    contrasts{5}.title = [effectName ': Pla > Bip'];
    contrasts{5}.idx = 11;  
    contrasts{6}.title = [effectName ': Bip > Pla'];
    contrasts{6}.idx = 12;  
    contrasts{7}.title = [effectName ': Ami > Bip'];
    contrasts{7}.idx = 13;  
    contrasts{8}.title = [effectName ': Bip > Ami'];
    contrasts{8}.idx = 14;  
    
    nVoxMin = 1;

    try
        % check for previous results report
        listDir = dir(pngFiles);
        list = {listDir(~[listDir.isdir]).name};
        if ~isempty(list)
            disp(['2nd level results for ERPs of ' options.erp.type ...
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
            options.erp.type  ' definition...']);

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
            xSPM.swd      = fullfile(paths.pharmastatserpredn, num2str(iEffect));
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
                ['xSPM_contrast' num2str(iCon) '_' xSPM.STAT ...
                '_' options.stats.pValueMode '.mat']), ...
                'xSPM');
            
            % ALL VISUALS ARE NOT NEEDED FOR THE PAPER/SUPP, ONLY THE
            % TABLES
            %{
            %-- significant clusters: info & plotting ------------------------%
            locs = xSPM.XYZ;
            % only continue if there are surviving voxels
            if ~isempty(locs)
                % extract all plotting-relevant contrast info 
                con = tnueeg_extract_contrast_results(xSPM, ...
                    [options.part ':'], nVoxMin);

                save(fullfile(con.swd, ...
                    ['con' num2str(iCon) '_' con.stat ...
                    '_' options.stats.pValueMode '.mat']), ...
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
                    [~, iA] = intersect(xSPM.XYZ', ...
                        con.clusters(iSigClus).allvox', 'rows');
                    sigIdx = [sigIdx; iA];
                end
                xSPM.XYZ = xSPM.XYZ(:, sigIdx);
                xSPM.Z = xSPM.Z(sigIdx);
                
                cd(contoursFolder);
                tnueeg_overlay_contours_per_cluster(xSPM, con);

                % plot all scalpmaps 
                cd('..');
                cd(scalpmapsFolder);
                conf = dprst_configure_scalpmaps(con, options, ...
                    xSPM.STAT, abs(max(xSPM.Z)));
                tnueeg_scalpmaps_per_cluster(con, conf);
            end        
            %}
        end
        %{
        %% MASKS %%
        % create a mask from the positive and negative average effect
        effectDir = fullfile(paths.pharmastatserpredn, num2str(iEffect));
        avgMask = dprst_create_average_effect_mask(effectDir, ...
            effectName, options);   
        %}
    end
    
end
cd(options.workdir);

diary OFF
end
