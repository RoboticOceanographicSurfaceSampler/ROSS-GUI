% saves kayak waypoints to an ASCII text file
% the contents will be two columns:
%    lat lon
% with no headings
%
% usage:
%    kayak_save_waypoints(wpset);
% where
%    wpset is a single string of space-separated lat,lon pairs
%
% jasmine s nahorniak
% oregon state university
% march 14 2016



function kayak_save_waypoints(wpset)

timestamp=datestr(now,'yyyymmdd_HHMMSS');
outfile=['waypoints\waypoints_' timestamp '.txt'];

% open the output file
fid=fopen(outfile,'w');

% make sure we can write to the file or give an error
if (fid==-1),
    disp(['Error writing to waypoints file ' outfile]);
else
    
data=regexp(wpset,'\s','split');
for i=2:length(data),
    fprintf(fid,'%s\r\n',data{i});
end
fclose(fid);

end