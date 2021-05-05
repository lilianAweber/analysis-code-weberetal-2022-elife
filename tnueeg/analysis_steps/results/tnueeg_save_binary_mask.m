function V = tnueeg_save_binary_mask(xSPM, fileName)
%TNUEEG_SAVE_BINARY_MASK
%   IN:     xSPM        - 
%           fileName    - 
%   OUT:    V           - 
%
% xSPM      - structure containing SPM, distribution & filtering details
% .swd      - SPM working directory - directory containing current SPM.mat
% .title    - title for comparison (string)
% .Ic       - indices of contrasts (in SPM.xCon)
% .n        - conjunction number <= number of contrasts
% .Im       - indices of masking contrasts (in xCon)
% .pm       - p-value for masking (uncorrected)
% .Ex       - flag for exclusive or inclusive masking
% .u        - height threshold
% .k        - extent threshold {voxels}
% .thresDesc - description of height threshold (string)

%-- check input ----------------------------------------------------------%
if nargin < 1
    [~, xSPM] = spm_getSPM;
end
try 
    allVox = xSPM.XYZ;
catch
    [~, xSPM] = spm_getSPM(xSPM);
    allVox = xSPM.XYZ;
end
if nargin < 2
    fileName = spm_file(xSPM.Vspm(1).fname, 'suffix', 'mask_');
end

%-- gather infos ---------------------------------------------------------%
descrip = sprintf('SPM{%c}-filtered: u = %5.3f, k = %d', xSPM.STAT, xSPM.u, xSPM.k);

Z = ones(size(xSPM.Z));
                
%-- write to file --------------------------------------------------------%
V = spm_write_filtered(Z, xSPM.XYZ, xSPM.DIM, xSPM.M, descrip, fileName);
                    


end