function [images, outroot] = tnueeg_convert2images(D, options)
%TNUEEG_CONVERT2IMAGES Converts an epoched EEG data set into a 3D image
%   IN:     D           - preprocessed data set 
%           options     - the struct that holds all analysis options
%   OUT:    images      - the 3D images, one per condition in the original
%                       data set D

switch options.conversion.space
    case 'sensor' % analysis in sensor space
        
        S.D = D;
        S.mode = 'scalp x time';
        if isfield(options.conversion, 'conditions')
            S.conditions = options.conversion.conditions;
        else
            S.conditions = cell(1, 0);
        end
        S.timewin = options.conversion.convTimeWindow;
        %S.freqwin = ;
        S.channels = 'EEG';
        S.prefix = [options.conversion.convPrefix '_'];


        [images, outroot] = spm_eeg_convert2images(S);
        
    
    case 'chansel' % analysis with only a selection of channels    
    % not implemented yet
    
    case 'source' % analysis in source space
    % not implemented yet
       
    case 'tfsource' % analysis in time-frequency source space
    % not implemented yet

end

end