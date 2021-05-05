function dprst_behavior_figure_for_paper

%% figure 1, panel C & D
% e.g. /media/law/Seagate Backup Plus
% Drive/DPRST/prj/volmmn_eeg/anta/pharma/behav/
% anta_behavior_noBoxPlot_HR_RT.fig

fh = gcf;
% adjust line width & tick size
fh.Children(1).LineWidth = 2;
fh.Children(2).LineWidth = 2;
fh.Children(1).TickLength = [0.05 0.05];
fh.Children(2).TickLength = [0.05 0.05];

savefig(fh, 'figure1_behav_anta.fig')
print(fh,'figure1_behav_anta.png','-dpng','-r1000');

% e.g. /media/law/Seagate Backup Plus
% Drive/DPRST/prj/volmmn_eeg/anta/pharma/behav/
% agon_behavior_noBoxPlot_HR_RT.fig

fh = gcf;
% adjust line width & tick size
fh.Children(1).LineWidth = 2;
fh.Children(2).LineWidth = 2;
fh.Children(1).TickLength = [0.05 0.05];
fh.Children(2).TickLength = [0.05 0.05];

savefig(fh, 'figure1_behav_agon.fig')
print(fh,'figure1_behav_agon.png','-dpng','-r1000');


end