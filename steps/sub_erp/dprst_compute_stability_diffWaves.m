function ga = dprst_compute_stability_diffWaves( ga, saveName )
%DPRST_COMPUTE_STABILITY_DIFFWAVES Adds a difference waveform for
%stability effects on ERPs to the grand average struct for
%any ERP definition with phase distinction in the DPRST study.
%   IN:     ga      - the struct that holds subject ERPs and grand means
%                   for a specific sensor and ERP definition
%           saveName - file location and name of ga struct for saving
%                   stability diffWaves (optional)

for iSub = 1: size(ga.stable.data, 1)
    ga.stability.data(iSub, :) = ...
        ga.stable.data(iSub, :) - ga.volatile.data(iSub, :);
end

ga.stability.mean = mean(ga.stability.data);
ga.stability.sd = std(ga.stability.data);
ga.stability.error = std(ga.stability.data)/sqrt(size(ga.stability.data, 1));

if nargin > 1
    save(saveName, 'ga');
end

end