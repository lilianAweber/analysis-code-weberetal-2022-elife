function ga = dprst_compute_mismatch_diffDiffWaves( ga, saveName )
%DPRST_COMPUTE_MISMATCH_DIFFDIFFWAVES Adds a difference waveform for
%ERPs to deviants versus standards to the grand average struct for
%any ERP definition with standards & deviants in the DPRST study.
%   IN:     ga      - the struct that holds subject ERPs and grand means
%                   for a specific sensor and ERP definition
%           saveName - file location and name of ga struct for saving
%                   mismatch diffWaves (optional)

for iSub = 1: size(ga.deviants.data, 1)
    ga.mismatchDiff.data(iSub, :) = ...
        ga.deviants.data(iSub, :) - ga.standards.data(iSub, :);
end

ga.mismatchDiff.mean = mean(ga.mismatchDiff.data);
ga.mismatchDiff.sd = std(ga.mismatchDiff.data);
ga.mismatchDiff.error = std(ga.mismatchDiff.data)/sqrt(size(ga.mismatchDiff.data, 1));

if nargin > 1
    save(saveName, 'ga');
end

end