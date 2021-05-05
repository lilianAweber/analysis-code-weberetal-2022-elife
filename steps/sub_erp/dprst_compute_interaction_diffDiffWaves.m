function ga = dprst_compute_interaction_diffDiffWaves( ga, saveName )
%DPRST_COMPUTE_INTERACTION_DIFFDIFFWAVES Adds a difference waveform for
%mismatch during stable versus volatile phases to the grand average struct for
%any ERP definition with phase distinction in the DPRST study.
%   IN:     ga      - the struct that holds subject ERPs and grand means
%                   for a specific sensor and ERP definition
%           saveName - file location and name of ga struct for saving
%                   interaction diffWaves (optional)

for iSub = 1: size(ga.stabSta.data, 1)
    ga.interactDiff.data(iSub, :) = ...
        ga.volatileDiff.data(iSub, :) - ga.stableDiff.data(iSub, :);
end

ga.interactDiff.mean = mean(ga.interactDiff.data);
ga.interactDiff.sd = std(ga.interactDiff.data);
ga.interactDiff.error = std(ga.interactDiff.data)/sqrt(size(ga.interactDiff.data, 1));

if nargin > 1
    save(saveName, 'ga');
end

end