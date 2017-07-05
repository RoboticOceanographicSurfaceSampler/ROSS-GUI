% kayak_status_loop.m
%
%   Listens to a serial COM port and grabs status information sent  
%   from the kayak raspberry pi.
%
% Usage:
%   From the Matlab command window,  enter:
%      handles=kayak_status_loop('kayak1',handles,numloops)
%   where the first argument is the kayak ID 
%   the second arguments are object handles (output from kayak_plot_init and kayak_connect)
%   and the final argument is the number of loops to make (set to 0 for and
%   infinite loop)
% The output argument is the serial object (which may change if connection
% is lost)
%
% The output will be a file with a name like kayak_status_kayak1.txt containing all of the messages received.
%
%
% For this code to work you must first
%   (d) Start the transmitting code on the raspberry pi (kayak_main.py)
%
%
% Jasmine S Nahorniak
% November 23, 2015
% revised Dec 7, 2015
% revised Feb 15, 2015 - renamed function
% revised Jul 6 2016 - made more robust to serial connection losses
% Oregon State University


function [handles]=kayak_status_loop(kayak,handles,numloops)



%% check the input arguments for validity
if (nargin~=3),
    disp('Input argument error.');
    disp('Usage:');
    disp('  kayak_status_loop(kayak,handles,numloops);')
    disp('     kayak: the kayak ID (e.g. kayak1)');
    disp('     handles: GUI object handles (output from kayak_fig)'); 
    disp('     numloops: the number of loops to run (0 for infinite))'); 
    return
end

% get the config file parameters (port, baudrate)
%eval([kayak '_config']);

statusfile=['kayak_status_' kayak '.txt'];

% load and plot any existing data from the status text file
% ** this must be run before opening the output file for writing below
%msgs=kayak_load_file(statusfile);
%kayak_plot_line(linehan,msgs);

% open the output file
fid=fopen(statusfile,'a');

% run continuously until numloops is reached
count=0;
keepgoing=1;
while keepgoing,  
   
    handles=kayak_status(kayak,handles,fid);
    guidata(handles.hGUI,handles);
    if numloops~=0,
        count=count+1;
        if count>=numloops,
            keepgoing=0;
        end
    end
      
end % while


fclose(fid);

end % function