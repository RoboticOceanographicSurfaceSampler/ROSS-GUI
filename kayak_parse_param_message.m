% parse a param kayak message
%
% usage:
%    parsed=kayak_parse_param_msg(msg)
% where
%    msg: the kayak message
%    parsed : the parsed kayak message
%
% jasmine s nahorniak
% oregon state university
% may 16 2016


function [parsed]=kayak_parse_param_message(msg)

% remove newline characters
msg=regexprep(msg,'\r\n|\r|\n',''); 

% split the string
msgsplit=strsplit(msg,' -- ');

% extract the date
parsed.DATE=msgsplit{3};
parsed.MATDATE=datenum(parsed.DATE,'yyyy/mm/dd HH:MM:SS UTC');

% extract the data or error message
datasplit=strsplit(msgsplit{4},' '); 
parsed.parameter = datasplit{1};
parsed.value = datasplit{2};
for i=1:2:length(datasplit),
      eval(['parsed.' datasplit{i} '=' datasplit{i+1} ';']);
end



