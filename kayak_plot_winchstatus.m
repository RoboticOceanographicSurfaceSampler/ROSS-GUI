% updates the winch plot with the latest data
%
% usage:
%    kayak_plot_winchstatus(handles,message)
% where
%    handles: the gui handles
%    message: a structure of the parsed winch status message
%
% jasmine s nahorniak
% oregon state university
% Dec 2015
% June 13 2016
% March 23 2017


function kayak_plot_winchstatus(handles)

numpts = str2num(get(handles.num_winch_pts,'String'));
straightres = str2num(get(handles.winchstraightres,'String'));
bentres = str2num(get(handles.winchbentres,'String'));
setpointres = str2num(get(handles.winchsetpointres,'String'));
if isempty(straightres),
    straightres=0;
end
if isempty(bentres)
    bentres=0;
end
if isempty(setpointres)
    setpointres=0;
end

% update the X and Y data values in the plots
% (this is faster than running the plot command)
% plot only the latest X data points
if length(handles.winchMATDATE)>=numpts,
  set(handles.winchhan1,'XData',handles.winchMATDATE(end-numpts+1:end),'YData',handles.winchRev(end-numpts+1:end),'CData',handles.winchColor(end-numpts+1:end,:));
  set(handles.winchhan2,'XData',handles.winchMATDATE(end-numpts+1:end),'YData',handles.winchRes(end-numpts+1:end),'CData',handles.winchColor(end-numpts+1:end,:));
  set(handles.winchhan3,'XData',handles.winchMATDATE(end-numpts+1:end),'YData',handles.winchSpd(end-numpts+1:end),'CData',handles.winchColor(end-numpts+1:end,:));
  set(handles.winchreshan1,'XData',[handles.winchMATDATE(end-numpts+1) handles.winchMATDATE(end)],'YData',[straightres straightres]);
  set(handles.winchreshan2,'XData',[handles.winchMATDATE(end-numpts+1) handles.winchMATDATE(end)],'YData',[bentres bentres]);
  set(handles.winchreshan3,'XData',[handles.winchMATDATE(end-numpts+1) handles.winchMATDATE(end)],'YData',[setpointres setpointres]);
else
  set(handles.winchhan1,'XData',handles.winchMATDATE,'YData',handles.winchRev,'CData',handles.winchColor);
  set(handles.winchhan2,'XData',handles.winchMATDATE,'YData',handles.winchRes,'CData',handles.winchColor);
  set(handles.winchhan3,'XData',handles.winchMATDATE,'YData',handles.winchSpd,'CData',handles.winchColor);
  set(handles.winchreshan1,'XData',[handles.winchMATDATE(1) handles.winchMATDATE(end)],'YData',[straightres straightres]);
  set(handles.winchreshan2,'XData',[handles.winchMATDATE(1) handles.winchMATDATE(end)],'YData',[bentres bentres]);
  set(handles.winchreshan3,'XData',[handles.winchMATDATE(1) handles.winchMATDATE(end)],'YData',[setpointres setpointres]);
end

datetick(handles.winchax1,'x','HH:MM:SS','keeplimits')
datetick(handles.winchax2,'x','HH:MM:SS','keeplimits')
datetick(handles.winchax3,'x','HH:MM:SS','keeplimits')


