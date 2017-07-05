% parses the kayak message
%
% usage:
%    parsed = kayak_parse_message(msg)
% where
%    msg: the kayak message
%
% jasmine s nahorniak
% oregon state university
% Feb 26 2016


function [parsed]=kayak_parse_message(msg)

% remove newline characters
msg=regexprep(msg,'\r\n|\r|\n',''); 

% split the string
msgsplit=strsplit(msg,' -- ');

% extract the date
parsed.DATE=msgsplit{3};
parsed.MATDATE=datenum(parsed.DATE,'yyyy/mm/dd HH:MM:SS UTC');

% extract the data or error message
% try splitting by tabs and spaces
datasplit=strsplit(msgsplit{4},{' ','\t'});
if (strcmp('ERROR:',datasplit{1}) | strcmp('Test',datasplit{1})),
  parsed.error=msgsplit{4};
else
  for i=1:2:length(datasplit),
      % remove any colons that might be in the parameter name
      paramname=strrep(datasplit{i},':','');
      paramvalue=datasplit{i+1};
      if isnan(str2double(paramvalue)),
          eval(['parsed.' paramname '=''' paramvalue ''';']);
      else
          eval(['parsed.' paramname '=' paramvalue ';']);
      end
  end
end
