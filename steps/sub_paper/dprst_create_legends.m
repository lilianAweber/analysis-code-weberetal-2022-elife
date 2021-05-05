function [ fh1, fh2, fh3, fh4 ] = dprst_create_legends( col, lineWidthErps )
%DPRST_CREATE_LEGENDS Creates dummy legends for all ERP figures in the
%DPRST MMN ERP paper, without legend entries.

% two entries: conditions
legendEntries = {'', ''};
fh1 = figure; hold on;
plot([0 1], [1 1], 'LineWidth', lineWidthErps, 'Color', col.medgray, ...
    'LineStyle', '-');
plot([0 1], [1 1], 'LineWidth', lineWidthErps, 'Color', col.medgray, ...
    'LineStyle', '-.');
legend(legendEntries, 'Location', 'northeastoutside', ...
    'FontSize', 18, 'FontName', 'Arial');
%legend('boxoff');

% three entries: drug groups
legendEntries = {'', '', ''};
fh2 = figure; hold on;
plot([0 1], [1 1], 'LineWidth', lineWidthErps, 'Color', col.placebo, ...
    'LineStyle', '-');
plot([0 1], [1 1], 'LineWidth', lineWidthErps, 'Color', col.dopamine, ...
    'LineStyle', '-');
plot([0 1], [1 1], 'LineWidth', lineWidthErps, 'Color', col.acetylcholine, ...
    'LineStyle', '-');
legend(legendEntries, 'Location', 'northeastoutside', ...
    'FontSize', 18, 'FontName', 'Arial');
%legend('boxoff');

% two entries plus diff: conditions
legendEntries = {'', '', ''};
fh3 = figure; hold on;
plot([0 1], [1 1], 'LineWidth', lineWidthErps, 'Color', col.medgray, ...
    'LineStyle', '-');
plot([0 1], [1 1], 'LineWidth', lineWidthErps, 'Color', col.medgray, ...
    'LineStyle', '-.');
plot([0 1], [1 1], 'LineWidth', 1, 'Color', [0 0 0], ...
    'LineStyle', '-');
legend(legendEntries, 'Location', 'northeastoutside', ...
    'FontSize', 18, 'FontName', 'Arial');

% four entries: conditions
legendEntries = {'', '', '', ''};
fh4 = figure; hold on;
plot([0 1], [1 1], 'LineWidth', lineWidthErps, 'Color', col.medgray, ...
    'LineStyle', '-');
plot([0 1], [1 1], 'LineWidth', lineWidthErps, 'Color', col.medgray, ...
    'LineStyle', '-.');
plot([0 1], [1 1], 'LineWidth', 2, 'Color', col.medgray, ...
    'LineStyle', '-');
plot([0 1], [1 1], 'LineWidth', 2, 'Color', col.medgray, ...
    'LineStyle', '-.');
legend(legendEntries, 'Location', 'northeastoutside', ...
    'FontSize', 18, 'FontName', 'Arial');
%legend('boxoff');
