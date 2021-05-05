function ga = dprst_compute_mismatch_diffWaves( ga, saveName )
%DPRST_COMPUTE_MISMATCH_DIFFWAVES Adds a difference waveform for
%mismatch effects on ERPs to the grand average struct for
%any ERP definition with phase distinction in the DPRST study.
%   IN:     ga      - the struct that holds subject ERPs and grand means
%                   for a specific sensor and ERP definition
%           saveName - file location and name of ga struct for saving
%                   mismatch diffWaves (optional)

for iSub = 1: size(ga.standards.data, 1)
    ga.mismatch.data(iSub, :) = ...
        ga.deviants.data(iSub, :) - ga.standards.data(iSub, :);
end

ga.mismatch.mean = mean(ga.mismatch.data);
ga.mismatch.sd = std(ga.mismatch.data);
ga.mismatch.error = std(ga.mismatch.data)/sqrt(size(ga.mismatch.data, 1));

if nargin > 1
    save(saveName, 'ga');
end

end