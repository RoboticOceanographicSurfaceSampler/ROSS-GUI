% marks the current waypoint on the kayak status plot
%
% usage:
%    kayak_plot_curwp(wayhan,wpchan,curwp)
% where
%    wayhan: the handle of the waypoints line
%    wpchan: the handle of the current waypoint marker to update
%    msg: the parsed kayak message (a structure)
%
% jasmine s nahorniak
% oregon state university
% Dec 2015
% revised Feb 26 2016


function kayak_plot_curwp(wayhan,wpchan,msg)

% find the map coordinates and sequence numbers of all waypoints
wpX=get(wayhan,'XData');
wpY=get(wayhan,'YData');
wpseq=get(wayhan,'UserData');


% pull out the coordinates of the current waypoint based on the sequence number
if ((length(wpX)==1 && ~isnan(wpX)) || length(wpX)>1),
  wpcid=find(wpseq==msg.CURWP);
  newX=wpX(wpcid);
  newY=wpY(wpcid);
  set(wpchan,'XData',newX,'YData',newY,'ZData',1);
end
