function [ chandef ] = dprst_channel_definition(D, details, options )
%DPRST_CHANNEL_DEFINTION Channel definition for DPRST MMN EEG data sets
%   IN:     D           - EEG data set with all channels
%           details     - the struct that holds all subject files & paths
%           options     - the struct that holds all analysis options
%   OUT:    chandef     - struct with as many fields as channel types

%chandef{1}.type = 'EEG'; % These are detected automatically by SPM
%chandef{1}.ind = [1:19 21:64];

chandef{1}.type = 'EOG';
chandef{1}.ind = 20;
    
switch options.part
    case 'anta'
        if nchannels(D) == 65
            chandef{2}.type = 'pulse';
            chandef{2}.ind = 65;
        end
    case 'agon'
        chandef{2}.type = 'ECG';
        chandef{2}.ind = 65;

        chandef{3}.type = 'pulse';
        chandef{3}.ind = 66;
end

save(details.channeldef, 'chandef');

end

