% main program to run the kayak matlab routines
%
% usage: kayak_main('kayak1')
% where the argument is the kayak ID
%
% jasmine s nahorniak
% march 14 2016

function kayak_main(kayak)


%% check the input arguments for validity
if (nargin~=1),
    disp('Input argument error.');
    disp('Usage:');
    disp('  kayak_main(kayak);')
    disp('     kayak: the kayak ID (e.g. kayak1)');
    return
end

% suppress serial timeout warnings
warning off MATLAB:serial:fscanf:unsuccessfulRead



% close any old instances of the GUI window if they are open from a
% previous run
close(findall(0,'Name','kayak_gui'));

% set up the GUI
disp('Setting up the GUI ...')
hGUI=kayak_gui;
guihandles=guidata(hGUI);
set(guihandles.title,'String',upper(kayak));

% initialise the figure and create handles for reference
guihandles=kayak_plot_init(kayak,guihandles);

% connect to the local antenna on the serial port
guihandles.s=kayak_connect_loop(kayak);

% pass some additional data to the GUI
guihandles.kayak=kayak;
guihandles.hGUI=hGUI;
guidata(hGUI,guihandles);

% send initial commands
% - note: do the listwp command last as it takes the longest
%   (so we don't miss any of the parameter messages received

commands={'getparam WP_RADIUS';'getparam THR_MAX';'getparam THR_MIN';'listwp'};
try
    disp('Getting the current status from the RPi ...')
    guihandles=kayak_status_loop(kayak,guihandles,1);
    disp('Requesting information from the PixHawk ...')
    for c=1:length(commands),
      command=commands{c};
      kayak_send_command(kayak,guihandles.s,command);
      guihandles=kayak_status_loop(kayak,guihandles,10);
    end
catch
    disp('Unable to receive and/or send kayak information.')
end
    
%try    
%   command='getparam WP_RADIUS';
%   kayak_send_command(kayak,guihandles.s,command);
%   command='getparam THR_MAX';
%   kayak_send_command(kayak,guihandles.s,command);
%   command='getparam THR_MIN';
%   kayak_send_command(kayak,guihandles.s,command);
%   command='listwp';
%   kayak_send_command(kayak,guihandles.s,command);
%catch
%    disp('Unable to receive and/or send kayak information.')
%end

% get the status
%try
    guihandles=kayak_status_loop(kayak,guihandles,0);    
%catch
%    disp('Unable to receive kayak status - exiting.')
%end

% close the serial port connection
kayak_disconnect(guihandles.s);

