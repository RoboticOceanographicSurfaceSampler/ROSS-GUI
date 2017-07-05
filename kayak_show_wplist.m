% updates the kayak gui with a list of the waypoint locations
%
% usage:
%    kayak_show_wplist(handles,type,msg)
% where
%    handles: the GUI handles (output from kayak_gui)
%    msg: the parsed kayak status data (a structure)
%    color: the font color for the text
%
% jasmine s nahorniak
% oregon state university
% march 14 2016



function kayak_show_wplist(handles,type,msg)

hlist=handles.listbox1;

if (strcmp(type,'temp')),
    mycolor='b';
else
    mycolor='k';
end

% add the new value to the existing list
oldlist=get(hlist,'String');
newline={[' ' num2str(msg.WP) ' ' num2str(msg.LAT) ' ' num2str(msg.LON)]};
newlist=[oldlist; {[' ' num2str(msg.WP) ' ' num2str(msg.LAT) ' ' num2str(msg.LON)]}];

set(hlist,'String',newlist,'ForegroundColor',mycolor);


