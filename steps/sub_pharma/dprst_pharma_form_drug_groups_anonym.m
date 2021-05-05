function groups = dprst_pharma_form_drug_groups_anonym( paths, options )
%DPRST_PHARMA_FORM_DRUG_GROUPS_ANONYM Sorts participants into drug groups
%based on .mat file using anonymous subject IDs. Only returns those subject
%IDs that are part of current analysis group, as indicated by 
%options.{anta, agon}.subjectIDs.
%   IN:     paths       - the struct that holds all general paths and files
%           options     - the struct that holds all analysis options
%   OUT:    groups      - cell array with 3 entries, each entry holds a 
%                       label with the drug's name and a list of subject
%                       IDs

groupLabels = {'subjPla', 'subjDA', 'subjACh'};

for iGroup = 1: 3
    % load this group's subject list and drug label
    groups{iGroup} = ...
        getfield(load(paths.drugLabels), char(groupLabels{iGroup}));
    % only retain those subject IDs that are currently included
    groups{iGroup}.subjIDs = ...
        intersect(groups{iGroup}.subjIDs, ...
        options.(options.part).subjectIDs);
end


fprintf(['\n\nAssigned %s PPIDs to Placebo group,\n', ...
    '         %s PPIDs to Dopamine group,\n', ...
    '     and %s PPIDs to Acetylcholine group.\n\n'], ...
    num2str(numel(groups{1}.subjIDs)), ...
    num2str(numel(groups{2}.subjIDs)), ...
    num2str(numel(groups{3}.subjIDs)));

end