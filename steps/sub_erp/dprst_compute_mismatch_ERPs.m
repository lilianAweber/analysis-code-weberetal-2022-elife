function ga = dprst_compute_mismatch_ERPs( ga, saveName )
%DPRST_COMPUTE_MISMATCH_ERPS Adds an average waveform for standards and
%deviants to the grand average struct for any ERP definition with
%phase distinction in the DPRST study.
%   IN:     ga      - the struct that holds subject ERPs and grand means
%                   for a specific sensor and ERP definition
%           saveName - file location and name of ga struct for saving
%                   mismatch ERPs (optional)

for iSub = 1: size(ga.stabSta.data, 1)
    ga.standards.data(iSub, :) = ...
        mean([ga.stabSta.data(iSub, :); ga.volaSta.data(iSub, :)]);
end

ga.standards.mean = mean(ga.standards.data);
ga.standards.sd = std(ga.standards.data);
ga.standards.error = std(ga.standards.data)/sqrt(size(ga.standards.data, 1));

for iSub = 1: size(ga.stabDev.data, 1)
    ga.deviants.data(iSub, :) = ...
        mean([ga.stabDev.data(iSub, :); ga.volaDev.data(iSub, :)]);
end

ga.deviants.mean = mean(ga.deviants.data);
ga.deviants.sd = std(ga.deviants.data);
ga.deviants.error = std(ga.deviants.data)/sqrt(size(ga.deviants.data, 1));

if nargin > 1
    save(saveName, 'ga');
end

end