% updates the kayak status plot with the data from the latest message
%
% usage:
%    kayak_plot_line(linehan,numpts,msg)
% where
%    linehan: the handle of the line to update
%    numpts: the number of points to plot
%    msg: the parsed kayak status data (a structure)
%
% jasmine s nahorniak
% oregon state university
% Dec 2015
% revised Feb 26 2016


function kayak_plot_line(handles,msg)

numpts = str2num(get(handles.num_pts,'String'));
linehan = handles.linehan;

% update the X and Y data values in the plots
% (this is faster than running the plot command)
oldX=get(linehan,'XData');
oldY=get(linehan,'YData');
%[newX,newY]=mfwdtran([msg.LAT],[msg.LON]);
newX=[msg.LON];
newY=[msg.LAT];
%append the data
combinedX=[oldX newX];
combinedY=[oldY newY];
%plot only the latest X data points
if (size(combinedX)==size(combinedY)),
  if (length(combinedX)>=numpts),
    set(linehan,'XData',combinedX(end-numpts+1:end),'YData',combinedY(end-numpts+1:end),'ZData',zeros(1,numpts));
  else
    set(linehan,'XData',combinedX,'YData',combinedY,'ZData',zeros(size(combinedY)));
  end
end
