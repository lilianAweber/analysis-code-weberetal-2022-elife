function ga = dprst_compute_stability_ERPs( ga, saveName )
%DPRST_COMPUTE_STABILITY_ERPS Adds an average waveform for stable and
%volatile phases to the grand average struct for any ERP definition with
%phase distinction in the DPRST study.
%   IN:     ga      - the struct that holds subject ERPs and grand means
%                   for a specific sensor and ERP definition
%           saveName - file location and name of ga struct for saving
%                   stability ERPs (optional)

for iSub = 1: size(ga.stabSta.data, 1)
    ga.stable.data(iSub, :) = ...
        mean([ga.stabSta.data(iSub, :); ga.stabDev.data(iSub, :)]);
end

ga.stable.mean = mean(ga.stable.data);
ga.stable.sd = std(ga.stable.data);
ga.stable.error = std(ga.stable.data)/sqrt(size(ga.stabSta.data, 1));

for iSub = 1: size(ga.volaSta.data, 1)
    ga.volatile.data(iSub, :) = ...
        mean([ga.volaSta.data(iSub, :); ga.volaDev.data(iSub, :)]);
end

ga.volatile.mean = mean(ga.volatile.data);
ga.volatile.sd = std(ga.volatile.data);
ga.volatile.error = std(ga.volatile.data)/sqrt(size(ga.volaSta.data, 1));

if nargin > 1
    save(saveName, 'ga');
end

end