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

% Last Modified by GUIDE v2.5 14-Mar-2016 17:58:53

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

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes kayak_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


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
wpset='';
kayak_clear_waypoints(handles,'temp');
[wplon,wplat]=getpts(handles.axes1);
for i=1:length(wplon),
  msg.WP=i-1;
  msg.LAT=wplat(i);
  msg.LON=wplon(i);
  kayak_show_wplist(handles,'temp',msg);
  kayak_plot_waypoint(handles,'temp',msg);
  wpset=[wpset ' ' num2str(wplat(i)) ',' num2str(wplon(i))];
end
set(hObject,'UserData',wpset);
%handles.set_wp
%set(handles.set_wp,'Active','yes')


% --- Executes on button press in set_wp.
function set_wp_Callback(hObject, eventdata, handles)
% hObject    handle to set_wp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
wpset=get(handles.select_wp,'UserData');
%kayak=handles.kayak;
%s=handles.s;
command=['goto 0' wpset];
kayak_send_command(handles.kayak,handles.s,command)
command='listwp';
kayak_send_command(handles.kayak,handles.s,command)

% --- Executes on button press in get_wp.
function get_wp_Callback(hObject, eventdata, handles)
% hObject    handle to get_wp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
command='listwp';
kayak_send_command(handles.kayak,handles.s,command)


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



function cursor_lat_Callback(hObject, eventdata, handles)
% hObject    handle to cursor_lat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cursor_lat as text
%        str2double(get(hObject,'String')) returns contents of cursor_lat as a double


% --- Executes during object creation, after setting all properties.
function cursor_lat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cursor_lat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function cursor_lon_Callback(hObject, eventdata, handles)
% hObject    handle to cursor_lon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cursor_lon as text
%        str2double(get(hObject,'String')) returns contents of cursor_lon as a double


% --- Executes during object creation, after setting all properties.
function cursor_lon_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cursor_lon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
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
kayak_show_cursor_position(handles);



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to cursor_lon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cursor_lon as text
%        str2double(get(hObject,'String')) returns contents of cursor_lon as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cursor_lon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
