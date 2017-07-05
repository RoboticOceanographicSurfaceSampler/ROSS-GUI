function varargout = kayak_gui(varargin)
% KAYAK_GUI MATLAB code for kayak_gui.fig
%      KAYAK_GUI, by itself, creates a new KAYAK_GUI or raises the existing
%      singleton*.
%
%      H = KAYAK_GUI returns the handle to a new KAYAK_GUI or the handle to
%      the existing singleton*.
%
%      KAYAK_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in KAYAK_GUI.M with the given input arguments.
%
%      KAYAK_GUI('Property','Value',...) creates a new KAYAK_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before kayak_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to kayak_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help kayak_gui

% Last Modified by GUIDE v2.5 06-May-2017 11:21:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @kayak_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @kayak_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before kayak_gui is made visible.
function kayak_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to kayak_gui (see VARARGIN)

% Choose default command line output for kayak_gui
handles.output = hObject;



% UIWAIT makes kayak_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


%Create tab group
handles.tgroup = uitabgroup('Parent', handles.figure1,'TabLocation', 'top');
handles.tab1 = uitab('Parent', handles.tgroup, 'Title', 'Navigation');
handles.tab2 = uitab('Parent', handles.tgroup, 'Title', 'Winch');
handles.tab3 = uitab('Parent', handles.tgroup, 'Title', 'CTD');

% Update handles structure
% run this after all new handles have been created (else they won't be
% output)
guidata(hObject, handles);

%Place panels into each tab
set(handles.navigation,'Parent',handles.tab1)
set(handles.winch,'Parent',handles.tab2)
set(handles.ctd,'Parent',handles.tab3)

%Reposition each panel to same location as panel 1
mainpos=get(handles.navigation,'position');
set(handles.winch,'position',mainpos);
set(handles.ctd,'position',mainpos);


% --- Outputs from this function are returned to the command line.
function varargout = kayak_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in select_wp.
function select_wp_Callback(hObject, eventdata, handles)
% hObject    handle to select_wp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('selecting waypoints')
wpset='';
kayak_clear_waypoints(handles,'temp');
[wplon,wplat]=getpts(handles.axes1);
for i=1:length(wplon),
  msg.WP=i;
  msg.LAT=wplat(i);
  msg.LON=wplon(i);
  kayak_show_wplist(handles,'temp',msg);
  kayak_plot_waypoint(handles,'temp',msg);
  wpset=[wpset ' ' num2str(wplat(i)) ',' num2str(wplon(i))];
end
set(hObject,'UserData',wpset);
%handles.set_wp
set(handles.set_wp,'Enable','on');


% --- Executes on button press in set_wp.
function set_wp_Callback(hObject, eventdata, handles)
% hObject    handle to set_wp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('setting waypoints')
set(hObject,'Enable','off');
wpset=get(handles.select_wp,'UserData');
kayak_clear_waypoints(handles,'final');
kayak_clear_waypoints(handles,'temp');
kayak_save_waypoints(wpset);
command=['goto 0' wpset];
disp(command)
kayak_send_command(handles.kayak,handles.s,command);
command='setcurwp 1';
disp(command)
kayak_send_command(handles.kayak,handles.s,command);
command='listwp';
disp(command)
kayak_send_command(handles.kayak,handles.s,command);


% --- Executes on button press in get_wp.
function get_wp_Callback(hObject, eventdata, handles)
% hObject    handle to get_wp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.set_wp,'Enable','off');
kayak_clear_waypoints(handles,'final');
kayak_clear_waypoints(handles,'temp');
command='listwp';
kayak_send_command(handles.kayak,handles.s,command);


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end







% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over select_wp.
function select_wp_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to select_wp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on mouse motion over figure - except title and menu.
function figure1_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in winchStartWithCal.
function winchStartWithCal_Callback(hObject, eventdata, handles)
% hObject    handle to winchStartWithCal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
wspeedout = get(handles.winchspeedout,'String');
wspeedin = get(handles.winchspeedin,'String');
wrev = get(handles.winchrevolutions,'String');
wcasts = get(handles.winchcasts,'String');
if (isempty(wspeedout) | isempty(wspeedin) | isempty(wrev) | isempty(wcasts)),
    disp('Error!!! All winch fields must be filled.')
