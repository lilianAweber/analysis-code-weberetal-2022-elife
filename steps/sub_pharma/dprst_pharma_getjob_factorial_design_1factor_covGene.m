function [ job ] = dprst_pharma_getjob_factorial_design_1factor_covGene(facdir, groups, cov, effectName)

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
job{1}.spm.stats.factorial_design.cov(1).c = cov.drug_plasma_lvl_DA;
job{1}.spm.stats.factorial_design.cov(1).cname = 'drug_plasma_lvl_DA';
job{1}.spm.stats.factorial_design.cov(1).iCFI = 1;
job{1}.spm.stats.factorial_design.cov(1).iCC = cov.drug_plasma_lvl_DA_mC;

job{1}.spm.stats.factorial_design.cov(2).c = cov.drug_plasma_lvl_ACh;
job{1}.spm.stats.factorial_design.cov(2).cname = 'drug_plasma_lvl_ACh';
job{1}.spm.stats.factorial_design.cov(2).iCFI = 1;
job{1}.spm.stats.factorial_design.cov(2).iCC = cov.drug_plasma_lvl_ACh_mC;

if isfield(cov, 'COMT_All')
    job{1}.spm.stats.factorial_design.cov(3).c = cov.COMT_All;
    job{1}.spm.stats.factorial_design.cov(3).cname = 'COMT_lvl_All';
    job{1}.spm.stats.factorial_design.cov(3).iCFI = cov.COMT_All_int;
    job{1}.spm.stats.factorial_design.cov(3).iCC = cov.COMT_All_mC;
elseif isfield(cov, 'ChAt_All')
    job{1}.spm.stats.factorial_design.cov(3).c = cov.ChAt_All;
    job{1}.spm.stats.factorial_design.cov(3).cname = 'ChAt_lvl_All';
    job{1}.spm.stats.factorial_design.cov(3).iCFI = cov.ChAt_All_int;
    job{1}.spm.stats.factorial_design.cov(3).iCC = cov.ChAt_All_mC;
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
job{3}.spm.stats.con.consess{3}.fcon.weights = ...
   [1 0 0 0 0
    0 1 0 0 0
    0 0 1 0 0];
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

if isfield(cov, 'COMT_All')
    job{3}.spm.stats.con.consess{10}.tcon.name = ...
        ['COMT: ' groups{1}.label ' > ' effectName '_' groups{2}.label];
    job{3}.spm.stats.con.consess{10}.tcon.weights = [0 0 0 0 0 1 -1];
    job{3}.spm.stats.con.consess{10}.tcon.sessrep = 'none';

    job{3}.spm.stats.con.consess{11}.tcon.name = ...
        ['COMT: ' groups{1}.label ' < ' effectName '_' groups{2}.label];
    job{3}.spm.stats.con.consess{11}.tcon.weights = [0 0 0 0 0 -1 1];
    job{3}.spm.stats.con.consess{11}.tcon.sessrep = 'none';

    job{3}.spm.stats.con.consess{12}.tcon.name = ...
        ['Pos. effect of COMT in ' groups{1}.label];
    job{3}.spm.stats.con.consess{12}.tcon.weights = [0 0 0 0 0 1];
    job{3}.spm.stats.con.consess{12}.tcon.sessrep = 'none';

    job{3}.spm.stats.con.consess{13}.tcon.name = ...
        ['Neg. effect of COMT in ' groups{1}.label];
    job{3}.spm.stats.con.consess{13}.tcon.weights = [0 0 0 0 0 -1];
    job{3}.spm.stats.con.consess{13}.tcon.sessrep = 'none';
    
    job{3}.spm.stats.con.consess{14}.tcon.name = ...
        ['Pos. effect of COMT in ' groups{2}.label];
    job{3}.spm.stats.con.consess{14}.tcon.weights = [0 0 0 0 0 0 1];
    job{3}.spm.stats.con.consess{14}.tcon.sessrep = 'none';
    
    job{3}.spm.stats.con.consess{15}.tcon.name = ...
        ['Pos. effect of COMT in ' groups{2}.label];
    job{3}.spm.stats.con.consess{15}.tcon.weights = [0 0 0 0 0 0 -1];
    job{3}.spm.stats.con.consess{15}.tcon.sessrep = 'none';
