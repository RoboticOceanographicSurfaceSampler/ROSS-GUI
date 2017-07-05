% updates the kayak status plot with the waypoint locations
%
% usage:
%    kayak_plot_waypoint(handles,type,msg)
% where
%    handles: a structure of handles
%    type: the type of waypoints to update (final or temp)
%    msg: the parsed kayak status data (a structure)
%
% jasmine s nahorniak
% oregon state university
% Dec 2015
% revised Feb 26 2016


function kayak_plot_waypoint(handles,type,msg)

% axis for the gui figure
hax=handles.axes1;

if (strcmp(type,'temp')),
    myhan=handles.wpshan;
    mycolor='yellow';
    mytag='wpnumtemp';
else
    myhan=handles.wayhan;
    mycolor='white';
    mytag='wpnumfinal';
end

% update the X and Y data values in the plots
% (this is faster than running the plot command)
oldX=get(myhan,'XData');
oldY=get(myhan,'YData');
oldU=get(myhan,'UserData');

%[newX,newY]=mfwdtran([msg.LAT],[msg.LON]);
newX=[msg.LON];
newY=[msg.LAT];
newU=[msg.WP];

wplons=[oldX newX];
wplats=[oldY newY];
wpseq=[oldU newU];
wpz=zeros(size(wplats));

% don't change the axis limits even if the waypoints are outside of our image
% because they may be old waypoints from a previous deployment
axis(hax,'manual')

% convert the waypoint numbers to a string cell
wpnumcell=arrayfun(@num2str,wpseq,'Uniform',false);

% plot the waypoints
set(myhan,'XData',wplons,'YData',wplats,'ZData',wpz);

% delete any existing waypoint number text
delete(findall(hax,'Tag',mytag));

% add the waypoint numbers to the figure
text(hax,wplons-0.0002,wplats,wpz,wpnumcell,'Color',mycolor,'FontSize',12,'Tag',mytag);

set(myhan,'UserData',wpseq);
