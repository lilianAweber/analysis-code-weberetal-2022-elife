function ga = dprst_compute_stability_diffDiffWaves( ga, saveName )
%DPRST_COMPUTE_STABILITY_DIFFDIFFWAVES Adds a difference waveform for
%ERPs during stable versus volatile phases to the grand average struct for
%any ERP definition with phase distinction in the DPRST study.
%   IN:     ga      - the struct that holds subject ERPs and grand means
%                   for a specific sensor and ERP definition
%           saveName - file location and name of ga struct for saving
%                   stability diffWaves (optional)

for iSub = 1: size(ga.stable.data, 1)
    ga.stabilityDiff.data(iSub, :) = ...
        ga.stable.data(iSub, :) - ga.volatile.data(iSub, :);
end

ga.stabilityDiff.mean = mean(ga.stabilityDiff.data);
ga.stabilityDiff.sd = std(ga.stabilityDiff.data);
ga.stabilityDiff.error = std(ga.stabilityDiff.data)/sqrt(size(ga.stabilityDiff.data, 1));

if nargin > 1
    save(saveName, 'ga');
end

end