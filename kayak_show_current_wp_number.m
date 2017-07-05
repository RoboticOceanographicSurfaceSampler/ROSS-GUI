% updates the kayak gui with the current waypoint number
%
% usage:
%    kayak_show_current_wp_number(handles,message)
% where
%    handles: the handles for the GUI
%    message: the parsed status message
%
% jasmine s nahorniak
% oregon state university
% march 14 2016



function kayak_show_current_wp_number(handles,msg)

h=handles.current_wp;

wpnum=msg.CURWP;

% update the value in the gui
set(h,'String',num2str(wpnum));




