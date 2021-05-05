function dprst_erp_pharma_figures_for_paper

col = dprst_define_colors('anta');
lineWidthErps = 4;

%{
%% legends (general-purpose)
[fh1, fh2, fh3, fh4] = dprst_create_legends(col, lineWidthErps);

savefig(fh1, 'legends_conditions.fig')
print(fh1,'legends_conditions.png','-dpng','-r1000');

savefig(fh2, 'legends_drugs.fig')
print(fh2,'legends_drugs.png','-dpng','-r1000');

savefig(fh3, 'legends_conditions_diff.fig')
print(fh3,'legends_drugs.png','-dpng','-r1000');

savefig(fh4, 'legends_conditions_stadev.fig')
print(fh4,'legends_drugs.png','-dpng','-r1000');

close all;
%}

%% figure 2, panel B
% e.g. /media/law/Seagate Backup Plus
% Drive/DPRST/prj/volmmn_eeg/anta/erp/roving/sensor/
% all_ga_sem_phases_roving_mismatch_FCz.fig

fh = gcf;
zeroLineY = [-2.3 2];
lineWidthZeroLines = 1;

fh = dprst_prettify_ERP_figures_withDiff(fh, col, ...
    lineWidthErps, lineWidthZeroLines, zeroLineY);

savefig(fh, 'figure2_erps_mismatch_pos_FCz.fig')
print(fh,'figure2_erps_mismatch_pos_FCz.png','-dpng','-r1000');


% e.g. /media/law/Seagate Backup Plus
% Drive/DPRST/prj/volmmn_eeg/anta/pharma/erp/phases_roving/
% all_ga_sem_phases_roving_mismatch_TP9.fig

fh = gcf;
zeroLineY = [-1.9 2.7];
lineWidthZeroLines = 1;

fh = dprst_prettify_ERP_figures_withDiff(fh, col, ...
    lineWidthErps, lineWidthZeroLines, zeroLineY);

savefig(fh, 'figure2_erps_mismatch_neg_TP9.fig')
print(fh,'figure2_erps_mismatch_neg_TP9.png','-dpng','-r1000');




%% figure 3, panel A, mismatch
% e.g. /media/law/Seagate Backup Plus
% Drive/DPRST/prj/volmmn_eeg/anta/erp/roving/sensor/
% all_ga_sem_diffWaves_phases_roving_mismatch_Fp2.fig 

fh = gcf;
zeroLineY = [-1 2.9];
lineWidthZeroLines = 1;

fh = dprst_prettify_diffWave_figures(fh, ...
    lineWidthErps, lineWidthZeroLines, zeroLineY);

savefig(fh, 'figure3_diffWaves_mismatch_Fp2.fig')
print(fh,'figure3_diffWaves_mismatch_Fp2.png','-dpng','-r1000');

%% figure 3, panel B, stable mismatch
% e.g. /media/law/Seagate Backup Plus
% Drive/DPRST/prj/volmmn_eeg/anta/erp/roving/sensor/
% all_ga_sem_diffWaves_phases_roving_stable_mismatch_F3.fig 

fh = gcf;
zeroLineY = [-2.5 0.9];
lineWidthZeroLines = 1;

fh = dprst_prettify_diffWave_figures(fh, ...
    lineWidthErps, lineWidthZeroLines, zeroLineY);

savefig(fh, 'figure3_diffWaves_stable_mismatch_F3.fig')
print(fh,'figure3_diffWaves_stable_mismatch_F3.png','-dpng','-r1000');

% e.g. /media/law/Seagate Backup Plus
% Drive/DPRST/prj/volmmn_eeg/anta/erp/roving/sensor/
% all_ga_sem_diffWaves_phases_roving_stable_mismatch_C2.fig 

fh = gcf;
zeroLineY = [-2.5 1.9];
lineWidthZeroLines = 1;

fh = dprst_prettify_diffWave_figures(fh, ...
    lineWidthErps, lineWidthZeroLines, zeroLineY);

savefig(fh, 'figure3_diffWaves_stable_mismatch_C2.fig')
print(fh,'figure3_diffWaves_stable_mismatch_C2.png','-dpng','-r1000');

% e.g. /media/law/Seagate Backup Plus
% Drive/DPRST/prj/volmmn_eeg/anta/erp/roving/sensor/
% all_ga_sem_diffWaves_phases_roving_stable_mismatch_Fz.fig 

fh = gcf;
zeroLineY = [-2.5 1.9];
lineWidthZeroLines = 1;

