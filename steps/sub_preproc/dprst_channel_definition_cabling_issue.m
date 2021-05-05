function [ chandef ] = dprst_channel_definition_cabling_issue(D, details, options )
%DPRST_CHANNEL_DEFINTION_CABLING_ISSUE Channel definition for two DPRST MMN
%EEG data sets with wrong cabling during measurement
%   IN:     D           - EEG data set with all channels
%           details     - the struct that holds all subject files & paths
%           options     - the struct that holds all analysis options
%   OUT:    chandef     - struct with as many fields as channel types

% first, overwrite default EOG channel
chandef{1}.type = 'EEG';
chandef{1}.ind = 20;

% specify correct EOG channel
chandef{2}.type = 'EOG';
chandef{2}.ind = 52;
    
% the rest is equivalent to the other participants
switch options.part
    case 'anta'
        if nchannels(D) == 65
            chandef{3}.type = 'pulse';
            chandef{3}.ind = 65;
        end
    case 'agon'
        chandef{3}.type = 'ECG';
        chandef{3}.ind = 65;

        chandef{4}.type = 'pulse';
        chandef{4}.ind = 66;
end

save(details.channeldef, 'chandef');

end

