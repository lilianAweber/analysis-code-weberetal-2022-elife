function [ job ] = dprst_getjob_1stlevel_erp_fullfactorial(facdir, factors, cells)
%DPRST_GETJOB_1STLEVEL_ERP_FULLFACTORIAL 
%   IN:     facdir      - directory (string) for saving the SPM.mat
%           factors     - cell array of dimension 4 x nFactors specifying the name, number of
%                       levels, dependency and (un)equal variance assumption for each factor
%           cells       - struct with nCells entries and substruct fields specifying the factor
%                       levels and the corresponding image files (scans) for each cell of the design
%   OUT:    job         - the job for the 2nd level statistics that can be run using the spm_jobman


nFactors = size(factors, 2);
nCells = numel(cells);

% job 1: factorial design
job{1}.spm.stats.factorial_design.dir = {facdir};

for iFac = 1: nFactors
    job{1}.spm.stats.factorial_design.des.fd.fact(iFac).name = factors{1, iFac};
    job{1}.spm.stats.factorial_design.des.fd.fact(iFac).levels = factors{2, iFac};
    job{1}.spm.stats.factorial_design.des.fd.fact(iFac).dept = factors{3, iFac};
    job{1}.spm.stats.factorial_design.des.fd.fact(iFac).variance = factors{4, iFac};
    job{1}.spm.stats.factorial_design.des.fd.fact(iFac).gmsca = 0;
    job{1}.spm.stats.factorial_design.des.fd.fact(iFac).ancova = 0;
end

for iCell = 1: nCells
    job{1}.spm.stats.factorial_design.des.fd.icell(iCell).levels = cells(iCell).levels;
    job{1}.spm.stats.factorial_design.des.fd.icell(iCell).scans = cells(iCell).scans;
end

job{1}.spm.stats.factorial_design.des.fd.contrasts = 1;
job{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
job{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
job{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
job{1}.spm.stats.factorial_design.masking.im = 1;
job{1}.spm.stats.factorial_design.masking.em = {''};
job{1}.spm.stats.factorial_design.globalc.g_omit = 1;
job{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
job{1}.spm.stats.factorial_design.globalm.glonorm = 1;

% job 2: estimate factorial design
job{2}.spm.stats.fmri_est.spmmat(1) = ...
    cfg_dep('Factorial design specification: SPM.mat File', ...
    substruct('.','val', '{}',{1}, ...
    '.','val', '{}',{1}, ...
    '.','val', '{}',{1}), ...
    substruct('.','spmmat'));
job{2}.spm.stats.fmri_est.write_residuals = 0;
job{2}.spm.stats.fmri_est.method.Classical = 1;

% job 3: specify contrasts
job{3}.spm.stats.con.spmmat(1) = ...
    cfg_dep('Model estimation: SPM.mat File', ...
    substruct('.','val', '{}',{2}, ...
    '.','val', '{}',{1}, ...
    '.','val', '{}',{1}), ...
    substruct('.','spmmat'));

job{3}.spm.stats.con.consess{1}.tcon.name = 'standards > deviants';
job{3}.spm.stats.con.consess{1}.tcon.weights = [1 -1 1 -1];
job{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';

job{3}.spm.stats.con.consess{2}.tcon.name = 'stable > volatile';
job{3}.spm.stats.con.consess{2}.tcon.weights = [1 1 -1 -1];
job{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';

job{3}.spm.stats.con.consess{3}.tcon.name = 'stable sta>dev > volatile sta>dev';
job{3}.spm.stats.con.consess{3}.tcon.weights = [1 -1 -1 1];
job{3}.spm.stats.con.consess{3}.tcon.sessrep = 'none';

job{3}.spm.stats.con.consess{4}.tcon.name = 'stable standards > volatile standards';
job{3}.spm.stats.con.consess{4}.tcon.weights = [1 0 -1 0];
job{3}.spm.stats.con.consess{4}.tcon.sessrep = 'none';

job{3}.spm.stats.con.consess{5}.tcon.name = 'stable deviants > volatile deviants';
job{3}.spm.stats.con.consess{5}.tcon.weights = [0 1 0 -1];
job{3}.spm.stats.con.consess{5}.tcon.sessrep = 'none';

job{3}.spm.stats.con.consess{6}.tcon.name = 'stable sta>dev';
job{3}.spm.stats.con.consess{6}.tcon.weights = [1 -1 0 0];
job{3}.spm.stats.con.consess{6}.tcon.sessrep = 'none';

job{3}.spm.stats.con.consess{7}.tcon.name = 'volatile sta>dev';
job{3}.spm.stats.con.consess{7}.tcon.weights = [0 0 1 -1];
job{3}.spm.stats.con.consess{7}.tcon.sessrep = 'none';

job{3}.spm.stats.con.consess{8}.tcon.name = 'stable standards';
job{3}.spm.stats.con.consess{8}.tcon.weights = [1 0 0 0];
job{3}.spm.stats.con.consess{8}.tcon.sessrep = 'none';

job{3}.spm.stats.con.consess{9}.tcon.name = 'stable deviants';
job{3}.spm.stats.con.consess{9}.tcon.weights = [0 1 0 0];
job{3}.spm.stats.con.consess{9}.tcon.sessrep = 'none';

job{3}.spm.stats.con.consess{10}.tcon.name = 'volatile standards';
job{3}.spm.stats.con.consess{10}.tcon.weights = [0 0 1 0];
job{3}.spm.stats.con.consess{10}.tcon.sessrep = 'none';

job{3}.spm.stats.con.consess{11}.tcon.name = 'volatile deviants';
job{3}.spm.stats.con.consess{11}.tcon.weights = [0 0 0 1];
job{3}.spm.stats.con.consess{11}.tcon.sessrep = 'none';

job{3}.spm.stats.con.consess{12}.tcon.name = 'standards';
job{3}.spm.stats.con.consess{12}.tcon.weights = [1 0 1 0];
job{3}.spm.stats.con.consess{12}.tcon.sessrep = 'none';

job{3}.spm.stats.con.consess{13}.tcon.name = 'deviants';
job{3}.spm.stats.con.consess{13}.tcon.weights = [0 1 0 1];
job{3}.spm.stats.con.consess{13}.tcon.sessrep = 'none';

job{3}.spm.stats.con.delete = 1;

%{
% job 3: print results (not needed for 1stlevel analysis
job{4}.spm.stats.results.spmmat(1) = ...
    cfg_dep('Contrast Manager: SPM.mat File', ...
    substruct('.','val', '{}',{3}, ...
    '.','val', '{}',{1}, ...
    '.','val', '{}',{1}), ...
    substruct('.','spmmat'));

for iCon = 1: numel(job{3}.spm.stats.con.consess)
    job{4}.spm.stats.results.conspec(iCon).titlestr = job{3}.spm.stats.con.consess{iCon}.tcon.name;
    job{4}.spm.stats.results.conspec(iCon).contrasts = iCon;
    job{4}.spm.stats.results.conspec(iCon).threshdesc = 'none';
    job{4}.spm.stats.results.conspec(iCon).thresh = 0.001;
    job{4}.spm.stats.results.conspec(iCon).extent = 0;
    job{4}.spm.stats.results.conspec(iCon).mask = ...
        struct('contrasts', {}, 'thresh', {}, 'mtype', {});
end

job{4}.spm.stats.results.units = 2;
job{4}.spm.stats.results.print = 'pdf';
job{4}.spm.stats.results.write.none = 1;
%}
end
