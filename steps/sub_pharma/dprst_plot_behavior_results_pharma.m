function fh = dprst_plot_behavior_results_pharma( behavTablePla, ...
    behavTableDA, behavTableACh, options )
%DPRST_PLOT_BEHAVIOR_RESULTS_PHARMA

cols = dprst_define_colors(options.part);
markerSizeHR = 8;
markerSizeRT = 8;
jitterHR = 0.7;
jitterRT = 0.7;

group = [repmat(1, 1, numel(behavTablePla.meanRTs)) ...
repmat(2, 1, numel(behavTableDA.meanRTs)) ...
repmat(3, 1, numel(behavTableACh.meanRTs))];

yRT = ...
[behavTablePla.meanRTs' behavTableDA.meanRTs' behavTableACh.meanRTs'];

yHR = ...
[behavTablePla.hitRate' behavTableDA.hitRate' behavTableACh.hitRate'];

fh = figure; 

subplot(1, 2, 1);
h1 = notBoxPlot(yHR, group, 'jitter', jitterHR, 'markMedian', true);
ylim([0.5 1.1])
xlim([0 4])
yticks([0.5 0.75 1]);
yticklabels({''});
xticklabels({''});
ax = gca;
ax.TickLength = [0.02 0.05];
ax.LineWidth = 1.5;
box off

%h1(1).data.Color = [1 1 1];
h1(1).data.MarkerSize = markerSizeHR;
%h1(1).data.MarkerFaceColor = cols.placebo;
h1(1).mu.Color = [0 0 0];
h1(1).med.Color = [1 1 1];
h1(1).med.LineStyle = '-';
h1(1).semPtch.FaceColor = cols.placebo;
h1(1).semPtch.EdgeColor = cols.placebo;
h1(1).sdPtch.FaceColor = cols.placebo;
h1(1).sdPtch.FaceAlpha = 0.5;
h1(1).sdPtch.EdgeColor = cols.placebo;

%h1(2).data.Color = [1 1 1];
h1(2).data.MarkerSize = markerSizeHR;
%h1(2).data.MarkerFaceColor = cols.dopamine;
h1(2).mu.Color = [0 0 0];
h1(2).med.Color = [1 1 1];
h1(2).med.LineStyle = '-';
h1(2).semPtch.FaceColor = cols.dopamine;
h1(2).semPtch.EdgeColor = cols.dopamine;
h1(2).sdPtch.FaceColor = cols.dopamine;
h1(2).sdPtch.FaceAlpha = 0.5;
h1(2).sdPtch.EdgeColor = cols.dopamine;

%h1(3).data.Color = [1 1 1];
h1(3).data.MarkerSize = markerSizeHR;
%h1(3).data.MarkerFaceColor = cols.acetylcholine;
h1(3).mu.Color = [0 0 0];
h1(3).med.Color = [1 1 1];
h1(3).med.LineStyle = '-';
h1(3).semPtch.FaceColor = cols.acetylcholine;
h1(3).semPtch.EdgeColor = cols.acetylcholine;
h1(3).sdPtch.FaceColor = cols.acetylcholine;
h1(3).sdPtch.FaceAlpha = 0.5;
h1(3).sdPtch.EdgeColor = cols.acetylcholine;

subplot(1, 2, 2);
h2 = notBoxPlot(yRT, group, 'jitter', jitterRT, 'markMedian', true);
ylim([0.3 0.8])
xlim([0 4])
yticks([0.25 0.5 0.75]);
yticklabels({''});
xticklabels({''});
ax = gca;
ax.TickLength = [0.02 0.05];
ax.LineWidth = 1.5;
box off

%h2(1).data.Color = [1 1 1];
h2(1).data.MarkerSize = markerSizeRT;
%h2(1).data.MarkerFaceColor = cols.placebo;
h2(1).mu.Color = [0 0 0];
h2(1).med.Color = [1 1 1];
h2(1).med.LineStyle = '-';
h2(1).semPtch.FaceColor = cols.placebo;
h2(1).semPtch.EdgeColor = cols.placebo;
h2(1).sdPtch.FaceColor = cols.placebo;
h2(1).sdPtch.FaceAlpha = 0.5;
h2(1).sdPtch.EdgeColor = cols.placebo;

%h2(2).data.Color = [1 1 1];
h2(2).data.MarkerSize = markerSizeRT;
%h2(2).data.MarkerFaceColor = cols.dopamine;
h2(2).mu.Color = [0 0 0];
h2(2).med.Color = [1 1 1];
h2(2).med.LineStyle = '-';
h2(2).semPtch.FaceColor = cols.dopamine;
h2(2).semPtch.EdgeColor = cols.dopamine;
h2(2).sdPtch.FaceColor = cols.dopamine;
h2(2).sdPtch.FaceAlpha = 0.5;
h2(2).sdPtch.EdgeColor = cols.dopamine;

%h2(3).data.Color = [1 1 1];
h2(3).data.MarkerSize = markerSizeRT;
%h2(3).data.MarkerFaceColor = cols.acetylcholine;
h2(3).mu.Color = [0 0 0];
h2(3).med.Color = [1 1 1];
h2(3).med.LineStyle = '-';
h2(3).semPtch.FaceColor = cols.acetylcholine;
h2(3).semPtch.EdgeColor = cols.acetylcholine;
h2(3).sdPtch.FaceColor = cols.acetylcholine;
h2(3).sdPtch.FaceAlpha = 0.5;
h2(3).sdPtch.EdgeColor = cols.acetylcholine;

fh.Position = [680 533 1141 424];