fh = dprst_prettify_diffWave_figures(fh, ...
    lineWidthErps, lineWidthZeroLines, zeroLineY);

savefig(fh, 'figure3_diffWaves_stable_mismatch_Fz.fig')
print(fh,'figure3_diffWaves_stable_mismatch_Fz.png','-dpng','-r1000');


%% figure 3, panel C, mismatch
% e.g. /media/law/Seagate Backup Plus
% Drive/DPRST/prj/volmmn_eeg/anta/erp/roving/sensor/
% all_ga_sem_diffWaves_phases_roving_mismatch_Fp2.fig 

fh = gcf;
zeroLineY = [-1 2.9];
lineWidthZeroLines = 1;

fh = dprst_prettify_diffWave_figures(fh, ...
    lineWidthErps, lineWidthZeroLines, zeroLineY);

savefig(fh, 'figure3_diffWaves_mismatch_Fp2.fig')
print(fh,'figure3_diffWaves_mismatch_Fp2.png','-dpng','-r1000');

% e.g. /media/law/Seagate Backup Plus
% Drive/DPRST/prj/volmmn_eeg/anta/erp/roving/sensor/
% all_ga_sem_diffWaves_phases_roving_mismatch_FCz.fig 

fh = gcf;
zeroLineY = [-2.6 1.9];
lineWidthZeroLines = 1;

fh = dprst_prettify_diffWave_figures(fh, ...
    lineWidthErps, lineWidthZeroLines, zeroLineY);

savefig(fh, 'figure3_diffWaves_mismatch_FCz.fig')
print(fh,'figure3_diffWaves_mismatch_FCz.png','-dpng','-r1000');

% e.g. /media/law/Seagate Backup Plus
% Drive/DPRST/prj/volmmn_eeg/anta/erp/roving/sensor/
% all_ga_sem_diffWaves_phases_roving_mismatch_O1.fig 

fh = gcf;
zeroLineY = [-2 1.9];
lineWidthZeroLines = 1;

fh = dprst_prettify_diffWave_figures(fh, ...
    lineWidthErps, lineWidthZeroLines, zeroLineY);

savefig(fh, 'figure3_diffWaves_mismatch_O1.fig')
print(fh,'figure3_diffWaves_mismatch_O1.png','-dpng','-r1000');



%% figure 4, panel B, interaction ERPs
% e.g. /media/law/Seagate Backup Plus
% Drive/DPRST/prj/volmmn_eeg/anta/erp/roving/sensor/
% all_ga_sem_phases_roving_interaction_C1.fig

fh = gcf;
zeroLineY = [-2.3 1.9];
lineWidthZeroLines = 1;

fh = dprst_prettify_ERP_figures_withDiff(fh, col, ...
    lineWidthErps, lineWidthZeroLines, zeroLineY);

savefig(fh, 'figure4_erps_interaction_pos_C1.fig')
print(fh,'figure4_erps_interaction_pos_C1.png','-dpng','-r1000');

% e.g. /media/law/Seagate Backup Plus
% Drive/DPRST/prj/volmmn_eeg/anta/erp/roving/sensor/
% all_ga_sem_phases_roving_interaction_C2.fig 

fh = gcf;
zeroLineY = [-2.3 1.9];
lineWidthZeroLines = 1;

fh = dprst_prettify_ERP_figures_withDiff(fh, col, ...
    lineWidthErps, lineWidthZeroLines, zeroLineY);

savefig(fh, 'figure4_erps_interaction_pos_C2.fig')
print(fh,'figure4_erps_interaction_pos_C2.png','-dpng','-r1000');


%% figure 4, panel C, drug effect on interaction
% e.g. /media/law/Seagate Backup Plus
% Drive/DPRST/prj/volmmn_eeg/anta/erp/roving/sensor/
% all_ga_sem_diffWaves_phases_roving_interaction_C2.fig

fh = gcf;
zeroLineY = [-2 2];
lineWidthZeroLines = 1;

fh = dprst_prettify_diffWave_figures(fh, ...
    lineWidthErps, lineWidthZeroLines, zeroLineY);

savefig(fh, 'figure4_erps_interaction_drug_C2.fig')
print(fh,'figure4_erps_interaction_drug_C2.png','-dpng','-r1000');


%% figure 4, panel D, standard/deviant ERPs
% e.g. /media/law/Seagate Backup Plus
% Drive/DPRST/prj/volmmn_eeg/anta/erp/roving/sensor/
% all_ga_sem_phases_roving_C1.fig 