elseif isfield(cov, 'ChAt_All')
    job{3}.spm.stats.con.consess{10}.tcon.name = ...
        ['ChAt: ' groups{1}.label ' > ' effectName '_' groups{3}.label];
    job{3}.spm.stats.con.consess{10}.tcon.weights = [0 0 0 0 0 1 0 -1];
    job{3}.spm.stats.con.consess{10}.tcon.sessrep = 'none';

    job{3}.spm.stats.con.consess{11}.tcon.name = ...
        ['ChAt: ' groups{1}.label ' < ' effectName '_' groups{3}.label];
    job{3}.spm.stats.con.consess{11}.tcon.weights = [0 0 0 0 0 -1 0 1];
    job{3}.spm.stats.con.consess{11}.tcon.sessrep = 'none';

    job{3}.spm.stats.con.consess{12}.tcon.name = ...
        ['Pos. effect of ChAt in ' groups{1}.label];
    job{3}.spm.stats.con.consess{12}.tcon.weights = [0 0 0 0 0 1];
    job{3}.spm.stats.con.consess{12}.tcon.sessrep = 'none';

    job{3}.spm.stats.con.consess{13}.tcon.name = ...
        ['Neg. effect of ChAt in ' groups{1}.label];
    job{3}.spm.stats.con.consess{13}.tcon.weights = [0 0 0 0 0 -1];
    job{3}.spm.stats.con.consess{13}.tcon.sessrep = 'none';
    
    job{3}.spm.stats.con.consess{14}.tcon.name = ...
        ['Pos. effect of ChAt in ' groups{3}.label];
    job{3}.spm.stats.con.consess{14}.tcon.weights = [0 0 0 0 0 0 0 1];
    job{3}.spm.stats.con.consess{14}.tcon.sessrep = 'none';
    
    job{3}.spm.stats.con.consess{15}.tcon.name = ...
        ['Pos. effect of ChAt in ' groups{3}.label];
    job{3}.spm.stats.con.consess{15}.tcon.weights = [0 0 0 0 0 0 0 -1];
    job{3}.spm.stats.con.consess{15}.tcon.sessrep = 'none';
end

job{3}.spm.stats.con.consess{16}.tcon.name = ...
    [effectName ': positive effect of ' groups{2}.label ' level'];
job{3}.spm.stats.con.consess{16}.tcon.sessrep = 'none';
job{3}.spm.stats.con.consess{16}.tcon.weights = [0 0 0 1 0];
job{3}.spm.stats.con.consess{17}.tcon.name = ...
    [effectName ': negative effect of ' groups{2}.label ' level'];
job{3}.spm.stats.con.consess{17}.tcon.sessrep = 'none';
job{3}.spm.stats.con.consess{17}.tcon.weights = [0 0 0 -1 0];

job{3}.spm.stats.con.consess{18}.tcon.name = ...
    [effectName ': positive effect of ' groups{3}.label ' level'];
job{3}.spm.stats.con.consess{18}.tcon.sessrep = 'none';
job{3}.spm.stats.con.consess{18}.tcon.weights = [0 0 0 0 1];
job{3}.spm.stats.con.consess{19}.tcon.name = ...
    [effectName ': negative effect of ' groups{3}.label ' level'];
job{3}.spm.stats.con.consess{19}.tcon.sessrep = 'none';
job{3}.spm.stats.con.consess{19}.tcon.weights = [0 0 0 0 -1];

job{3}.spm.stats.con.consess{20}.tcon.name = ...
    [effectName ': interaction: ' groups{2}.label ...
    ' > ' groups{3}.label ' level'];
job{3}.spm.stats.con.consess{20}.tcon.weights = [0 0 0 1 -1];
job{3}.spm.stats.con.consess{20}.tcon.sessrep = 'none';
job{3}.spm.stats.con.consess{21}.tcon.name = ...
    [effectName ': interaction: ' groups{2}.label ...
    ' < ' groups{3}.label ' level'];
job{3}.spm.stats.con.consess{21}.tcon.weights = [0 0 0 -1 1];
job{3}.spm.stats.con.consess{21}.tcon.sessrep = 'none';

job{3}.spm.stats.con.delete = 0;


end