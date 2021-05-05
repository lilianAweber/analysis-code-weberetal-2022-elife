function loop_dprst_pharma( options, part )
%LOOP_DPRST_PHARMA Loops through conditions and preprocessing options and performs all
%2nd level statistics for pharma analysis:
%   IN:     options     - the struct that holds all analysis options
%           part        - string indicating study arm ('anta', 'agon')
%   OUT:    -

if nargin < 1
    options = dprst_set_analysis_options;
end

options.part = char(part);

[~, paths] = dprst_subjects(options);
if ~exist(paths.pharmaroot, 'dir')
    mkdir(paths.pharmaroot);
end

% behavior
dprst_pharma_behavior(options);

% classical group-level ERP analysis
options.erp.type = 'phases_roving';
dprst_pharma_erpanalysis(options);

% SPM group-level ERP analysis
% without gene covariate
options.pharma.genesAsCovariate = 0;
dprst_pharma_erpstats_roving_phases_from_1stlevel(options);

%-------- GLMs with gene SNP covariates ----------------------------------%
% we exclude the following participants from GLM analysis with
% genetics due to missing SNP data
missingCOMTdataIDs = {'0203', '0223', '0252'};
missingChAtdataIDs = {'0223', '0252'};

% with ChAt gene covariate
options.pharma.gene = 'ChAt';
options.pharma.genesAsCovariate = 1;
options.pharma.covariateGeneInteraction = 2;

options.agon.subjectIDs = ...
    setdiff(options.agon.subjectIDs, missingChAtdataIDs);
dprst_pharma_erpstats_roving_phases_from_1stlevel(options);

% with COMT gene covariate
options.pharma.gene = 'COMT';
options.pharma.genesAsCovariate = 1;
options.pharma.covariateGeneInteraction = 2; % allows for interaction

options.agon.subjectIDs = ...
    setdiff(options.agon.subjectIDs, missingCOMTdataIDs);
dprst_pharma_erpstats_roving_phases_from_1stlevel(options);

end
