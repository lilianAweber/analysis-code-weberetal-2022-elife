function [ condlist ] = dprst_trial_definition_erp( paths, options )
%DPRST_TRIAL_DEFINTION_ERP Trial definition for DPRST MMN EEG data sets - used for averaging
%   IN:     options     - the struct that holds all analysis options
%           paths       - the struct that holds all general paths and filenames
%   OUT:    condlist    - cell array with string condition labels for each trial

paradigm = getfield(load(paths.paradigm), 'bin');

switch options.erp.type
    case {'lowhighEpsi2', 'lowhighEpsi3'}
        paradigm.percentPE = options.erp.percentPE;
end

if ~isfield(paradigm, 'conditions') || ~isfield(paradigm.conditions, options.erp.type)
    condlist = feval(['dprst_' options.erp.type '_conditions'], paradigm);
    paradigm.conditions.(options.erp.type) = condlist;
    bin = paradigm;
    save(paths.paradigm, 'bin');
else
    condlist = paradigm.conditions.(options.erp.type);
end

end