else       
   wc=str2num(wcasts);
   wso=floor(str2num(wspeedout)*(254/100));
   wsi=floor(str2num(wspeedin)*(254/100));
   if wc>0, 
      command=['winch ' num2str(wso) ' ' num2str(wsi) ' ' wrev ' 255 ' wcasts];
      kayak_send_command(handles.kayak,handles.s,command);
   end
end


function winchspeedout_Callback(hObject, eventdata, handles)
% hObject    handle to winchspeedout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of winchspeedout as text
%        str2double(get(hObject,'String')) returns contents of winchspeedout as a double


% --- Executes during object creation, after setting all properties.
function winchspeedout_CreateFcn(hObject, eventdata, handles)
% hObject    handle to winchspeedout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function winchrevolutions_Callback(hObject, eventdata, handles)
% hObject    handle to winchrevolutions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of winchrevolutions as text
%        str2double(get(hObject,'String')) returns contents of winchrevolutions as a double


% --- Executes during object creation, after setting all properties.
function winchrevolutions_CreateFcn(hObject, eventdata, handles)
% hObject    handle to winchrevolutions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in winchReturnSlow.
function winchReturnSlow_Callback(hObject, eventdata, handles)
% hObject    handle to winchReturnSlow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
command=['winch 0 0 0 2 -1']
kayak_send_command(handles.kayak,handles.s,command);

% --- Executes on button press in winchStop.
function winchStop_Callback(hObject, eventdata, handles)
% hObject    handle to winchStop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
command=['winch 0 0 0 4 -1']
kayak_send_command(handles.kayak,handles.s,command);


% --- Executes on button press in startboat.
function startboat_Callback(hObject, eventdata, handles)
% hObject    handle to startboat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
command=['winch 0 0 0 8 -1']
kayak_send_command(handles.kayak,handles.s,command);

% --- Executes on button press in stopboat.
function stopboat_Callback(hObject, eventdata, handles)
% hObject    handle to stopboat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
command=['winch 0 0 0 16 -1']
kayak_send_command(handles.kayak,handles.s,command);


function winchspeedin_Callback(hObject, eventdata, handles)
% hObject    handle to winchspeedin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of winchspeedin as text
%        str2double(get(hObject,'String')) returns contents of winchspeedin as a double


% --- Executes during object creation, after setting all properties.
function winchspeedin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to winchspeedin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in winchReturnFast.
function winchReturnFast_Callback(hObject, eventdata, handles)
% hObject    handle to winchReturnFast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
command=['winch 0 0 0 1 -1']
kayak_send_command(handles.kayak,handles.s,command);



function winchcasts_Callback(hObject, eventdata, handles)
% hObject    handle to winchcasts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of winchcasts as text
%        str2double(get(hObject,'String')) returns contents of winchcasts as a double


% --- Executes during object creation, after setting all properties.
function winchcasts_CreateFcn(hObject, eventdata, handles)
% hObject    handle to winchcasts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function current_wp_Callback(hObject, eventdata, handles)
% hObject    handle to current_wp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of current_wp as text
%        str2double(get(hObject,'String')) returns contents of current_wp as a double


% --- Executes during object creation, after setting all properties.
function current_wp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to current_wp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in set_curr_wp.
function set_curr_wp_Callback(hObject, eventdata, handles)
% hObject    handle to set_curr_wp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cwp = get(handles.current_wp,'String');
if ~isempty(cwp),
  command=['setcurwp ' cwp];
  kayak_send_command(handles.kayak,handles.s,command);
end


