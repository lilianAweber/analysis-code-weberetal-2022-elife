function [ paper ] = dprst_collect_paper_data( options )
%DPRST_COLLECT_PAPER_DATA Collects all data presented in the ERP paper 
%about the DPRST MMN data.
%   IN:     options     - the struct that holds all analysis options
%   OUT:    ppr         - a struct with paper results

if nargin < 1 
    options = dprst_set_analysis_options;
end

mkdir(fullfile(options.workdir, 'paperdata'));
mainpath = fullfile(options.workdir, 'paperdata', 'main');
suppath = fullfile(options.workdir, 'paperdata', 'supplementary');

%% Main results
mkdir(mainpath);

% Figure 1: Tone sequence, distraction task, and behavioral results.
% Panel A (tone sequence)
% Panel B (paradigm) does not depend on any experimental data.
% Panel C (behav. results study 1)
% Panel D (behav. results study 2)
dprst_erp_paper_figure1(options, mainpath);

% Figure 2: Mismatch effects on ERPs in study 1.
paper.figure2 = dprst_erp_paper_figure2(options, mainpath);

% Figure 3: Drug effects on mismatch ERPs in study 1.
paper.figure3 = dprst_erp_paper_figure3(options, mainpath);

% Figure 4: Interaction effects on ERPs in study 1.
paper.figure4 = dprst_erp_paper_figure4(options, mainpath);

% Figure 5: Mismatch effects on ERPs in study 2.
paper.figure5 = dprst_erp_paper_figure5(options, mainpath);

% Table 1: Behavioral results in the distraction task (study 1).
paper.table1 = dprst_table1(options, mainpath);

% Table 2: Effects of mismatch (study 1).
paper.table2 = dprst_table2(options, mainpath);

% Table 3: Interaction effects (study 1).
paper.table3 = dprst_table3(options, mainpath);

% Table 4: Effects of stable mismatch (study 1).
paper.table4 = dprst_table4(options, mainpath);

% Table 5: Behavioral results in the distraction task (study 2).
paper.table5 = dprst_table5(options, mainpath);

% Table 6: Effects of mismatch (study 2).
paper.table6 = dprst_table6(options, mainpath);

%% Supplementary Results
mkdir(suppath);

% Suppl. Sections:
% 1) Suppl. Methods (does not depend on empirical data).
% 2) Suppl. Results
% 2.1) Main effects of stability

% Figure S1: Stability effects on ERPs in study 1.
paper.suppl.figure1 = dprst_erp_paper_figure_s1(options, suppath);

% Figure S2: Stability effects on ERPs in study 2.
paper.suppl.figure2 = dprst_erp_paper_figure_s2(options, suppath);

% Table S1: Effects of stability (both studies).
paper.suppl.table1 = dprst_table_s1(options, suppath);

% 2.2) Main results with reduced N

% Table S2: All results from study 1 with N=67
% Effects of mismatch, stability, interaction, and stable mismatch (study 1).
paper.suppl.table2 = dprst_table_s2(options, suppath);

% Table S3: All results from study 2 with N=76
% Effects of mismatch and stability (study 2).
paper.suppl.table3 = dprst_table_s3(options, suppath);

% 2.3) Genetic effects and pharmaco-genetic interactions (study 1,2)

% Table S4: Study 1
paper.suppl.table4 = dprst_table_s4(options, suppath);

% Table S5: Study 2
paper.suppl.table5 = dprst_table_s5(options, suppath);

%% save everything
save(fullfile(options.workdir, 'paperdata', 'allPaperData.mat'), 'paper');

close all;


end

