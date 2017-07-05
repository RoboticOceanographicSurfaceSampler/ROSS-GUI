% kayak_close_all_ports
% closes any serial ports currently open

sold = instrfind();
if ~isempty(sold),
  fclose(sold);
  delete(sold);
end
clear sold;