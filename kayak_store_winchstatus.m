% appends the latest winch status data to the data store
%
% usage:
%    kayak_store_winchstatus(handles,msg)
% where
%    handles: the GUI handles (output from kayak_gui)
%    msg: the parsed kayak status data (a structure)
%
% jasmine s nahorniak
% oregon state university
% march 14 2016



function newhandles = kayak_store_winchstatus(handles,msg)

newhandles = handles;

newhandles.winchDATE = {handles.winchDATE; num2str(msg.DATE)};
newhandles.winchMATDATE = [handles.winchMATDATE; msg.MATDATE];
newhandles.winchSTAT = [handles.winchSTAT; msg.STATUS];
newhandles.winchRev = [handles.winchRev; msg.Rev];
newhandles.winchRes = [handles.winchRes; msg.Res];
newhandles.winchSpd = [handles.winchSpd; msg.Spd];
newhandles.winchDir = {handles.winchDir; msg.Dir};
newhandles.winchDOWNLOADING = {handles.winchDOWNLOADING; msg.DOWNLOADING};

% pull out the direction information from the message and assign a color
if strcmp(msg.Dir,'up'),
    thisColor=[0 1 0]; % green
elseif strcmp(msg.Dir,'down'),
    thisColor=[0 0 1]; % blue
else
    thisColor=[1 0 0]; %red;
end

newhandles.winchColor = [handles.winchColor; thisColor];