fh = gcf;
zeroLineY = [-1.9 2];
lineWidthZeroLines = 1;

fh = dprst_prettify_ERP_figures_staDev(fh, col, ...
    lineWidthErps, lineWidthZeroLines, zeroLineY);

savefig(fh, 'figure4_erps_interaction_staDev_C1.fig')
print(fh,'figure4_erps_interaction_staDev_C1.png','-dpng','-r1000');

% e.g. /media/law/Seagate Backup Plus
% Drive/DPRST/prj/volmmn_eeg/anta/erp/roving/sensor/
% all_ga_sem_phases_roving_C2.fig 

fh = gcf;
zeroLineY = [-1.9 2];
lineWidthZeroLines = 1;

fh = dprst_prettify_ERP_figures_staDev(fh, col, ...
    lineWidthErps, lineWidthZeroLines, zeroLineY);

savefig(fh, 'figure4_erps_interaction_staDev_C2.fig')
print(fh,'figure4_erps_interaction_staDev_C2.png','-dpng','-r1000');


%% AGONISTS
col = dprst_define_colors('agon');

%% figure 5, panel B, mismatch in agon
% e.g. /media/law/Seagate Backup Plus
% Drive/DPRST/prj/volmmn_eeg/agon/pharma/erp/phases_roving/
% all_ga_sem_phases_roving_mismatch_FCz.fig

fh = gcf;
zeroLineY = [-2.3 2];
lineWidthZeroLines = 1;

fh = dprst_prettify_ERP_figures_withDiff(fh, col, ...
    lineWidthErps, lineWidthZeroLines, zeroLineY);

savefig(fh, 'figure5_agon_mismatch_pos_FCz.fig')
print(fh,'figure5_agon_mismatch_pos_FCz.png','-dpng','-r1000');

% e.g. /media/law/Seagate Backup Plus
% Drive/DPRST/prj/volmmn_eeg/agon/pharma/erp/phases_roving/
% all_ga_sem_phases_roving_mismatch_TP9.fig

fh = gcf;
zeroLineY = [-2 2.7];
lineWidthZeroLines = 1;

fh = dprst_prettify_ERP_figures_withDiff(fh, col, ...
    lineWidthErps, lineWidthZeroLines, zeroLineY);

savefig(fh, 'figure5_agon_mismatch_neg_TP9.fig')
print(fh,'figure5_agon_mismatch_neg_TP9.png','-dpng','-r1000');


%% ANTAGONISTS
col = dprst_define_colors('anta');

%% figure s1, panel B, stability in anta
% e.g. /media/law/Seagate Backup Plus
% Drive/DPRST/prj/volmmn_eeg/anta/erp/roving/sensor/
% all_ga_sem_phases_roving_stability_Pz.fig

fh = gcf;
zeroLineY = [-1.9 1.5];
lineWidthZeroLines = 1;

fh = dprst_prettify_ERP_figures_withDiff(fh, col, ...
    lineWidthErps, lineWidthZeroLines, zeroLineY);

savefig(fh, 'figureS1_erps_stability_pos_Pz.fig')
print(fh,'figureS1_erps_stability_pos_Pz.png','-dpng','-r1000');

% e.g. /media/law/Seagate Backup Plus
% Drive/DPRST/prj/volmmn_eeg/anta/erp/roving/sensor/
% all_ga_sem_phases_roving_stability_Fp1.fig

fh = gcf;
zeroLineY = [-1.9 2];
lineWidthZeroLines = 1;

fh = dprst_prettify_ERP_figures_withDiff(fh, col, ...
    lineWidthErps, lineWidthZeroLines, zeroLineY);
fh.Children(2).YLim = [-2 1.5];

savefig(fh, 'figureS1_erps_stability_pos_Fp1.fig')
print(fh,'figureS1_erps_stability_pos_Fp1.png','-dpng','-r1000');


%% AGONISTS
col = dprst_define_colors('agon');

%% figure s2, panel B, stability in agon
% e.g. /media/law/Seagate Backup Plus
% Drive/DPRST/prj/volmmn_eeg/agon/erp/roving/sensor/
% all_ga_sem_phases_roving_stability_Fz.fig

fh = gcf;
zeroLineY = [-1.9 1.5];
lineWidthZeroLines = 1;

fh = dprst_prettify_ERP_figures_withDiff(fh, col, ...
    lineWidthErps, lineWidthZeroLines, zeroLineY);

