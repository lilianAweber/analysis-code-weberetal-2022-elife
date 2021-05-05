function [ con ] = tnueeg_extract_contrast_results( xSPM, titleStr, nVoxMin )
%TNUEEG_EXTRACT_CONTRAST_RESULTS Extracts all information on significant
%clusters that may be used in subsequent plotting: thresholding parameters,
%peak coordinates per cluster, p-values and extent of clusters, significant
%time window per cluster. 
%   IN:     xSPM        - the struct that contains the thresholded SPM, or
%                       the parameters needed for thresholding (see below)
%           titleStr    - a string that will form the title of the contrast,
%                       together with the contrast title saved in the xSPM.
%   OUT:    con         - a struct that contains all plotting-relevant
%                       information per cluster (e.g. peak coordinates and 
%                       significant time windows)
% If run without input arguments, the SPM and the thresholding parameters
% will be queried interactively. If the input xSPM has not been thresholded
% yet, the parameters indicated by xSPM will be used for thresholding
% (silent). Necessary fields for this are:
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
if ~nargin
    [~, xSPM] = spm_getSPM;
    titleStr = '';
    nVoxMin = 1;
end
if nargin == 1
    if ischar(xSPM)
        titleStr = xSPM;
        xSPM = [];
    else
        titleStr = '';
    end
    nVoxMin = 1;
end
if nargin < 3
    nVoxMin = 1;
end
try 
    allVox = xSPM.XYZ;
catch
    [~, xSPM] = spm_getSPM(xSPM);
    allVox = xSPM.XYZ;
end


%-- store results info for plotting --------------------------------------%
con.swd     = xSPM.swd;
con.name    = [titleStr ' ' xSPM.title];
con.stat    = xSPM.STAT;
con.statMax = nanmax(xSPM.Z);
con.conIdx  = xSPM.Ic;
if con.conIdx < 10
    con.imgFile = fullfile(con.swd, ...
        ['spm' con.stat '_000' num2str(con.conIdx) '.nii']);
else
    con.imgFile = fullfile(con.swd, ...
        ['spm' con.stat '_00' num2str(con.conIdx) '.nii']);
end

switch xSPM.thresDesc 
    case 'p<0.001 (unc.)'
        con.peak.correction     = 'None';
        con.peak.threshold      = 0.001;
        con.clust.correction    = 'FWE';
        con.clust.threshold     = 0.05;
    case 'p<0.05 (FWE)'
        con.peak.correction     = 'FWE';
        con.peak.threshold      = 0.05;
end
        

%-- collect results info from xSPM ---------------------------------------%
DIM     = xSPM.DIM > 1;
FWHM    = full(xSPM.FWHM);          % Full width at half max
FWHM    = FWHM(DIM);
V2R     = 1/prod(FWHM);             % voxels to resels
Resels  = full(xSPM.R);  
Resels  = Resels(1: find(Resels ~= 0, 1, 'last')); 
        
minz        = abs(min(min(xSPM.Z)));
statValue   = 1 + minz + xSPM.Z;
[numVoxels, statValue, XYZ, clustAssign, allVoxInClus]  = spm_max(statValue, allVox);
statValue   = statValue - minz - 1;

nClusters   = max(clustAssign);    
numResels   = numVoxels*V2R;
XYZmm       = xSPM.M(1:3, :) * [XYZ; ones(1, size(XYZ, 2))];

iClus = 0;
 while numel(find(isfinite(statValue)))
     % Find largest remaining local maximum
     [maxPeak, maxIdx]   = max(statValue);
     peakCoords          = XYZmm(:, maxIdx);
     clusterNumber       = clustAssign(maxIdx);
     clusterIndices      = find(clustAssign == clusterNumber);
    
     allClusterVoxels    = allVoxInClus{clusterNumber};
     allClusterVoxLocs   = xSPM.M(1:3, :) * [allClusterVoxels; ones(1, size(allClusterVoxels, 2))];
     allClusterTimes     = allClusterVoxLocs(3, :);
     clusterTimeWindow   = [min(allClusterTimes) max(allClusterTimes)];
     
     % Keep clusters based on their p-values
     if isfield(con, 'clust') 
         % Cluster-level FWE-correction
         [Pk, ~] = spm_P(1, numResels(maxIdx), ...
             xSPM.u,  xSPM.df, xSPM.STAT, Resels, xSPM.n, xSPM.S);         % cluster-level FWE p value

         % Exclude clusters with cluster-level FWE pvalue > 0.05
         if Pk < con.clust.threshold
             % Count another cluster
             iClus = iClus + 1;
     
             % Save all cluster info for plotting
             con.clusters(iClus).peak    = peakCoords;
             con.clusters(iClus).timewin = clusterTimeWindow;
             con.clusters(iClus).pvalue  = Pk;
             con.clusters(iClus).extent  = numVoxels(maxIdx);
             con.clusters(iClus).allvox  = allClusterVoxels;
             con.clusters(iClus).alllocs = allClusterVoxLocs;
         end
     else
         switch con.peak.correction
             case 'FWE'
                 % Peak-level FWE-correction
                 P = spm_P(1, 0, ...
                    maxPeak, xSPM.df, xSPM.STAT, Resels, xSPM.n, xSPM.S);  % FWE-corrected p value
             case 'None'
                 % Peak-level uncorrected
                 P = spm_P(1, 0, ...
                    maxPeak, xSPM.df, xSPM.STAT, 1,      xSPM.n, xSPM.S);  % uncorrected p value
         end
         
         % Exclude clusters with peak-level FWE pvalue >= 0.05, but less than nVoxMin voxels
         if numVoxels(maxIdx) >= nVoxMin
             % Count another cluster
             iClus = iClus + 1;

             % Save all cluster info relevant for plotting
             con.clusters(iClus).peak    = peakCoords;
             con.clusters(iClus).timewin = clusterTimeWindow;
             con.clusters(iClus).pvalue  = P;
             con.clusters(iClus).extent  = numVoxels(maxIdx);
             con.clusters(iClus).allvox  = allClusterVoxels;
             con.clusters(iClus).alllocs = allClusterVoxLocs;
         end
     end         

     % Remove voxels of this cluster from the list
     statValue(clusterIndices) = NaN; 
 end
 
 con.nClusters.all = nClusters;
 con.nClusters.sig = numel(con.clusters);
 
end

