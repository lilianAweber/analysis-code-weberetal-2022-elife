function avgMask = dprst_create_average_effect_mask(contrastDir, effectName, options )
%DPRST_CREATE_AVERAGE_EFFECT_MASK

filePosEffect = fullfile(contrastDir, 'mask_spmT_0006.nii');
fileNegEffect = fullfile(contrastDir, 'mask_spmT_0007.nii');

outFileName = fullfile(contrastDir, ['mask_' effectName '_' options.stats.pValueMode '.nii']);
Vo = outFileName;

sigPosEffect = isfile(filePosEffect);
sigNegEffect = isfile(fileNegEffect);

if sigPosEffect && sigNegEffect
    Vi = {filePosEffect, fileNegEffect};
    avgMask  = spm_imcalc(Vi, Vo, 'i1 + i2');
elseif sigPosEffect
    Vi = {filePosEffect};
    avgMask  = spm_imcalc(Vi, Vo, 'i1');
elseif sigNegEffect
    Vi = {fileNegEffect};
    avgMask  = spm_imcalc(Vi, Vo, 'i1');
else
    warning('Cannot create mask: No significant positive or negative effects.')
    avgMask = '';
end

end