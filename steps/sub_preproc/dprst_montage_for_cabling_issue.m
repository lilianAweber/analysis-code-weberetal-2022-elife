function montage = dprst_montage_for_cabling_issue(D, options)
%DPRST_MONTAGE_FOR_CABLING_ISSUE Creates the montage struct for rereferencing and defining EOG channels in the DPRST
%study.
%   IN:     options     - the struct that holds all analysis options
%   OUT:    montage     - the montage struct with labels and montage matrix

montage = struct;

% channel labels
montage.labelorg = chanlabels(D);
montage.labelorg(52) = [];
montage.labelorg{64} = 'EOG';
montage.labelorg(65:end) = [];
%{
{...
    'Fp1', 'Fp2', 'F3', 'F4', 'C3', 'C4', 'P3', 'P4', 'O1', 'O2', ...
    'F7', 'F8', 'T7', 'T8', 'P7', 'P8', 'Fz', 'Cz', 'Pz', 'FC1', ...
    'FC2', 'CP1', 'CP2', 'FC5', 'FC6', 'CP5', 'CP6', 'FT9', 'FT10', ...
    'TP9', 'TP10', 'F1', 'F2', 'C1', 'C2', 'P1', 'P2', 'AF3', ...
    'AF4', 'FC3', 'FC4', 'CP3', 'CP4', 'PO3', 'PO4', 'F5', 'F6', ...
    'C5', 'C6', 'P5', 'P6', 'AF7', 'AF8', 'FT7' ,'FT8', 'TP7', ...
    'TP8', 'PO7', 'PO8', 'FCz', 'CPz', 'POz', 'Oz', 'EOG'};
%}
montage.labelnew = {montage.labelorg{1:63}};

% rereferencing
tra = eye(63);
switch options.preproc.rereferencing
    case 'average'
        tra = detrend(tra, 'constant');
    case 'nose'
        % stick with recording reference (nose) - do nothing here.
end

% vertical EOG
montage.labelnew{64} = 'VEOG';
% Fp1 - EOG
tra(64, 64) = -1;
tra(64, 33) = 1;

% horizontal EOG
montage.labelnew{65} = 'HEOG';
% AF7 - AF8
tra(65, 21) = 1;
tra(65, 22) = -1;

montage.tra = tra;

end
