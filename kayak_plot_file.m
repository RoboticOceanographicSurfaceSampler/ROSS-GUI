% plots the kayak status information from a file
%
% usage:
%   kayak_plot_file(linehan,file)
% where
%   linehan: the handle to the line to be updated on the figure
%   file: the filename of the kayak status text file to be loaded
%
% requires kayak_plot_init.m to be run first to create the figure
%
% jasmine s nahorniak
% Dec 2015
% revised Feb 15 2016
% oregon state university

function kayak_plot_file(linehan,statusfile)

% load the existing data from the text file
k=0;
if (exist(statusfile,'file')==2),
  fid=fopen(statusfile,'r');
    while ~feof(fid),
     k=k+1;
     msg=fgetl(fid);
     msgsplit=strsplit(msg,' -- ');
     datasplit=strsplit(msgsplit{4},' ');
     for i=1:2:length(datasplit),
       eval(['parsed(k).' datasplit{i} '=' datasplit{i+1} ';']);
     end
    end
  fclose(fid);
  
  % update the X and Y data values in the plots
  kayak_plot_line(linehan,parsed)
  


end % if exist
end % function

