function [ job ] = dprst_pharma_getjob_factorial_design_1factor(facdir, groups, cov, effectName)

%---------- Specify the matlab batch ------------
job{1}.spm.stats.factorial_design.dir = {facdir};

job{1}.spm.stats.factorial_design.des.fd.fact.name = 'pharmacological_intervention';
job{1}.spm.stats.factorial_design.des.fd.fact.levels = 3;
job{1}.spm.stats.factorial_design.des.fd.fact.dept = 0;
job{1}.spm.stats.factorial_design.des.fd.fact.variance = 1;
job{1}.spm.stats.factorial_design.des.fd.fact.gmsca = 0;
job{1}.spm.stats.factorial_design.des.fd.fact.ancova = 0;

job{1}.spm.stats.factorial_design.des.fd.icell(1).levels = 1;
job{1}.spm.stats.factorial_design.des.fd.icell(1).scans = groups{1}.scans;
job{1}.spm.stats.factorial_design.des.fd.icell(2).levels = 2;
job{1}.spm.stats.factorial_design.des.fd.icell(2).scans = groups{2}.scans;
job{1}.spm.stats.factorial_design.des.fd.icell(3).levels = 3;
job{1}.spm.stats.factorial_design.des.fd.icell(3).scans = groups{3}.scans;

job{1}.spm.stats.factorial_design.des.fd.contrasts = 1;
%{
job{1}.spm.stats.factorial_design.cov(1).c = KSS;
job{1}.spm.stats.factorial_design.cov(1).cname = 'KSS';
job{1}.spm.stats.factorial_design.cov(1).iCFI = 1;
job{1}.spm.stats.factorial_design.cov(1).iCC = 1;

job{1}.spm.stats.factorial_design.cov(2).c = ESS;
job{1}.spm.stats.factorial_design.cov(2).cname = 'ESS';
job{1}.spm.stats.factorial_design.cov(2).iCFI = 1;
job{1}.spm.stats.factorial_design.cov(2).iCC = 1;
%}
if ~isempty(cov)
    if isfield(cov, 'drug_plasma_lvl_DA')
        job{1}.spm.stats.factorial_design.cov(1).c = cov.drug_plasma_lvl_DA;
        job{1}.spm.stats.factorial_design.cov(1).cname = 'drug_plasma_lvl_DA';
        job{1}.spm.stats.factorial_design.cov(1).iCFI = 1;
        job{1}.spm.stats.factorial_design.cov(1).iCC = cov.drug_plasma_lvl_DA_mC;

        job{1}.spm.stats.factorial_design.cov(2).c = cov.drug_plasma_lvl_ACh;
        job{1}.spm.stats.factorial_design.cov(2).cname = 'drug_plasma_lvl_ACh';
        job{1}.spm.stats.factorial_design.cov(2).iCFI = 1;
        job{1}.spm.stats.factorial_design.cov(2).iCC = cov.drug_plasma_lvl_ACh_mC;
    elseif isfield(cov, 'drug_plasma_lvl')
        job{1}.spm.stats.factorial_design.cov(1).c = cov.drug_plasma_lvl;
        job{1}.spm.stats.factorial_design.cov(1).cname = 'drug_plasma_lvl';
        job{1}.spm.stats.factorial_design.cov(1).iCFI = 2;
        job{1}.spm.stats.factorial_design.cov(1).iCC = cov.drug_plasma_lvl_mC;
    end
else
    job{1}.spm.stats.factorial_design.cov = ...
    struct('c', {}, ...
            'cname', {}, ...
            'iCFI', {}, ...
            'iCC', {});
end
job{1}.spm.stats.factorial_design.multi_cov = ...
    struct('files', {}, ...
            'iCFI', {}, ...
            'iCC', {});
