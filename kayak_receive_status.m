% kayak_receive_status.m
%
%   Listens to a serial COM port and grabs status information sent  
%   from the kayak raspberry pi.
%   Runs continuously, outputting the messages to the screen and an output file.
%
% Usage:
%   From the Matlab command window,  enter:
%      kayak_receive_status('kayak1','navigation')
%   where the first argument is the kayak ID and the second argument is the
%   type of status to receive ('navigation' or 'winch')
%
% The output will be a file with a name like kayak_status_kayak1.txt containing all of the messages received.
%
% To stop this code:
%   press ctrl-c at the matlab command prompt
%
% For this code to work you must first
%   (d) Start the transmitting code on the raspberry pi (kayak_main.py)
%
%
% Jasmine S Nahorniak
% November 23, 2015
% revised Dec 7, 2015
% revised Feb 15, 2015 - renamed function
% Oregon State University


function kayak_receive_status(kayak,device)

%% check the input arguments for validity
if ((nargin~=2) ...
        || ~(strcmp(device,'navigation') || strcmp(device,'winch'))),
    disp('Input argument error.');
    disp('Usage:');
    disp('  kayak_receive_status(kayak,device);')
    disp('     kayak: the kayak ID (e.g. kayak1)');
    disp('     device: navigation or winch');    
    return
end

% get the config file parameters (port, baudrate)
eval([kayak '_config']);

% the filename of the text file to store the status messages
statusfile=['kayak_status_' kayak '.txt'];

% initialise the figure and create handles for reference
[linehan,wayhan,wpchan,curlochan]=kayak_plot_init(kayak);

% load and plot any existing data from the status text file
% ** this must be run before opening the output file for writing below
%msgs=kayak_load_file(statusfile);
%kayak_plot_line(linehan,msgs);

% open the output file
fid=fopen(statusfile,'a');

% initialise the message
msg='';

% close any serial ports currently open
% (they may have accidentally been left open if this program was killed)
sold = instrfind();
if ~isempty(sold),
  fclose(sold);
end


% open the serial port
if 1,
try
    s=serial(KAYAK_port);
    set(s,'BaudRate',KAYAK_baudrate);
    set(s,'DataBits',8,'Parity','none','StopBits',1,'FlowControl','none');
    %set(s,'Terminator','LF')
    set(s,'Timeout',30)
    fopen(s);
    disp(KAYAK_baudrate)
catch
    disp('ERROR: Cannot open serial port; check the kayak_serial_config.txt file and the COM port connections.')
    fclose(s);
    delete(s)
    clear s
    return;
end
end

count=0;

% run continuously
while 1  

    % get the data from the COM port
    try
     
       msg=fscanf(s); 
       fprintf('%s',msg);
       pause(1)
       
       % for testing only
       if 0,
       count=count+1;      
       if count<5,
         msg=sprintf('%s\n',['kayak1 -- waypt -- 2016/02/02 13:46:40 UTC -- WP ' num2str(count) ' LAT ' num2str(44.5578288+0.01*count) ' LON ' num2str(-123.2839713+0.01*count) ' CUR 0']);
       elseif count==6,
         msg=sprintf('%s\n',['kayak1 -- stats -- 2016/02/02 13:46:40 UTC -- TIME 426238000 LAT ' num2str(44.558) ' LON ' num2str(-123.261) ' ALT 69.94 SATVIS 11 ROLL 0.026 PITCH -0.217 YAW 2.981 SP 0.219999998808 HD 170 TH 375 CURWP 1']);
       elseif count==7,
         msg=sprintf('%s\n',['kayak1 -- stats -- 2016/02/02 13:46:40 UTC -- TIME 426238000 LAT ' num2str(44.560) ' LON ' num2str(-123.260) ' ALT 69.94 SATVIS 11 ROLL 0.026 PITCH -0.217 YAW 2.981 SP 0.219999998808 HD 170 TH 375 CURWP 1']);
       elseif count==8, 
         msg=sprintf('%s\n',['kayak1 -- stats -- 2016/02/02 13:46:40 UTC -- TIME 426238000 LAT ' num2str(44.562) ' LON ' num2str(-123.259) ' ALT 69.94 SATVIS 11 ROLL 0.026 PITCH -0.217 YAW 2.981 SP 0.219999998808 HD 170 TH 375 CURWP 1']);
       elseif count==9,
         msg=sprintf('%s\n',['kayak1 -- stats -- 2016/02/02 13:46:40 UTC -- TIME 426238000 LAT ' num2str(44.564) ' LON ' num2str(-123.258) ' ALT 69.94 SATVIS 11 ROLL 0.026 PITCH -0.217 YAW 2.981 SP 0.219999998808 HD 170 TH 375 CURWP 1']);
       elseif count==10,
         msg=sprintf('%s\n',['kayak1 -- stats -- 2016/02/02 13:46:40 UTC -- TIME 426238000 LAT ' num2str(44.568) ' LON ' num2str(-123.257) ' ALT 69.94 SATVIS 11 ROLL 0.026 PITCH -0.217 YAW 2.981 SP 0.219999998808 HD 170 TH 375 CURWP 1']);
       else
         msg=sprintf('%s\n',['kayak1 -- stats -- 2016/02/02 13:46:40 UTC -- TIME 426238000 LAT ' num2str(44.568+0.001*count) ' LON ' num2str(-123.257+0.001*count) ' ALT 69.94 SATVIS 11 ROLL 0.026 PITCH -0.217 YAW 2.981 SP 0.219999998808 HD 170 TH 375 CURWP 1']);     
       end
       end  % if for testing
       
       
    catch
      disp('ERROR: No serial data received; check the transmitter code and COM port connections.')
      break;
    end
    
    % continue only if the data have the correct prefix
    if strncmp(kayak,msg,length(kayak)),
       
       % print the data to the screen
       fprintf('%s',msg); 
       
       % write the data to the file
       fprintf(fid,'%s',[datestr(now) ' ' msg]);
           
       % parse the message
       parsed=kayak_parse_message(msg);
            
       % handle STATUS data
       if ~isempty(strfind(msg,' -- stats -- ')),
          kayak_plot_line(linehan,parsed);
          kayak_plot_curwp(wayhan,wpchan,parsed);
          kayak_plot_curloc(curlochan,parsed);
       end
       
       
       % handle WAYPOINT COUNT data
       % the receipt of this message indicates that a list of waypoints will follow
       % clear all the waypoints from the figure
       if ~isempty(strfind(msg,' -- wpcount -- ')),
          kayak_clear_waypoints(wayhan,wpchan);
       end
       
       
       % handle WAYPOINT data
       if ~isempty(strfind(msg,' -- waypt -- ')),
          kayak_plot_waypoint(wayhan,parsed);
       end
       
       
    end 
    
    
  

end % while

fclose(s);
delete(s)
clear s

fclose(fid);

end % function