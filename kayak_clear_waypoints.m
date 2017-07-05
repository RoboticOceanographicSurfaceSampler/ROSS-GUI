% clears all waypoints from the kayak status plot and listbox
%
% usage:
%    kayak_clear_waypoints(handles)
% where
%    handles: a structure of handles
%    type: the type of waypoints to clear ('final','temp')
%
% jasmine s nahorniak
% oregon state university
% Dec 2015
% revised Feb 26 2016


function kayak_clear_waypoints(handles,type)

% clear the listbox
set(handles.listbox1,'String',{});

if (strcmp(type,'final')),
  % clear the final (saved) set of waypoints
  set(handles.wayhan,'XData',NaN,'YData',NaN,'ZData',NaN);
  delete(findall(handles.axes1,'Tag','wpnumfinal'));
  set(handles.wayhan,'UserData',[NaN])

  % clear the current waypoint
  set(handles.wpchan,'XData',NaN,'YData',NaN,'ZData',NaN);

  
else
  % clear the temporary set of waypoints
  set(handles.wpshan,'XData',NaN,'YData',NaN,'ZData',NaN);
  delete(findall(handles.axes1,'Tag','wpnumtemp'));
  set(handles.wpshan,'UserData',[NaN])
    
    
end



