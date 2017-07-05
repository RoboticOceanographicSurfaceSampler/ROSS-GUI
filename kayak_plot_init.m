% sets up the basic figure for the kayak status information
%
% usage:
%   [newhandles]=kayak_plot_init(kayak,handles);
% where:
%    kayak: the name of the kayak (e.g. kayak1)
%    handles: the original handles from the GUI
%    newhandles: the original GUI handles plus the new line handles
%        (linehan,wayhan,wpchan,wpshan,curlochan)
%
% jasmine s nahorniak
% Dec 2015
% revised Feb 15 2016
% oregon state university

function [newhandles]=kayak_plot_init(kayak,handles)

% get the config file parameters (KAYAK_latmin, ...)
eval([kayak '_config']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NAVIGATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% create the empty base figure
hax=handles.axes1;
axes(hax);
hold(hax,'on');
%set(gcf,'Position',[100 100 800 800]);
axis(hax,[KAYAK_lonmin KAYAK_lonmax KAYAK_latmin KAYAK_latmax])

set(hax,'Box','on')
set(hax,'XColor','w','YColor','w')
plot(hax,[KAYAK_lonmin KAYAK_lonmax KAYAK_lonmax KAYAK_lonmin KAYAK_lonmin], ...
    [KAYAK_latmin KAYAK_latmin KAYAK_latmax KAYAK_latmax KAYAK_latmin],'k.','MarkerSize',1);
%h=axesm('eqdcylin');
%setm(h,'maplatlimit',[KAYAK_latmin KAYAK_latmax],'maplonlimit',[KAYAK_lonmin KAYAK_lonmax])
%setm(h,'mlinelocation',KAYAK_grid,'plinelocation',KAYAK_grid)
%setm(h,'parallellabel','on','meridianlabel','on')
%setm(h,'plabelround',-2,'mlabelround',-2)
%setm(h,'mlabelparallel',KAYAK_latmin,'plabelmeridian',KAYAK_lonmin)
%setm(h,'plabellocation',KAYAK_grid,'mlabellocation',KAYAK_grid)
%setm(h,'grid','on','frame','on')
axis(hax,'tight')
%title(hax,kayak)


% set up a line handle for the status data
linehan=plot(hax,NaN,NaN,'w-','Marker','.','MarkerSize',10,'MarkerFaceColor','black');

% set up a line handle for the whole set of waypoints
wayhan=plot(hax,NaN,NaN,'MarkerFaceColor','green','MarkerEdgeColor','white','Marker','o');
set(wayhan,'UserData',[NaN])

% set up a line handle for the selected waypoints
wpshan=plot(hax,NaN,NaN,'MarkerFaceColor','blue','MarkerEdgeColor','white','Marker','o');
set(wpshan,'UserData',[NaN])

% set up a line handle for the current waypoint
wpchan=plot(hax,NaN,NaN,'MarkerFaceColor','red','MarkerEdgeColor','white','Marker','o');

% set up a line handle for the current location
curlochan=plot(hax,NaN,NaN,'MarkerFaceColor','red','MarkerEdgeColor','red','Marker','*');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GOOGLE MAP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% plot the google map
outfile=['googlemap_' num2str(KAYAK_latmin) '_' num2str(KAYAK_latmax) '_' num2str(KAYAK_lonmin) '_' num2str(KAYAK_lonmax) '.mat'];
disp(outfile)
if (exist(outfile,'file')~=2),
    % download the map if we don't have it yet
    kayak_googlemap_grab(kayak)
end
load(outfile)
image(glon,glat,gmap,'Parent',hax)
% reset the axis limits - the google map makes it bigger than planned
axis(hax,[KAYAK_lonmin KAYAK_lonmax KAYAK_latmin KAYAK_latmax])

axpos=get(hax,'Position');
latmean = mean([KAYAK_latmin KAYAK_latmax]);
latscale=KAYAK_latmax - KAYAK_latmin
lonscale=(KAYAK_lonmax - KAYAK_lonmin)*cos(mean([KAYAK_latmin KAYAK_latmax])*pi/180)
%if latscale > lonscale,
%    set(hax,'Position',[axpos(1) axpos(2)*lonscale/latscale axpos(3) axpos(4)]);
%else
%    set(hax,'Position',[axpos(1) axpos(2) axpos(3) axpos(4)*latscale/lonscale]);
%end
set(hax,'dataaspectratio',[1,cosd(latmean),1]);

% add grid lines
grid(hax,'on');
set(hax,'GridAlpha',1,'GridColor','w')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CUSTOM OVERLAYS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

bathy = load('C:\Users\ROSS\kayak-pc\leconte_bathy2016.mat');
terminus = load('C:\Users\ROSS\kayak-pc\leconte_terminus_23april2017.mat');

%image(bathy.lon,bathy.lat,bathy.z,'Parent',hax)
%colormap('winter')
%colorbar
contour(hax,bathy.lon,bathy.lat,bathy.z,[0:20:300],'w')
plot(hax,terminus.lon,terminus.lat,'r-','LineWidth',3)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CTD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ctdax1=handles.axes_ctd1;
axes(ctdax1);
hold(ctdax1,'on');
set(ctdax1,'Box','on','XColor','w','YColor','w','YDir','reverse')
axis(ctdax1,'tight')

ctdax2=handles.axes_ctd2;
axes(ctdax2);
hold(ctdax2,'on');
set(ctdax2,'Box','on','XColor','y','YColor','y','YDir','reverse','Color','none')
axis(ctdax2,'tight')

ctdax3=handles.axes_ctd3;
axes(ctdax3);
hold(ctdax3,'on');
set(ctdax3,'Box','on','XColor','w','YColor','w','YDir','reverse')
axis(ctdax3,'tight')
xlabel(ctdax3,'Time')
ylabel(ctdax3,'Depth (m)')

% set up a line handle
ctdhan3=plot(ctdax3,NaN,NaN,'MarkerFaceColor','white','MarkerEdgeColor','white','Marker','*');
%datetick(ctdax3,'x')

ctdcastnum=0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% WINCH
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% create the empty base figure
winchax1=handles.axis_winch1;
axes(winchax1);
hold(winchax1,'on');
set(winchax1,'Box','on')
set(winchax1,'XColor','w','YColor','w','YDir','reverse')
axis(winchax1,'tight')
ylabel(winchax1,'Revolutions')
datetick('x','HH:MM:SS','keeplimits')

winchax2=handles.axis_winch2;
axes(winchax2);
hold(winchax2,'on');
set(winchax2,'Box','on')
set(winchax2,'XColor','w','YColor','w')
axis(winchax2,'tight')
ylabel(winchax2,'Resistance')
datetick('x','HH:MM:SS','keeplimits')

winchax3=handles.axis_winch3;
axes(winchax3);
hold(winchax3,'on');
set(winchax3,'Box','on')
set(winchax3,'XColor','w','YColor','w')
axis(winchax3,'tight')
ylabel(winchax3,'Speed')
xlabel(winchax3,'Time')
datetick('x','HH:MM:SS','keeplimits')

% set up a line handle for the winch status data
winchhan1=scatter(winchax1,NaN,NaN,5,[1 1 1],'filled');
winchhan2=scatter(winchax2,NaN,NaN,5,[1 1 1],'filled');
winchhan3=scatter(winchax3,NaN,NaN,5,[1 1 1],'filled');
winchreshan1=plot(winchax2,NaN,NaN,'k-');
winchreshan2=plot(winchax2,NaN,NaN,'k-');
winchreshan3=plot(winchax2,NaN,NaN,'b-');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Common
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% update the list of handles
newhandles=handles;
newhandles.linehan=linehan;
newhandles.wayhan=wayhan;
newhandles.wpchan=wpchan;
newhandles.wpshan=wpshan;
newhandles.curlochan=curlochan;
newhandles.ctdax1=ctdax1;
newhandles.ctdax2=ctdax2;
newhandles.ctdax3=ctdax3;
newhandles.ctdcastnum=ctdcastnum;
newhandles.ctdhan1={};
newhandles.ctdhan2={};
newhandles.ctdhan3=ctdhan3;
newhandles.winchax1=winchax1;
newhandles.winchax2=winchax2;
newhandles.winchax3=winchax3;
newhandles.winchhan1=winchhan1;
newhandles.winchhan2=winchhan2;
newhandles.winchhan3=winchhan3;
newhandles.winchreshan1=winchreshan1;
newhandles.winchreshan2=winchreshan2;
newhandles.winchreshan3=winchreshan3;
newhandles.winchDATE = {};
newhandles.winchMATDATE = [];
newhandles.winchSTAT = [];
newhandles.winchRev = [];
newhandles.winchRes = [];
newhandles.winchSpd = [];
newhandles.winchDir = {};
newhandles.winchDOWNLOADING = {};
newhandles.winchColor = [];

% give the figure a chance to load
pause(1);


