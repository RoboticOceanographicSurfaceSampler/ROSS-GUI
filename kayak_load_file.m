% loads the kayak status information from a file
%
% usage:
%   parsed=kayak_load_file(file)
% where
%   file: the filename of the kayak status text file to be loaded
%   parsed: a structure containing the status data
%
%
% jasmine s nahorniak
% Feb 26 2016
% oregon state university

function [parsed]=kayak_load_file(statusfile)

% load the existing status data from the text file
k=0;
if (exist(statusfile,'file')==2),
  
  fid=fopen(statusfile,'r');
    while ~feof(fid),
     msg=fgetl(fid);
     if ~isempty(strfind(msg,' -- stats -- ')),
       k=k+1;
       msgsplit=strsplit(msg,' -- ');
       datasplit=strsplit(msgsplit{4},' ');
       for i=1:2:length(datasplit),
         eval(['parsed(k).' datasplit{i} '=' datasplit{i+1} ';']);
       end
     end
    end
  fclose(fid);

end % if exist

end % function

