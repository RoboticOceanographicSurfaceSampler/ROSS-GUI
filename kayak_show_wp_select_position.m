% updates the kayak gui with the current cursor position
%
% usage:
%    kayak_show_cursor_position(handles)
% where
%    handles: the GUI handles (output from kayak_gui)
%
% jasmine s nahorniak
% oregon state university
% march 14 2016



function kayak_show_wp_select_position(handles,wplat,wplon)

hax=handles.axes1;
hlat=handles.cursor_lat;
hlon=handles.cursor_lon;

% update the values in the gui
if (wplat>axlims(3) && wplat<axlims(4) && wplon>axlims(1) && wplon<axlims(2)),
   set(hlat,'String',num2str(wplat),'Color','b');
   set(hlon,'String',num2str(wplon),'Color','b');
end



