function dprst_plot_scalpmaps_per_timepoint( timePoints, img, limits, options )
%DPRST_PLOT_VARIOUS_SCALPMAPS Plots scalpmaps of requested timepoints
%within a given contrast (or other image at con.imgFile)
%   IN:     timePoints  - vector of time points to plot
%           img         - struct with these fields:
%                           img.file (image file to plot on scalp)
%                           img.name (name of data, e.g. T values/muV)
%           limits      - vector with 2 values marking the z limits 
%           options     - the struct that holds all analysis options

if nargin < 3
    options = dprst_set_analysis_options;
end

% prepare SPM
spm('defaults', 'eeg');

% count maps to plot
nMaps = numel(timePoints);

% choose example D to use
id = options.stats.exampleID;
details = dprst_subjects(id, options);
configs.D = spm_eeg_load(details.prepfile);

% configure FT scalpmap plot
map = cmocean('balance',64);
%map(1:20, :) = [];
%map(end-19:end, :) = [];
close;
configs.cfg.colormap = map;
configs.cfg.colorbar = 'yes';

configs.cfg.marker = 'on'; % 'on', 'labels'
configs.cfg.markersymbol       = '.';
configs.cfg.markercolor        = [0 0 0];
configs.cfg.markersize         = 30;
configs.cfg.markerfontsize     = 12;
configs.cfg.comment            = 'xlim';

configs.cfg.zlim = limits;

% configure colorbars
configs.colmap.colmap = map;

configs.colmap.fontsize = 20;
configs.colmap.fontweight = 'bold';
configs.colmap.ticklength = 0.03;
configs.colmap.linewidth = 2;

configs.colmap.limits = configs.cfg.zlim;
if configs.cfg.zlim(1) == -3
    configs.colmap.ticks = [-3 -1.5 0 1.5 3];
else
    configs.colmap.ticks = [-5 -2.5 0 2.5 5];
end

configs.colmap.width = 0.06;
configs.colmap.filename = 'colormap_';
        
% collect image and configuration into S
S.image     = img.file;
S.D         = configs.D;
S.configs   = configs;
S.style = 'ft';

%-- save a plot per time point -------------------------------------------%
for iMap = 1: nMaps
    S.window = [timePoints(iMap) timePoints(iMap)];

    F = tnueeg_spm_eeg_img2maps(S);
    fileName = ['scalpmap' ...
            '_' img.name ...
            '_at_' num2str(timePoints(iMap)) 'ms'...
            '.png'];
    pause(2)
    print(F, fileName, '-dpng', '-r600');
    pause(2)
    close(F);
    
    % print corresponding colormap, if limits are given
    if ~ischar(configs.colmap.limits)
        configs.colmap.filename = ['colmap_' fileName];
        tnueeg_create_colorbar(configs.colmap);
    end
    
end

spm_figure('Close',F);


end