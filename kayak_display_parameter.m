% updates the kayak gui with the latest parameter value
% this code assumes that the field name in the GUI is identical to the parameter name
% (e.g. WP_RADIUS)
%
% usage:
%    kayak_display_parameter(handles,message)
% where
%    handles: the handles for the GUI
%    message: the parsed status message
%
% jasmine s nahorniak
% oregon state university
% march 14 2016



function kayak_display_parameter(handles,msg)

% get the GUI handle to the field
if strcmp(msg.parameter,handles.param_name.String),
    h=handles.param_value;
else
    eval(['h=handles.' msg.parameter ';'])
end

% update the value in the gui
set(h,'String',num2str(msg.value));




