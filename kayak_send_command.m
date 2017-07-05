%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% kayak_send_command.m
%
%   Sends a command to a Raspberry Pi (RPi) via serial.
%
%   For this code to work you must first start 
%   the receiving code on the RPi (kayak_main.py)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage:
%   From the Matlab command window,  enter:
%      kayak_send_command(kayak,s,'goto 2 24.3,-123.8, 24.4,-123.8')
%   where the first argument is the kayak ID (e.d. kayak1)
%   the second argument is the serial connection ID (output from kayak_connect)
%   and the final argument is the command to be sent
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REQUIRES
%      Instrument Control Toolbox
%
%
% Jasmine S Nahorniak
% November 25, 2015
% revised Jan 7, 2016
% revised Feb 15, 2016 - removed ethernet option
% revised March 14, 2016 to use s (serial connection) as input
% Oregon State University
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function kayak_send_command(kayak,s,command)

%% check the input arguments for validity
if (nargin~=3),
    disp('Input argument error.');
    disp('Usage:');
    disp('  kayak_send_command(kayak,s,command);')
    disp('     kayak: the kayak ID (e.g. kayak1)');
    disp('     s: the serial connection ID (output from kayak_connect)');   
    disp('     command: command to be run');
    return
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% add the prefix to the command
msg=[kayak ' ' command];
  
%% send the command to the RPi
try
    msg
    fprintf(s,msg);
catch
   disp('ERROR: Command not delivered.')
   disp('Check that the device is attached to the serial port.')
end
  

end % function