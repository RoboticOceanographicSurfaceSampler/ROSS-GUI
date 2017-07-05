% updates the ctd plot with the latest data line-by-line
%
% usage:
%    kayak_plot_ctd(handles,ctdstruct)
% where
%    handles: the gui handles
%    ctdstruct: a structure of ctd data
%
% jasmine s nahorniak
% oregon state university
% Dec 2015
% June 2 2016


function kayak_plot_ctd(handles,data)


linehan = handles.ctdhan3;

numpts=str2num(get(handles.ctdnumcasts,'String'));

ctddatenum=datenum([data.CTDDATE ' ' data.CTDTIME],'yyyy-mmm-dd HH:MM:SS');


% update the X and Y data values in the plots
% (this is faster than running the plot command)
oldX=get(linehan,'XData');
oldY=get(linehan,'YData');

newX=ctddatenum;
newY=data.PRESS;

combinedX=[oldX newX];
combinedY=[oldY newY];


%plot only the latest X data points
if length(combinedX)>=numpts,
  set(linehan,'XData',combinedX(end-numpts+1:end),'YData',combinedY(end-numpts+1:end));
else
  set(linehan,'XData',combinedX,'YData',combinedY);
end



