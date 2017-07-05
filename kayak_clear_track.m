% clears all track points from the figure
%
% usage:
%    kayak_clear_track(handle)
% where
%    handle: the track line handle (output from kayak_gui
%
% jasmine s nahorniak
% oregon state university
% march 14 2016



function kayak_clear_track(handle)

% clear the track data from the gui figure
set(handle,'XData',NaN,'YData',NaN,'ZData',NaN);





