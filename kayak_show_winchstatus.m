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



function kayak_show_winchstatus(handles,msg)

htext=handles.winchstatus;


% current_status={['WINCH --- ' num2str(msg.DATE) ' STATUS ' num2str(msg.STATUS) ' REV ' num2str(msg.Rev) ' RES ' num2str(msg.Res) ' SPD ' num2str(msg.Spd) ' DIR ' msg.Dir ' AVSPD ' num2str(msg.AvSpd) ' MSG ' msg.Msg ' DOWNLOADING ' msg.DOWNLOADING]};
current_status={['WINCH --- ' num2str(msg.DATE) ' STATUS ' num2str(msg.STATUS) ' REV ' num2str(msg.Rev) ' RES ' num2str(msg.Res) ' SPD ' num2str(msg.Spd) ' DIR ' msg.Dir ' DOWNLOADING ' msg.DOWNLOADING]};

set(htext,'String',current_status);



