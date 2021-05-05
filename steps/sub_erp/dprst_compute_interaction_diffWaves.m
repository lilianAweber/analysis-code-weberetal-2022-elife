function ga = dprst_compute_interaction_diffWaves( ga, saveName )
%DPRST_COMPUTE_INTERACTION_DIFFWAVES Adds a difference waveform for
%mismatch during stable and volatile phases to the grand average struct for
%any ERP definition with phase distinction in the DPRST study.
%   IN:     ga      - the struct that holds subject ERPs and grand means
%                   for a specific sensor and ERP definition
%           saveName - file location and name of ga struct for saving
%                   interaction diffWaves (optional)

for iSub = 1: size(ga.stabSta.data, 1)
    ga.stableDiff.data(iSub, :) = ...
        ga.stabDev.data(iSub, :) - ga.stabSta.data(iSub, :);
end

ga.stableDiff.mean = mean(ga.stableDiff.data);
ga.stableDiff.sd = std(ga.stableDiff.data);
ga.stableDiff.error = std(ga.stableDiff.data)/sqrt(size(ga.stableDiff.data, 1));

for iSub = 1: size(ga.volaSta.data, 1)
    ga.volatileDiff.data(iSub, :) = ...
        ga.volaDev.data(iSub, :) - ga.volaSta.data(iSub, :);
end

ga.volatileDiff.mean = mean(ga.volatileDiff.data);
ga.volatileDiff.sd = std(ga.volatileDiff.data);
ga.volatileDiff.error = std(ga.volatileDiff.data)/sqrt(size(ga.volatileDiff.data, 1));

if nargin > 1
    save(saveName, 'ga');
end

end