% loops over the serial port connection until
% the connection is successful
%
% usage:
%    s=kayak_connect_loop(kayak)
% where
%    s: the serial connection handle
%    kayak: the kayak name (e.g. 'kayak1')
%
% jasmine s nahorniak
% oregon state university
% July 6 2016

function [s]=kayak_connect_loop(kayak)

% open the serial port connection
notconnected=1;
disp('Connecting to the PC antenna on the COM port ...')
while notconnected,
  try
    [s]=kayak_connect(kayak);
    notconnected=0;
    disp('Successfully connected to PC antenna.')
  catch
    disp('... will try again in 5 seconds ...')
    pause(5)
  end
end