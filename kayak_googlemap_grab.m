% grabs a google map from your region of choice for future use
%
% usage:
%   kayak_googelmap_grab(kayak);
% where:
%    kayak: the name of the kayak (e.g. kayak1)
%    
% jasmine s nahorniak
% Dec 2015
% revised Feb 15 2016
% oregon state university

function kayak_googlemap_grab(kayak)

disp('Downloading the google map ...')

% get the config file parameters (KAYAK_latmin, ...)
eval([kayak '_config']);

% create the empty base figure
fg=figure;
hold on;
plot([KAYAK_lonmin KAYAK_lonmax KAYAK_lonmax KAYAK_lonmin KAYAK_lonmin], ...
    [KAYAK_latmin KAYAK_latmin KAYAK_latmax KAYAK_latmax KAYAK_latmin],'k.','MarkerSize',1);
axis([KAYAK_lonmin KAYAK_lonmax KAYAK_latmin KAYAK_latmax])
axis('tight')

set(gca,'Box','on')
set(gca,'XColor','w','YColor','w')
set(gcf,'Color','k','position',[286    49   952   636])


% get and save the google map
[glon glat gmap] = plot_google_map('MapType','satellite');
outfile=['googlemap_' num2str(KAYAK_latmin) '_' num2str(KAYAK_latmax) '_' num2str(KAYAK_lonmin) '_' num2str(KAYAK_lonmax) '.mat'];
save(outfile,'glat','glon','gmap')
clear glat glon gmap

% load the plot the google map as a sanity check
load(outfile)
image(glon,glat,gmap)
pause(2)

close(fg)

disp('Download complete.')


