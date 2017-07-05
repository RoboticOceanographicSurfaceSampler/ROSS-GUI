% kayak_status.m
%
%   Listens to a serial COM port and grabs status information sent  
%   from the kayak raspberry pi.
%
% Usage:
%   From the Matlab command window,  enter:
%      handles=kayak_status('kayak1',handles,fid)
%   where the first argument is the kayak ID 
%   and the second arguments are object handles (output from kayak_plot_init and kayak_connect)
%   the third argument is the file identifier for the output status file
%
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


function [handles] = kayak_status(kayak,handles,fid)


%% check the input arguments for validity
if (nargin~=3),
    disp('Input argument error.');
    disp('Usage:');
    disp('  handles=kayak_status(kayak,handles,fid);')
    disp('     kayak: the kayak ID (e.g. kayak1)');
    disp('     handles: GUI object handles (output from kayak_fig)');
    disp('     fid: the output status file identifier');
    return
end

% get the config file parameters (port, baudrate)
%eval([kayak '_config']);

% initialise the message
msg='';


    
% get the data from the COM port
try
 
      if strcmp(handles.s.Status,'open'),
        %disp('getting message')
        msg=fscanf(handles.s); % get the message
		% print the data to the screen
        fprintf('%s',msg);
      else
        disp('ERROR: 1 - Local antenna serial port not open; check the COM port setting in the config file and the cables.')
        try
            kayak_disconnect(handles.s)
        catch
            disp('No serial ports to close.')
        end
        handles.s=kayak_connect_loop(kayak);
      end
      

       
       % check to see if we received anything at all
       if isempty(msg),
         disp('No status message received - timed out. Check the remote and local antennas, RPi, cables, and RPi transmitting code.')
         try
             kayak_disconnect(handles.s)
         catch
             disp('No serial ports to close.')
         end
         handles.s=kayak_connect_loop(kayak);
       end
           
      
       % clear the serial buffer in case it has backlogged
       flushinput(handles.s);
       
       % update GUI and run all callbacks (send commands)
       drawnow limitrate;  
        
       
catch
      disp('ERROR: 2 - No serial data received; check the local antenna COM port connections and cables.');
      try
          kayak_disconnect(handles.s)
      catch
          disp('No serial ports to disconnect.')
      end
      handles.s=kayak_connect_loop(kayak);
end
    
% continue only if the data have the correct prefix
if strncmp(kayak,msg,length(kayak)),      
       
       % write the data to the file
       fprintf(fid,'%s',[datestr(now) ' ' msg]);
       disp('wrote to file')
       
       % parse the message
       try
           parsed=kayak_parse_message(msg);
       catch
           disp('Could not parse message ...skipping ...')
           return;
       end

       % handle PixHawk status data
       if ~isempty(strfind(msg,' -- stats -- ')),
          %flushinput(s)
          %disp(' -- stats -- ')
          %tic
          expected_fields={'TIME';'LAT';'LON';'ALT';'SATVIS';'ROLL';'PITCH';'YAW';'SP';'HD';'TH';'CURWP'};
          if ~all(ismember(expected_fields,fields(parsed))),
              disp('Line incomplete ...skipping.');
              return;
          end
          kayak_plot_line(handles,parsed);
          kayak_plot_curwp(handles.wayhan,handles.wpchan,parsed);
          kayak_show_current_wp_number(handles,parsed);
          kayak_plot_curloc(handles.curlochan,parsed);
          kayak_show_status(handles,parsed);  
          %toc
       end
       
       
       % handle winch status data
       if ~isempty(strfind(msg,' -- winchstatus -- ')),          
          
          %disp(' -- winchstatus -- ')
          %kayak_plot_winchstatus(handles,parsed)
          expected_fields={'DATE';'STATUS';'Dir';'Rev';'Res';'Spd';'DOWNLOADING'};
          if ~all(ismember(expected_fields,fields(parsed))),
              disp('Line incomplete ...skipping.');
              return;
          end
          handles = kayak_store_winchstatus(handles,parsed);
          kayak_show_winchstatus(handles,parsed);
          kayak_plot_winchstatus(handles);
          
       end

       % handle ctd data
       if ~isempty(strfind(msg,' -- ctd -- ')),
                
           % These next two lines are here for testing purposes.  The
           % routines are ready to go, but we need the right CTD data file.
           %ctddata=kayak_load_ctdfile('C:\Users\ROSS\Documents\CTD\test_ed.txt');
           kayak_plot_ctd(handles,parsed);
       
       end
       
       % handle ctd max pressure data
       if ~isempty(strfind(msg,' -- ctdpressmax -- ')),
                
           % These next two lines are here for testing purposes.  The
           % routines are ready to go, but we need the right CTD data file.
           %ctddata=kayak_load_ctdfile('C:\Users\ROSS\Documents\CTD\test_ed.txt');
           kayak_plot_ctd(handles,parsed);
       
       end
       
       % handle WAYPOINT COUNT data
       % the receipt of this message indicates that a list of waypoints will follow
       % clear all the waypoints from the figure
       if ~isempty(strfind(msg,' -- wpcount -- ')),
          disp('Clearing old waypoints ...')
          %tic
          kayak_clear_waypoints(handles,'final');
          kayak_clear_waypoints(handles,'temp'); 
          disp('Done.')
          %toc
       end
       
       
       
       % handle WAYPOINT data
       if ~isempty(strfind(msg,' -- waypt -- ')),
          %disp(' -- waypt -- ')
          %tic
          expected_fields={'WP';'LAT';'LON';'CUR'};
          if ~all(ismember(expected_fields,fields(parsed))),
              disp('Line incomplete ...skipping.');
              return;
          end
          kayak_plot_waypoint(handles,'final',parsed);
          kayak_show_wplist(handles,'final',parsed);
          %toc
       end
       
       % handle PARAMETER data
       if ~isempty(strfind(msg,' -- param -- ')),
          %disp(' -- param -- ');
          %tic
          try
              parsed=kayak_parse_param_message(msg);
              kayak_display_parameter(handles,parsed);
          catch
              return;
          end
          %toc
       end
       
       
       % give the figure a chance to update the plot
       %pause(0.1);
      
	  
else

       % print the data to the screen
       disp('Incorrect message prefix. Did not try to parse.')
	   
end % if kayak message
    
    


end % function