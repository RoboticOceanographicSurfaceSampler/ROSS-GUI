% updates the kayak gui with the current date/time and location as a string
%
% usage:
%    kayak_show_status(handles,msg)
% where
%    handles: the GUI handles (output from kayak_gui)
%    msg: the parsed kayak status data (a structure)
%
% jasmine s nahorniak
% oregon state university
% march 14 2016



function kayak_show_status(handles,msg)

htext=handles.status;

% current status string
curlat=sprintf('%8.5f',msg.LAT);
curlon=sprintf('%10.5f',msg.LON);
current_status={['NAVIG --- ' num2str(msg.DATE) ' (' curlat ' deg N, ' curlon ' deg E)']};

set(htext,'String',current_status);



