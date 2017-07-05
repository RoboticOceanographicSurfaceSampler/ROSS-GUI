
% kayak_connect.m
%
%   Opens a serial COM port connection.
%
% Usage:
%   From the Matlab command window,  enter:
%      kayak_connect('kayak1')
%   where the argument is the kayak ID 
%
% The output will be the serial connection ID.
%
%
%
% Jasmine S Nahorniak
% March 14, 2016
% Oregon State University


function [s]=kayak_connect(kayak)


%% check the input arguments for validity
if (nargin~=1),
    disp('Input argument error.');
    disp('Usage:');
    disp('  kayak_connect(kayak);')
    disp('     kayak: the kayak ID (e.g. kayak1)'); 
    return
end

% get the config file parameters (port, baudrate)
eval([kayak '_config']);


% load and plot any existing data from the status text file
% ** this must be run before opening the output file for writing below
%msgs=kayak_load_file(statusfile);
%kayak_plot_line(linehan,msgs);

% close any serial ports currently open
% (they may have accidentally been left open if this program was killed)
kayak_close_all_ports;


% open the serial port
if 1,
try
    s=serial(KAYAK_port);
    set(s,'BaudRate',KAYAK_baudrate);
    set(s,'DataBits',8,'Parity','none','StopBits',1,'FlowControl','none');
    %set(s,'Terminator','LF')
    set(s,'Timeout',10) 
    fopen(s);
catch
    disp('ERROR: Cannot open serial port; check the kayak_serial_config.txt file, the COM port connections, and cables.')
    fclose(s);
    delete(s)
    clear s;
    return;
end
end




end % function