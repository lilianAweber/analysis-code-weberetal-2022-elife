function dprst_sequence_figure_for_paper

col = dprst_define_colors;

%% figure 1, panel A
% e.g. /media/law/Seagate Backup Plus
% Drive/DPRST/prj/volmmn_eeg/anta/design/probability_structure_phases.fig

fh = gcf;

fh.Children(2).Children(end).Color = col.turquoise;
fh.Children(2).Children(1).FaceColor = col.turquoise;
fh.Children(2).Children(1).FaceAlpha = 0.15;
fh.Children(2).Children(2).FaceColor = col.turquoise;
fh.Children(2).Children(2).FaceAlpha = 0.15;
fh.Children(2).Children(3).FaceColor = col.turquoise;
fh.Children(2).Children(3).FaceAlpha = 0.15;
fh.Children(2).Children(4).FaceColor = col.turquoise;
fh.Children(2).Children(4).FaceAlpha = 0.15;

fh.Children(2).Children(end).LineWidth = 3;

fh.Children(1).String = {'', ''};
savefig(fh, 'figure1_legend.fig');
print(fh,'figure1_legend.png','-dpng','-r1000');

% turn off all labels (legend, title, axes)
fh.Children(1).Visible = 'off';
fh.Children(2).Title.Visible = 'off';
fh.Children(2).XLabel.Visible = 'off';
fh.Children(2).YLabel.Visible = 'off';

fh.Children(2).XTickLabel = {''};
fh.Children(2).YTickLabel = {''};

% adjust tick size
fh.Children(2).TickLength = [0.02 0.05];

savefig(fh, 'figure1_sequence.fig')
print(fh,'figure1_sequence.png','-dpng','-r1000');


end