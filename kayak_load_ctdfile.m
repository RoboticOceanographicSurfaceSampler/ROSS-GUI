% loads the CTD data from a file
%
% usage:
%   parsed=kayak_load_ctdfile(file)
% where
%   file: the filename of the CTD text file to be loaded
%   parsed: a structure containing the CTD data
%
%
% jasmine s nahorniak
% Jun 2 2016
% oregon state university

function [parsed]=kayak_load_ctdfile(infile)

% load the CTD data from the text file
k=0;
if (exist(infile,'file')==2),  
  fid=fopen(infile,'r');
  while ~feof(fid),
    dataline=fgetl(fid);
    if length(dataline)>0,
     k=k+1;
     datasplit=strsplit(dataline,'\t');
     mydn=datenum(datasplit{1},'yyyy-mmm-dd HH:MM:SS.FFF');
     parsed(k).DATE=mydn;
     parsed(k).COND=str2num(datasplit{2});
     parsed(k).TEMP=str2num(datasplit{3});
     parsed(k).PRESS=str2num(datasplit{4});
     parsed(k).SEAPRESS=str2num(datasplit{5});
     parsed(k).DEPTH=str2num(datasplit{6});
     parsed(k).SAL=str2num(datasplit{7});
    end
  end
  fclose(fid);

end % if exist

end % function

