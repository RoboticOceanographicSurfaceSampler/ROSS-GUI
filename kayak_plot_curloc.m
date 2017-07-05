% marks the most recent location on the kayak status plot
%
% usage:
%    kayak_plot_curloc(curlochan,msg)
% where
%    curlochan: the handle of the current location marker
%    msg: the parsed kayak status message
%
% jasmine s nahorniak
% oregon state university
% Feb 26 2016


function kayak_plot_curloc(curlochan,msg)

%[newX,newY]=mfwdtran([msg.LAT],[msg.LON]);
newX=[msg.LON];
newY=[msg.LAT];

if ((newX ~= 0 ) && (newY ~= 0)),
   set(curlochan,'XData',newX,'YData',newY,'ZData',1);
end

%figure(893)
%hold on;
%plot(newX,newY,'r.')

end
