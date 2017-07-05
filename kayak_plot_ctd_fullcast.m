% updates the ctd plot with the latest datat
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


function [newhandles]=kayak_plot_ctd_fullcast(handles,data)


ax1 = handles.ctdax1;
ax2 = handles.ctdax2;
ax3 = handles.ctdax3;
castnum = handles.ctdcastnum;
ctdhan1 = handles.ctdhan1;
ctdhan2 = handles.ctdhan2;
ctdhan3 = handles.ctdhan3;
numcasts=str2num(get(handles.ctdnumcasts,'String'));

castnum = castnum + 1


%ctdhan1{castnum}=plot(ax1,[data.TEMP]+castnum*0.5,[data.DEPTH],'w','Marker','.','MarkerSize',10,'MarkerFaceColor','w');
%ctdhan1{castnum}=plot(ax1,[data.TEMP],[data.DEPTH],'w','Marker','.','MarkerSize',10,'MarkerFaceColor','w');
%xlabel(ax1,'Temperature (^oC)')
%ctdhan2{castnum}=plot(ax2,[data.SAL]+castnum*0.005,[data.DEPTH],'y','Marker','.','MarkerSize',10,'MarkerFaceColor','y');
%ctdhan2{castnum}=plot(ax2,[data.SAL],[data.DEPTH],'y','Marker','.','MarkerSize',10,'MarkerFaceColor','y');
%xlabel(ax2,'Salinity (PSU)')
%ylabel(ax2,'Depth (m)')
%ctdhan3{castnum}=plot(ax3,[data.DATE]+castnum*0.001,[data.DEPTH],'w','Marker','.','MarkerSize',10,'MarkerFaceColor','w');
ctdhan3{castnum}=plot(ax3,[data.CTDDATENUM],[data.PRESS],'w','Marker','.','MarkerSize',10,'MarkerFaceColor','w');
datetick(ax3,'x','HH:MM:SS')
xlabel(ax3,'Time')
ylabel(ax3,'Depth (m)')

newhandles=handles;
newhandles.ctdcastnum=castnum;
newhandles.ctdhan1=ctdhan1;
newhandles.ctdhan2=ctdhan2;
newhandles.ctdhan3=ctdhan3;

% hide any casts we don't want to see
if castnum>numcasts,
  for i=1:castnum-numcasts,
    %set(ctdhan1{i},'Visible','off')
    %set(ctdhan2{i},'Visible','off')
    set(ctdhan3{i},'Visible','off')
  end
end  
% show any casts we want to see
startcast=max(1,castnum-numcasts+1);
for i=startcast:castnum,
    %set(ctdhan1{i},'Visible','on')
    %set(ctdhan2{i},'Visible','on')
    set(ctdhan3{i},'Visible','on')
end


