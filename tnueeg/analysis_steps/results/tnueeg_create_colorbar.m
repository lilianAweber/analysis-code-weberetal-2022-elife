function tnueeg_create_colorbar( configs )
%TNUEEG_CREATE_COLORBAR
%   IN:     configs - 
%   OUT:    -

h = figure;
colormap(configs.colmap)
c = colorbar;
caxis(configs.limits);

if isfield(configs, 'ticks')
    c.Ticks = configs.ticks;
end
c.FontSize = configs.fontsize;
c.FontWeight = configs.fontweight;
c.TickLength = configs.ticklength;
c.LineWidth = configs.linewidth;

currentPosition = c.Position;
currentPosition(3) = configs.width;
c.Position = currentPosition;
c.Location = 'eastoutside';

h.Children(2).Visible = 'off';

print(h, configs.filename, '-dpng', '-r600');
close(h);

end


