function covariates = dprst_pharma_determine_covariates_anonym(groups, options)
%DPRST_PHARMA_DETERMINE_COVARIATES_ANONYM Loads the anonymized lists for
%drug plasma levels and gene labels and picks the values for the subject
%IDs (and in that order) that are currently selected in the drug groups.
%Returns a struct that holds all covariates (depending on general analysis
%options: either drug plasma levels, or gene labels, or both, or none).
%   IN:     groups      - output of dprst_pharma_form_drug_groups_anonym
%           options     - the struct that holds all analysis options
%   OUT:    covariates  - either a struct with fields = covariates or empty
%                       (if current options are no covariates) 

[~, paths] = dprst_subjects(options);

switch options.pharma.drugLevelCovariate
    case 1 % two separate covariates
        load(paths.pharmaLevels, 'plasmaLevelsDA', 'plasmaLevelsACh');
        [~, ~, subjIdxDA] = intersect(groups{2}.subjIDs, ...
                                    plasmaLevelsDA.PPID, 'stable');
        dlvl_DA = plasmaLevelsDA.drugMMN(subjIdxDA);

        [~, ~, subjIdxACh] = intersect(groups{3}.subjIDs, ...
                                    plasmaLevelsACh.PPID, 'stable');
        dlvl_ACh = plasmaLevelsACh.drugMMN(subjIdxACh);

        % apply mean-centering, if desirable
        if options.pharma.meanCenterDrugCovariateByHand
            dlvl_DA  = dlvl_DA  - mean(dlvl_DA);
            dlvl_ACh = dlvl_ACh - mean(dlvl_ACh);
        end

        covariates.drug_plasma_lvl_DA = ...
            [zeros(numel(groups{1}.subjIDs), 1); ...
            dlvl_DA; ...
            zeros(numel(groups{3}.subjIDs), 1)];
        covariates.drug_plasma_lvl_DA_mC = options.pharma.meanCenterDrugCovariate;

        covariates.drug_plasma_lvl_ACh = ...
            [zeros(numel(groups{1}.subjIDs), 1); ...
            zeros(numel(groups{2}.subjIDs), 1); ...
            dlvl_ACh];
        covariates.drug_plasma_lvl_ACh_mC = options.pharma.meanCenterDrugCovariate;
end

if options.pharma.genesAsCovariate == 1
    load(paths.geneLabels, 'geneTable');
    [~, ~, subjIdxPla] = intersect(groups{1}.subjIDs, ...
                                    geneTable.PPID, 'stable');
    [~, ~, subjIdxDA] = intersect(groups{2}.subjIDs, ...
                                    geneTable.PPID, 'stable');
    [~, ~, subjIdxACh] = intersect(groups{3}.subjIDs, ...
                                    geneTable.PPID, 'stable');
    gene = options.pharma.gene;
    covariate_All = [...
        geneTable.([gene '_level'])(subjIdxPla);
        geneTable.([gene '_level'])(subjIdxDA);
        geneTable.([gene '_level'])(subjIdxACh);
        ];

    covariates.([char(gene) '_All']) = covariate_All;
    covariates.([char(gene) '_All_int']) = options.pharma.covariateGeneInteraction;
    covariates.([char(gene) '_All_mC']) = options.pharma.meanCenterGeneCovariate;
end

if options.pharma.genesAsCovariate == 0 && options.pharma.drugLevelCovariate == 0
    covariates = [];
end

end
        