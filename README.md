This repository contains all analysis steps for producing the results presented in:

Weber LA, Tomiello S, Schöbi D, Wellstein KV, Müller D, Iglesias S, Stephan KE (2021).
Auditory mismatch responses are differentially sensitive to changes in muscarinic 
acetylcholine versus dopamine receptor function. _bioRxiv_, doi:10.1101/2021.03.18.435979
======================================================================================

|           |                                                |
| --------- | ---------------------------------------------- |
| Author:   | Lilian Weber, contact: weber@biomed.ee.ethz.ch |
| Created:  | May 2021                                       |
| License:  | GNU General Public License                     |

This software is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This software is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
See the GNU General Public License for more details: http://www.gnu.org/licenses/

## Summary
The repository is meant to provide all code utilized for data analysis. The raw data for this project are available 
at https://www.research-collection.ethz.ch/handle/20.500.11850/477685. All steps necessary to reproduce the results presented in the manuscript are called in the main script:
```
master_script_erp_paper
```
The repository contains all necessary functions, including copies of the toolboxes used (SPM, TNUEEG). The code was
developed using MATLAB 2018b and tested using MATLAB 2018a.

## Getting started
1. Download the raw data for this project from https://www.research-collection.ethz.ch/handle/20.500.11850/477685.
2. Clone this repository.
3. Modify the function `dprst_set_analysis_options` to point to where you have saved the raw data.
4. Run `master_script_erp_paper`. This will automatically set the MATLAB path as required, and perform all analyses.

### Setup: Data and Directories
The anonymized raw data should be contained in one folder with the following directory tree:
- `path-to-data/exp`: contains design information about the paradigm (the tone sequence)
- `path-to-data/pharma`: contains mat files with information on drug groups, drug plasma levels, and genetic data
- `path-to-data/TNU_DPRST_xxxx`: one folder per participant, contains EEG and behavioral data
							
The root directory leading to the raw data (`path-to-data`) should be indicated in the
Matlab function `dprst_set_analysis_options.m` as `options.rawdir` (see below).

The analysis folder will be created automatically by the function 
`dprst_setup_analysis_folder`. All data needed will be copied to the analysis folder
tree automatically and the raw data will not be touched by the code. 

### Setup: Code
Only one function needs to be modified for the code to run on your machine: `dprst_set_analysis_options.m`.
In there, `options.rawdir` should be an absolute path to where you have saved the raw data.
`options.workdir` should be an absolute path to where you want to run the analysis. This folder will be created
automatically in the step `dprst_setup_analysis_folder`.

You do not need to add the code to your path - simply run `dprst_setup_paths` (the first step in `master_script_erp_paper`) from the code directory. This will set the Matlab path as required, including the 
toolboxes that come with this repository. 

All data that is reported in the paper either as a figure or as a table is automatically collected in the end 
and added to a folder called `paperdata` in your `options.workdir`. 

### Mask effects (SPM's small volume correction, SVC)
For all SVC results reported in the manuscript, I followed the procedure for peak-level SVC described here:
https://www.jiscmail.ac.uk/cgi-bin/webadmin?A2=spm;af6b9130.1504. 

This involves the following steps:
1. Create a mask image that defines the small volume
2. Apply SVC once to the `p<0.05` FWE corrected results, using the mask image
3. Extract the resulting statistical threshold (_t_ value in our case) (`FWEp` value at the bottom of the results table in the GUI; or `xSVC.uc(1)` if scripting)
4. Use this as a new threshold for determining significant voxels (in the GUI, select `none` for p value adjustment and then enter this new threshold; when scripting, use the new threshold as `xSPM.u` with `xSPM.threshdesc = 'none'`).
5. Repeat the SVC with the mask image (GUI: `SVC` button; script: `spm_VOI.m` function).

For all mask effects that were part of the analysis (using the average effect of condition as a functional mask to examine differences between drug groups), the results will be generated and saved automatically. For the additional analyses with further restricted masks, the corresponding mask images have to be created manually (see sections "Interaction mismatch x drug" and "Interaction mismatch x stability x drug" in the Results section of the manuscript).

## Requirements
You need MATLAB to run this code. Everything else is included. The code was developed using **MATLAB R2018b** 
and tested using **MATLAB R2018a**.

## Third party code
- This repository contains a copy of SPM (**SPM12, r6906**, https://www.fil.ion.ucl.ac.uk/spm/software/). This is because the analysis code (in particular `tnueeg` functions) rely on SPM functions that changed with newer versions. 
- I have made some custom changes to SPM functions (mainly to allow other colormaps for the topoplots/scalpmaps). In particular: 
  - I added colormaps from `cmocean` (see below) to the function `spm_figure.m` (lines 913-931).
  - In the function `spm_ov_contour.m`, I changed the default color of contour lines to white (line 20). 
  - I replaced the function `spm_est_non_sphericity.m` v6827 with its updated version v6913 which includes a bug-fix provided by SPM
- The repository also contains the following (unchanged) freely available Matlab tools:
  - the function `cmocean` for colormaps created by Kristen Thyng (http://matplotlib.org/cmocean/), see also http://dx.doi.org/10.5670/oceanog.2016.66
  - the function `notBoxPlot` by Rob Campbell (https://github.com/raacampbell/notBoxPlot)

**Important** Different MATLAB versions will lead to small numerical differences in the results (e.g., number of voxels in a cluster). This has also been observed for running the code on different machines.


# Contributors / Roles
|                               |                                             |
| ----------------------------- | ------------------------------------------- |
| Project lead / analysis:      | Lilian Weber (PhD)                          |
| Supervising Prof.:            | Prof. Klaas Enno Stephan (MD Dr. med., PhD) |
| Abbreviation:                 | DPRST (study acronym)                       |
| Date:                         | May, 2021                                   |

The project was conducted at the Translational Neuromodeling Unit (TNU).

# Reference
Weber LA, Tomiello S, Schöbi D, Wellstein KV, Müller D, Iglesias S, Stephan KE (2021).
Auditory mismatch responses are differentially sensitive to changes in muscarinic 
acetylcholine versus dopamine receptor function. *bioRxiv*, doi:10.1101/2021.03.18.435979
