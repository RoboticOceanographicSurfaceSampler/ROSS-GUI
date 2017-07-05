% kayak_disconnect
%
% disconnects an open serial connection
%
% usage : kayak_disconnect(s)
% where s is the serial connection ID
%
%
% jasmine s nahorniak
% march 14 2016

function kayak_disconnect(s)

fclose(s);
delete(s)
clear s