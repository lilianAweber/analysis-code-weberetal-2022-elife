function dprst_pharma_erpstats_roving_phases_from_1stlevel( options )
%DPRST_PHARMA_ERPSTATS_ROVING_PHASES_FROM_1STLEVEL Computes the second 
%level contrast images for ERP effects for the roving_phases design in the 
%DPRST study.
%   IN:     options - the struct that holds all analysis options
%   OUT:    --

% general analysis options
if nargin < 1
    options = dprst_set_analysis_options;
end

options.erp.type = 'phases_roving';
options.conversion.mode = 'ERP 1stlevel';
options.stats.mode = 'ERP 1stlevel';
options.erp.conditions = {'stabSta', 'stabDev', 'volaSta', 'volaDev'};

contrastsOfInterest = {...
    'standards > deviants', ... mismatch
    'stable > volatile', ... stability
    'stable sta>dev > volatile sta>dev', ... interaction
    'stable standards > volatile standards', ... standards only
    'stable deviants > volatile deviants', ... deviants only
    'stable sta>dev', ... stable mismatch
    'volatile sta>dev', ... volatile mismatch
    };

imageString = '/con_';

% paths and files
[~, paths] = dprst_subjects(options);

% determine subject IDs for drug groups
groups = dprst_pharma_form_drug_groups_anonym(paths, options);
covariates = dprst_pharma_determine_covariates_anonym(groups, options);

% record what we're doing
diary(paths.logfile);
tnueeg_display_analysis_step_header(...
    ['pharma erpstats ' options.erp.type], options.part, 'all', ...
    options.stats);

disp(['Computing group stats for drug effects on ERPs in ' ...
    options.erp.type  ' design...']);

spm('defaults', 'EEG');
spm_jobman('initcfg');

% loop through all contrasts of interest from 1st level analysis
for iContrast = 1: numel(contrastsOfInterest)
    facdir = fullfile(paths.pharmastatserp, num2str(iContrast));
    if ~exist(facdir, 'dir')
        mkdir(facdir);
    end

    % con images from 1stlevel stats in each subject
    % serve as input to 2nd level statistics
    for iGroup = 1: numel(groups)
        subjList = groups{iGroup}.subjIDs;
        nSubjects = numel(subjList);
        groups{iGroup}.scans = cell(nSubjects, 1);
        for iSub = 1: nSubjects
            subID = char(subjList{iSub});
            details = dprst_subjects(subID, options);

            if iContrast > 9
                groups{iGroup}.scans{iSub, 1} = [details.erpstatsfold ...
                    imageString '00' num2str(iContrast) '.nii,1'];
            else
                groups{iGroup}.scans{iSub, 1} = [details.erpstatsfold ...
                    imageString '000' num2str(iContrast) '.nii,1'];
            end
        end
    end

    % compute statistics (factorial design, 1 factor: drug)
switch options.pharma.genesAsCovariate
    case 0
        job = dprst_pharma_getjob_factorial_design_1factor(facdir, ...
            groups, covariates, contrastsOfInterest{iContrast});
    case 1
        job = dprst_pharma_getjob_factorial_design_1factor_covGene(facdir, ...
            groups, covariates, contrastsOfInterest{iContrast});
end
    design = dprst_export_design(job);
    spm_jobman('run', job);
    save([char(job{1}.spm.stats.factorial_design.dir), '/design.mat'], ...
        'design');    
end

disp('Computed pharma group statistics for ERPs in phases_roving design...');
cd(options.workdir);

diary OFF
end

function [design] = dprst_export_design(matlabbatch)

group = [];
scans = [];

batch = matlabbatch{1}.spm.stats.factorial_design;
for i = 1 : size(batch.des.fd.icell, 2)
    group = [group; i * ones(numel(batch.des.fd.icell(i).scans), 1)];
    scans = [scans; batch.des.fd.icell(i).scans];
end

if ~isempty(batch.cov)
    druglvl_DA = batch.cov(1).c;
    druglvl_ACh = batch.cov(2).c;

    design.mat = cell(size(druglvl_DA, 1), 4);
    design.mat(:, 1) = sprintfc('%d', group);
    design.mat(:, 2) = scans;
    design.mat(:, 3) = sprintfc('%0.3f', druglvl_DA);
    design.mat(:, 4) = sprintfc('%0.3f', druglvl_ACh);

    design.drug_plasma_lvl_DA = druglvl_DA;
    design.drug_plasma_lvl_ACh = druglvl_ACh;
end

design.group = group;
design.scans = scans;

end