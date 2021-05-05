function dprst_setup_paths
%DPRST_SETUP_PATHS Sets the Matlab path for the DPRST ERP analysis
%   Run this function from the working directory of the analysis (the
%   project folder). Paths will be added automatically based on the 
%   location of this file.
%   IN:     -
%   OUT:    -

% remove all other toolboxes 
restoredefaultpath; 

% add project path with all sub-paths 
pathProject = fileparts(mfilename('fullpath')); 
addpath(genpath(pathProject));

% remove SPM subfolder paths 
% NOTE: NEVER add SPM with subfolders to your path, since it creates 
% conflicts with Matlab core functions, e.g., uint16 
pathSpm = fileparts(which('spm')); 
% remove subfolders of SPM, since it is recommended, 
% and fieldtrip creates conflicts with Matlab functions otherwise 
rmpath(genpath(pathSpm)); 
addpath(pathSpm);

end