% --- Executes on button press in clear_track.
function clear_track_Callback(hObject, eventdata, handles)
% hObject    handle to clear_track (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA
kayak_clear_track(handles.linehan)



function WP_RADIUS_Callback(hObject, eventdata, handles)
% hObject    handle to WP_RADIUS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes during object creation, after setting all properties.
function WP_RADIUS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to WP_RADIUS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in set_wp_radius.
function set_wp_radius_Callback(hObject, eventdata, handles)
% hObject    handle to set_wp_radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
wpr = get(handles.WP_RADIUS,'String');
set(handles.WP_RADIUS,'String','');
if ~isempty(wpr),
  command=['setparam WP_RADIUS ' wpr];
  kayak_send_command(handles.kayak,handles.s,command);
end
command='getparam WP_RADIUS';
kayak_send_command(handles.kayak,handles.s,command);


function THR_MAX_Callback(hObject, eventdata, handles)
% hObject    handle to THR_MAX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function THR_MAX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to THR_MAX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in set_max_throttle.
function set_max_throttle_Callback(hObject, eventdata, handles)
% hObject    handle to set_max_throttle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
thr = get(handles.THR_MAX,'String');
set(handles.THR_MAX,'String','');
if ~isempty(thr),
  command=['setparam THR_MAX ' thr];
  kayak_send_command(handles.kayak,handles.s,command); 
end
command='getparam THR_MAX';
kayak_send_command(handles.kayak,handles.s,command);

% --- Executes on button press in startboat.
function pushbutton21_Callback(hObject, eventdata, handles)
% hObject    handle to startboat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function num_pts_Callback(hObject, eventdata, handles)
% hObject    handle to num_pts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of num_pts as text
%        str2double(get(hObject,'String')) returns contents of num_pts as a double


% --- Executes during object creation, after setting all properties.
function num_pts_CreateFcn(hObject, eventdata, handles)
% hObject    handle to num_pts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in set_num_pts.
function set_num_pts_Callback(hObject, eventdata, handles)
% hObject    handle to set_num_pts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in load_wp.
function load_wp_Callback(hObject, eventdata, handles)
% hObject    handle to load_wp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA
disp('loading waypoints')
wpset='';
kayak_clear_waypoints(handles,'temp');
[wplon,wplat]=kayak_load_waypoints;
for i=1:length(wplon),
  msg.WP=i;
  msg.LAT=wplat(i);
  msg.LON=wplon(i);
  kayak_show_wplist(handles,'temp',msg);
  kayak_plot_waypoint(handles,'temp',msg);
  wpset=[wpset ' ' num2str(wplat(i)) ',' num2str(wplon(i))];
end
set(handles.select_wp,'UserData',wpset);
%handles.set_wp
set(handles.set_wp,'Enable','on');


function param_name_Callback(hObject, eventdata, handles)
% hObject    handle to param_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of param_name as text
%        str2double(get(hObject,'String')) returns contents of param_name as a double


% --- Executes during object creation, after setting all properties.
function param_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to param_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function param_value_Callback(hObject, eventdata, handles)
% hObject    handle to param_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of param_value as text
%        str2double(get(hObject,'String')) returns contents of param_value as a double


% --- Executes during object creation, after setting all properties.
function param_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to param_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in set_param.
function set_param_Callback(hObject, eventdata, handles)
% hObject    handle to set_param (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
custom_param = get(handles.param_name,'String');
custom_value = get(handles.param_value,'String');
set(handles.param_value,'String','');
if (~isempty(custom_param) && ~isempty(custom_value)),
  command=['setparam ' custom_param ' ' custom_value];
  kayak_send_command(handles.kayak,handles.s,command); 
end
command=['getparam ' custom_param];
kayak_send_command(handles.kayak,handles.s,command);



function winchcommand_Callback(hObject, eventdata, handles)
% hObject    handle to winchcommand (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of winchcommand as text
%        str2double(get(hObject,'String')) returns contents of winchcommand as a double


% --- Executes during object creation, after setting all properties.
function winchcommand_CreateFcn(hObject, eventdata, handles)
% hObject    handle to winchcommand (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on num_pts and none of its controls.
function num_pts_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to num_pts (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)




function ctdnumcasts_Callback(hObject, eventdata, handles)
% hObject    handle to ctdnumcasts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ctdnumcasts as text
%        str2double(get(hObject,'String')) returns contents of ctdnumcasts as a double


% --- Executes during object creation, after setting all properties.
function ctdnumcasts_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ctdnumcasts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in winchSendCommand.
function winchSendCommand_Callback(hObject, eventdata, handles)
% hObject    handle to winchSendCommand (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
wspeedout = get(handles.winchspeedout,'String');
wspeedin = get(handles.winchspeedin,'String');
wrev = get(handles.winchrevolutions,'String');
wcasts = get(handles.winchcasts,'String');
wdownload = get(handles.download_ctd,'Value');
wstraightcal = get(handles.winchstraightres,'String');
wbentcal = get(handles.winchbentres,'String');
if (isempty(wspeedout) | isempty(wspeedin) | isempty(wrev) | isempty(wcasts)),
    disp('Error!!! All winch fields must be filled.')
elseif (isempty(wstraightcal) | isempty(wbentcal)),
    disp('Error!!! Fishing rod calibration has not been done.')
else       
   wc=str2num(wcasts);
   wso=floor(str2num(wspeedout)*(254/100));
   wsi=floor(str2num(wspeedin)*(254/100));
   if wc>0, 
      command=['winch ' num2str(wso) ' ' num2str(wsi) ' ' wrev ' 0 ' wcasts ' ' num2str(wdownload)];
      disp(command)
      kayak_send_command(handles.kayak,handles.s,command);
   end
end











function GROUND_SPD_Callback(hObject, eventdata, handles)
% hObject    handle to GROUND_SPD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of GROUND_SPD as text
%        str2double(get(hObject,'String')) returns contents of GROUND_SPD as a double


% --- Executes during object creation, after setting all properties.
function GROUND_SPD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GROUND_SPD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in set_ground_speed.
function set_ground_speed_Callback(hObject, eventdata, handles)
% hObject    handle to set_ground_speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gspeed = get(handles.GROUND_SPD,'String');
command=['setspeed ' gspeed];
kayak_send_command(handles.kayak,handles.s,command);



function num_winch_pts_Callback(hObject, eventdata, handles)
% hObject    handle to num_winch_pts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of num_winch_pts as text
%        str2double(get(hObject,'String')) returns contents of num_winch_pts as a double


% --- Executes during object creation, after setting all properties.
function num_winch_pts_CreateFcn(hObject, eventdata, handles)
% hObject    handle to num_winch_pts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in exit.
function exit_Callback(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
kayak_close_all_ports;
guifig=findall(0,'Name','kayak_gui');
close(guifig)


% --- Executes on button press in get_curr_wp.
function get_curr_wp_Callback(hObject, eventdata, handles)
% hObject    handle to get_curr_wp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in get_wp_radius.
function get_wp_radius_Callback(hObject, eventdata, handles)
% hObject    handle to get_wp_radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.WP_RADIUS,'String','');
command=['getparam WP_RADIUS'];
kayak_send_command(handles.kayak,handles.s,command); 

% --- Executes on button press in get_max_throttle.
function get_max_throttle_Callback(hObject, eventdata, handles)
% hObject    handle to get_max_throttle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.THR_MAX,'String','');
command=['getparam THR_MAX'];
kayak_send_command(handles.kayak,handles.s,command); 

% --- Executes on button press in get_ground_speed.
function get_ground_speed_Callback(hObject, eventdata, handles)
% hObject    handle to get_ground_speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in get_param.
function get_param_Callback(hObject, eventdata, handles)
% hObject    handle to get_param (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
custom_param = get(handles.param_name,'String');
set(handles.param_value,'String','');
if (~isempty(custom_param)),
  command=['getparam ' custom_param];
  kayak_send_command(handles.kayak,handles.s,command); 
end


% --- Executes on button press in winchMinCal.
function winchMinCal_Callback(hObject, eventdata, handles)
% hObject    handle to winchMinCal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
command='winchcal min';
kayak_send_command(handles.kayak,handles.s,command);


% --- Executes on button press in winchMaxCal.
function winchMaxCal_Callback(hObject, eventdata, handles)
% hObject    handle to winchMaxCal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
command='winchcal max';
kayak_send_command(handles.kayak,handles.s,command);


% --- Executes on button press in winchSetpointCal.
function winchSetpointCal_Callback(hObject, eventdata, handles)
% hObject    handle to winchSetpointCal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
command='winchcal setpoint';
kayak_send_command(handles.kayak,handles.s,command);


function winchstraightres_Callback(hObject, eventdata, handles)
% hObject    handle to winchstraightres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of winchstraightres as text
%        str2double(get(hObject,'String')) returns contents of winchstraightres as a double


% --- Executes during object creation, after setting all properties.
function winchstraightres_CreateFcn(hObject, eventdata, handles)
% hObject    handle to winchstraightres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function winchbentres_Callback(hObject, eventdata, handles)
% hObject    handle to winchbentres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of winchbentres as text
%        str2double(get(hObject,'String')) returns contents of winchbentres as a double


% --- Executes during object creation, after setting all properties.
function winchbentres_CreateFcn(hObject, eventdata, handles)
% hObject    handle to winchbentres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function winchsetpointres_Callback(hObject, eventdata, handles)
% hObject    handle to winchsetpointres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of winchsetpointres as text
%        str2double(get(hObject,'String')) returns contents of winchsetpointres as a double


% --- Executes during object creation, after setting all properties.
function winchsetpointres_CreateFcn(hObject, eventdata, handles)
% hObject    handle to winchsetpointres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in setwinchstraightres.
function setwinchstraightres_Callback(hObject, eventdata, handles)
% hObject    handle to setwinchstraightres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
res = get(handles.winchstraightres,'String');
fres = num2str(floor(str2num(res)));
command=['winchset straight ' fres];
kayak_send_command(handles.kayak,handles.s,command);


% --- Executes on button press in setwinchbentres.
function setwinchbentres_Callback(hObject, eventdata, handles)
% hObject    handle to setwinchbentres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
res = get(handles.winchbentres,'String'); 
fres = num2str(floor(str2num(res)));
command=['winchset bent ' fres];
kayak_send_command(handles.kayak,handles.s,command);


% --- Executes on button press in setwinchsetpointres.
function setwinchsetpointres_Callback(hObject, eventdata, handles)
% hObject    handle to setwinchsetpointres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
res = get(handles.winchsetpointres,'String'); 
fres = num2str(floor(str2num(res)));
command=['winchset setpoint ' fres];
kayak_send_command(handles.kayak,handles.s,command);


% --- Executes on button press in CTDdownload.
function CTDdownload_Callback(hObject, eventdata, handles)
% hObject    handle to CTDdownload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
command=['ctd download'];
kayak_send_command(handles.kayak,handles.s,command);


% --- Executes on slider movement.
function steering_slider_Callback(hObject, eventdata, handles)
% hObject    handle to steering_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
steeringon = get(handles.steering_on,'Value');
if steeringon,
    sliderpos = floor(abs(get(handles.steering_slider,'Value')));
    command=['servo ' num2str(sliderpos)];
    disp(command)
    kayak_send_command(handles.kayak,handles.s,command);
end

% --- Executes during object creation, after setting all properties.
function steering_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to steering_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton75.
function pushbutton75_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton75 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in steering_on.
function steering_on_Callback(hObject, eventdata, handles)
% hObject    handle to steering_on (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of steering_on
steeringon = get(handles.steering_on,'Value');
if steeringon,
    sliderpos = floor(abs(get(handles.steering_slider,'Value')));
    command=['servo ' num2str(sliderpos)];
    disp(command)
    kayak_send_command(handles.kayak,handles.s,command);
else
    command=['servo 70'];
    disp(command)
    kayak_send_command(handles.kayak,handles.s,command);
end


% --- Executes on button press in check_bottom.
function check_bottom_Callback(hObject, eventdata, handles)
% hObject    handle to check_bottom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_bottom
