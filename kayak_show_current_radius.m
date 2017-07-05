% updates the kayak gui with the current waypoint radius
%
% usage:
%    kayak_show_current_radius(handles,message)
% where
%    handles: the handles for the GUI
%    message: the parsed status message
%
% jasmine s nahorniak
% oregon state university
% march 14 2016



function kayak_display_parameter(handles,msg)

param = msg.

eval(['h=handles.' wp_radius;

radius=msg.WP_RADIUS;

% update the value in the gui
set(h,'String',num2str(radius));