job{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
job{1}.spm.stats.factorial_design.masking.im = 1;
job{1}.spm.stats.factorial_design.masking.em = {''};
job{1}.spm.stats.factorial_design.globalc.g_omit = 1;
job{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
job{1}.spm.stats.factorial_design.globalm.glonorm = 1;

job{2}.spm.stats.fmri_est.spmmat(1) = ...
    cfg_dep('Factorial design specification: SPM.mat File', ...
    substruct('.','val', '{}',{1}, ...
    '.','val', '{}',{1}, ...
    '.','val', '{}',{1}), ...
    substruct('.','spmmat'));
job{2}.spm.stats.fmri_est.write_residuals = 0;
job{2}.spm.stats.fmri_est.method.Classical = 1;

job{3}.spm.stats.con.spmmat(1) = ...
    cfg_dep('Model estimation: SPM.mat File', ...
    substruct('.','val', '{}',{2}, ...
    '.','val', '{}',{1}, ...
    '.','val', '{}',{1}), ...
    substruct('.','spmmat'));
job{3}.spm.stats.con.consess{1}.tcon.name = [effectName '_pos'];
job{3}.spm.stats.con.consess{1}.tcon.weights = [1 1 1];
job{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
job{3}.spm.stats.con.consess{2}.tcon.name = [effectName '_neg'];
job{3}.spm.stats.con.consess{2}.tcon.weights = [-1 -1 -1];
job{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
job{3}.spm.stats.con.consess{3}.fcon.name = effectName;
if ~isempty(cov)
    if isfield(cov, 'drug_plasma_lvl_DA')
        job{3}.spm.stats.con.consess{3}.fcon.weights = ...
           [1 0 0 0 0
            0 1 0 0 0
            0 0 1 0 0];
    elseif isfield(cov, 'drug_plasma_lvl')
        job{3}.spm.stats.con.consess{3}.fcon.weights = ...
           [1 0 0 0
            0 1 0 0
            0 0 1 0];
    end
else
    job{3}.spm.stats.con.consess{3}.fcon.weights = ...
       [1 0 0
        0 1 0
        0 0 1];
end    
job{3}.spm.stats.con.consess{3}.fcon.sessrep = 'none';
job{3}.spm.stats.con.consess{4}.tcon.name = ...
    [effectName '_' groups{1}.label ' > ' effectName '_' groups{2}.label];
job{3}.spm.stats.con.consess{4}.tcon.weights = [1 -1 ];
job{3}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
job{3}.spm.stats.con.consess{5}.tcon.name = ...
    [effectName '_' groups{1}.label ' < ' effectName '_' groups{2}.label];
job{3}.spm.stats.con.consess{5}.tcon.weights = [-1 1];
job{3}.spm.stats.con.consess{5}.tcon.sessrep = 'none';
job{3}.spm.stats.con.consess{6}.tcon.name = ...
    [effectName '_' groups{1}.label ' > ' effectName '_' groups{3}.label];
job{3}.spm.stats.con.consess{6}.tcon.weights = [1 0 -1];
job{3}.spm.stats.con.consess{6}.tcon.sessrep = 'none';
job{3}.spm.stats.con.consess{7}.tcon.name = ...
    [effectName '_' groups{1}.label ' < ' effectName '_' groups{3}.label];
job{3}.spm.stats.con.consess{7}.tcon.weights = [-1 0 1];
job{3}.spm.stats.con.consess{7}.tcon.sessrep = 'none';
job{3}.spm.stats.con.consess{8}.tcon.name = ...
    [effectName '_' groups{2}.label ' > ' effectName '_' groups{3}.label];
job{3}.spm.stats.con.consess{8}.tcon.weights = [0 1 -1];
job{3}.spm.stats.con.consess{8}.tcon.sessrep = 'none';
job{3}.spm.stats.con.consess{9}.tcon.name = ...
    [effectName '_' groups{2}.label ' < ' effectName '_' groups{3}.label];
job{3}.spm.stats.con.consess{9}.tcon.weights = [0 -1 1];
job{3}.spm.stats.con.consess{9}.tcon.sessrep = 'none';


if ~isempty(cov)
    if isfield(cov, 'drug_plasma_lvl_DA')
        job{3}.spm.stats.con.consess{10}.tcon.name = ...
            [effectName ': positive effect of ' groups{2}.label ' level'];
        job{3}.spm.stats.con.consess{10}.tcon.sessrep = 'none';
        job{3}.spm.stats.con.consess{10}.tcon.weights = [0 0 0 1 0];
        job{3}.spm.stats.con.consess{11}.tcon.name = ...
            [effectName ': negative effect of ' groups{2}.label ' level'];
        job{3}.spm.stats.con.consess{11}.tcon.sessrep = 'none';
        job{3}.spm.stats.con.consess{11}.tcon.weights = [0 0 0 -1 0];
        
        job{3}.spm.stats.con.consess{12}.tcon.name = ...
            [effectName ': positive effect of ' groups{3}.label ' level'];
        job{3}.spm.stats.con.consess{12}.tcon.sessrep = 'none';
        job{3}.spm.stats.con.consess{12}.tcon.weights = [0 0 0 0 1];
        job{3}.spm.stats.con.consess{13}.tcon.name = ...
            [effectName ': negative effect of ' groups{3}.label ' level'];
        job{3}.spm.stats.con.consess{13}.tcon.sessrep = 'none';
        job{3}.spm.stats.con.consess{13}.tcon.weights = [0 0 0 0 -1];
        
        job{3}.spm.stats.con.consess{14}.tcon.name = ...
            [effectName ': interaction: ' groups{2}.label ...
            ' > ' groups{3}.label ' level'];
        job{3}.spm.stats.con.consess{14}.tcon.weights = [0 0 0 1 -1];
        job{3}.spm.stats.con.consess{14}.tcon.sessrep = 'none';
        job{3}.spm.stats.con.consess{15}.tcon.name = ...
            [effectName ': interaction: ' groups{2}.label ...
            ' < ' groups{3}.label ' level'];
        job{3}.spm.stats.con.consess{15}.tcon.weights = [0 0 0 -1 1];
        job{3}.spm.stats.con.consess{15}.tcon.sessrep = 'none';
    end
end
job{3}.spm.stats.con.delete = 0;


end