savefig(fh, 'figureS2_agon_stability_neg_Fz.fig')
print(fh,'figureS2_agon_stability_neg_Fz.png','-dpng','-r1000');

% e.g. /media/law/Seagate Backup Plus
% Drive/DPRST/prj/volmmn_eeg/agon/erp/roving/sensor/
% all_ga_sem_phases_roving_stability_F2.fig

fh = gcf;
zeroLineY = [-1.9 1.5];
lineWidthZeroLines = 1;

fh = dprst_prettify_ERP_figures_withDiff(fh, col, ...
    lineWidthErps, lineWidthZeroLines, zeroLineY);

savefig(fh, 'figureS2_agon_stability_neg_F2.fig')
print(fh,'figureS2_agon_stability_neg_F2.png','-dpng','-r1000');


%% figure s2, panel C, pharma effects on stability
% e.g. /media/law/Seagate Backup Plus
% Drive/DPRST/prj/volmmn_eeg/agon/pharma/erp/phases_roving/
% all_ga_sem_diffWaves_phases_roving_stability_AF7.fig 

fh = gcf;
zeroLineY = [-2.9 1.5];
lineWidthZeroLines = 1;

fh = dprst_prettify_diffWave_figures(fh, ...
    lineWidthErps, lineWidthZeroLines, zeroLineY);
fh.Children(2).YTick = [-1 -0.5 0 0.5 1];
fh.Children(4).YTick = [-1 -0.5 0 0.5 1];
fh.Children(6).YTick = [-1 -0.5 0 0.5 1];

savefig(fh, 'figureS2_diffWaves_stability_bipPla_AF7.fig')
print(fh,'figureS2_diffWaves_stability_bipPla_AF7.png','-dpng','-r1000');

% e.g. /media/law/Seagate Backup Plus
% Drive/DPRST/prj/volmmn_eeg/agon/pharma/erp/phases_roving/
% all_ga_sem_diffWaves_phases_roving_stability_P5.fig 

fh = gcf;
zeroLineY = [-2.9 1.5];
lineWidthZeroLines = 1;

fh = dprst_prettify_diffWave_figures(fh, ...
    lineWidthErps, lineWidthZeroLines, zeroLineY);
fh.Children(2).YTick = [-1 -0.5 0 0.5 1];
fh.Children(4).YTick = [-1 -0.5 0 0.5 1];
fh.Children(6).YTick = [-1 -0.5 0 0.5 1];

savefig(fh, 'figureS2_diffWaves_stability_bipPla_P5.fig')
print(fh,'figureS2_diffWaves_stability_bipPla_P5.png','-dpng','-r1000');

% e.g. /media/law/Seagate Backup Plus
% Drive/DPRST/prj/volmmn_eeg/agon/pharma/erp/phases_roving/
% all_ga_sem_diffWaves_phases_roving_stability_C5.fig 

fh = gcf;
zeroLineY = [-2.9 1.5];
lineWidthZeroLines = 1;

fh = dprst_prettify_diffWave_figures(fh, ...
    lineWidthErps, lineWidthZeroLines, zeroLineY);
fh.Children(2).YTick = [-1 -0.5 0 0.5 1];
fh.Children(4).YTick = [-1 -0.5 0 0.5 1];
fh.Children(6).YTick = [-1 -0.5 0 0.5 1];

savefig(fh, 'figureS2_diffWaves_stability_plaAmi_C5.fig')
print(fh,'figureS2_diffWaves_stability_plaAmi_C5.png','-dpng','-r1000');

% e.g. /media/law/Seagate Backup Plus
% Drive/DPRST/prj/volmmn_eeg/agon/pharma/erp/phases_roving/
% all_ga_sem_diffWaves_phases_roving_stability_P4.fig 

fh = gcf;
zeroLineY = [-2.9 1.5];
lineWidthZeroLines = 1;

fh = dprst_prettify_diffWave_figures(fh, ...
    lineWidthErps, lineWidthZeroLines, zeroLineY);
fh.Children(2).YTick = [-1 -0.5 0 0.5 1];
fh.Children(4).YTick = [-1 -0.5 0 0.5 1];
fh.Children(6).YTick = [-1 -0.5 0 0.5 1];

savefig(fh, 'figureS2_diffWaves_stability_plaAmi_P4.fig')
print(fh,'figureS2_diffWaves_stability_plaAmi_P4.png','-dpng','-r1000');



end