function varargout = Parameter_Eingabemaske(varargin)
% PARAMETER_EINGABEMASKE MATLAB code for Parameter_Eingabemaske.fig
%      PARAMETER_EINGABEMASKE, by itself, creates a new PARAMETER_EINGABEMASKE or raises the existing
%      singleton*.
%
%      H = PARAMETER_EINGABEMASKE returns the handle to a new PARAMETER_EINGABEMASKE or the handle to
%      the existing singleton*.
%
%      PARAMETER_EINGABEMASKE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PARAMETER_EINGABEMASKE.M with the given input arguments.
%
%      PARAMETER_EINGABEMASKE('Property','Value',...) creates a new PARAMETER_EINGABEMASKE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Parameter_Eingabemaske_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Parameter_Eingabemaske_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Parameter_Eingabemaske

% Last Modified by GUIDE v2.5 28-Sep-2020 19:49:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Parameter_Eingabemaske_OpeningFcn, ...
                   'gui_OutputFcn',  @Parameter_Eingabemaske_OutputFcn, ...
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


% --- Executes just before Parameter_Eingabemaske is made visible.
function Parameter_Eingabemaske_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Parameter_Eingabemaske (see VARARGIN)

% Choose default command line output for Parameter_Eingabemaske
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Parameter_Eingabemaske wait for user response (see UIRESUME)
% uiwait(handles.figure1);
uiwait
% --- Outputs from this function are returned to the command line.
function varargout = Parameter_Eingabemaske_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
%varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

assignin('base','temperatur',str2num(get(handles.edit_Umgebungstemperatur,'string')));
assignin('base','taupunkt',str2num(get(handles.edit_Taupunkt,'string')));
assignin('base','luftdruck',str2num(get(handles.edit_Umgebungsdruck,'string')));

assignin('base','fzHoehe',str2num(get(handles.edit_Fahrzeughoehe,'string')));
assignin('base','podesthoehe',str2num(get(handles.edit_Podesthoehe,'string')));
assignin('base','fzBreite',str2num(get(handles.edit_Breite,'string')));
assignin('base','fzBreiteInklSpiegel',str2num(get(handles.edit_Breite_mitSpiegel,'string')));

assignin('base','M_bus',str2num(get(handles.edit_MasseFahrzeug,'string')));
assignin('base','M_fahrgast',str2num(get(handles.edit_MasseFahrgast,'string')));

assignin('base','g',str2num(get(handles.edit_Erdbeschleunigung,'string')));
assignin('base','R_Reifen',str2num(get(handles.edit_RadiusReifen,'string')));

assignin('base','c_r',str2num(get(handles.edit_Rollwiderstandsbeiwert,'string')));
assignin('base','c_d',str2num(get(handles.edit_Luftwiderstandsbeiwert,'string')));

assignin('base','lambda',str2num(get(handles.edit_AequivalenteMasse,'string')));

assignin('base','i_getriebe',str2num(get(handles.tag_i_getriebe,'string')));
assignin('base','eta_getriebe',str2num(get(handles.tag_eta_getriebe,'string')));
assignin('base','i_mainreducer',str2num(get(handles.tag_i_mainreducer,'string')));


if handles.radiobutton1.Value == 1
  % dann lade unsere Fahrgastdaten aus Tabelle!! --> Muss noch ergänzt werden!
else
  assignin('base','Anzahl_Fahrgaeste',randi(30,1,1));
end
msgfig = msgbox('Variablen importiert. Bitte schließend Sie das Fenster, um fortzufahren.','Success','modal');


function edit_Umgebungstemperatur_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Umgebungstemperatur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% temperatur = get(handles.edit_Umgebungstemperatur,'Value');
% guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of edit_Umgebungstemperatur as text
%        str2double(get(hObject,'String')) returns contents of edit_Umgebungstemperatur as a double


% --- Executes during object creation, after setting all properties.
function edit_Umgebungstemperatur_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Umgebungstemperatur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_MasseFahrzeug_Callback(hObject, eventdata, handles)
% hObject    handle to edit_MasseFahrzeug (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_MasseFahrzeug as text
%        str2double(get(hObject,'String')) returns contents of edit_MasseFahrzeug as a double


% --- Executes during object creation, after setting all properties.
function edit_MasseFahrzeug_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MasseFahrzeug (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_MasseFahrgast_Callback(hObject, eventdata, handles)
% hObject    handle to edit_MasseFahrgast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_MasseFahrgast as text
%        str2double(get(hObject,'String')) returns contents of edit_MasseFahrgast as a double


% --- Executes during object creation, after setting all properties.
function edit_MasseFahrgast_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MasseFahrgast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_AnzahlFahrgaeste_Callback(hObject, eventdata, handles)
% hObject    handle to edit_AnzahlFahrgaeste (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_AnzahlFahrgaeste as text
%        str2double(get(hObject,'String')) returns contents of edit_AnzahlFahrgaeste as a double


% --- Executes during object creation, after setting all properties.
function edit_AnzahlFahrgaeste_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_AnzahlFahrgaeste (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Erdbeschleunigung_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Erdbeschleunigung (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Erdbeschleunigung as text
%        str2double(get(hObject,'String')) returns contents of edit_Erdbeschleunigung as a double


% --- Executes during object creation, after setting all properties.
function edit_Erdbeschleunigung_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Erdbeschleunigung (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_RadiusReifen_Callback(hObject, eventdata, handles)
% hObject    handle to edit_RadiusReifen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_RadiusReifen as text
%        str2double(get(hObject,'String')) returns contents of edit_RadiusReifen as a double


% --- Executes during object creation, after setting all properties.
function edit_RadiusReifen_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_RadiusReifen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Rollwiderstandsbeiwert_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Rollwiderstandsbeiwert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Rollwiderstandsbeiwert as text
%        str2double(get(hObject,'String')) returns contents of edit_Rollwiderstandsbeiwert as a double


% --- Executes during object creation, after setting all properties.
function edit_Rollwiderstandsbeiwert_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Rollwiderstandsbeiwert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Luftwiderstandsbeiwert_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Luftwiderstandsbeiwert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Luftwiderstandsbeiwert as text
%        str2double(get(hObject,'String')) returns contents of edit_Luftwiderstandsbeiwert as a double


% --- Executes during object creation, after setting all properties.
function edit_Luftwiderstandsbeiwert_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Luftwiderstandsbeiwert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_AequivalenteMasse_Callback(hObject, eventdata, handles)
% hObject    handle to edit_AequivalenteMasse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_AequivalenteMasse as text
%        str2double(get(hObject,'String')) returns contents of edit_AequivalenteMasse as a double


% --- Executes during object creation, after setting all properties.
function edit_AequivalenteMasse_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_AequivalenteMasse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Breite_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Breite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Breite as text
%        str2double(get(hObject,'String')) returns contents of edit_Breite as a double


% --- Executes during object creation, after setting all properties.
function edit_Breite_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Breite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Breite_mitSpiegel_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Breite_mitSpiegel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Breite_mitSpiegel as text
%        str2double(get(hObject,'String')) returns contents of edit_Breite_mitSpiegel as a double


% --- Executes during object creation, after setting all properties.
function edit_Breite_mitSpiegel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Breite_mitSpiegel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Podesthoehe_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Podesthoehe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Podesthoehe as text
%        str2double(get(hObject,'String')) returns contents of edit_Podesthoehe as a double


% --- Executes during object creation, after setting all properties.
function edit_Podesthoehe_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Podesthoehe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Fahrzeughoehe_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Fahrzeughoehe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Fahrzeughoehe as text
%        str2double(get(hObject,'String')) returns contents of edit_Fahrzeughoehe as a double


% --- Executes during object creation, after setting all properties.
function edit_Fahrzeughoehe_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Fahrzeughoehe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Taupunkt_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Taupunkt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Taupunkt as text
%        str2double(get(hObject,'String')) returns contents of edit_Taupunkt as a double


% --- Executes during object creation, after setting all properties.
function edit_Taupunkt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Taupunkt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Umgebungsdruck_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Umgebungsdruck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Umgebungsdruck as text
%        str2double(get(hObject,'String')) returns contents of edit_Umgebungsdruck as a double


% --- Executes during object creation, after setting all properties.
function edit_Umgebungsdruck_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Umgebungsdruck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1


% --- Executes on button press in fahrzyklusAuswaehlen.
function fahrzyklusAuswaehlen_Callback(hObject, eventdata, handles)
[fileName, filePath] = uigetfile;
assignin('base','fahrzyklusDateiPfad', fullfile(filePath,fileName));
% hObject    handle to fahrzyklusAuswaehlen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function tag_i_getriebe_Callback(hObject, eventdata, handles)
% hObject    handle to tag_i_getriebe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tag_i_getriebe as text
%        str2double(get(hObject,'String')) returns contents of tag_i_getriebe as a double


% --- Executes during object creation, after setting all properties.
function tag_i_getriebe_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tag_i_getriebe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tag_eta_getriebe_Callback(hObject, eventdata, handles)
% hObject    handle to tag_eta_getriebe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tag_eta_getriebe as text
%        str2double(get(hObject,'String')) returns contents of tag_eta_getriebe as a double


% --- Executes during object creation, after setting all properties.
function tag_eta_getriebe_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tag_eta_getriebe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tag_i_mainreducer_Callback(hObject, eventdata, handles)
% hObject    handle to tag_i_mainreducer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tag_i_mainreducer as text
%        str2double(get(hObject,'String')) returns contents of tag_i_mainreducer as a double


% --- Executes during object creation, after setting all properties.
function tag_i_mainreducer_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tag_i_mainreducer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on button press in tag_diesel.
function tag_diesel_Callback(hObject, eventdata, handles)
% hObject    handle to tag_diesel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit_Fahrzeughoehe,'String','3300');
set(handles.edit_Podesthoehe,'String','310');
set(handles.edit_MasseFahrzeug,'String','12000');
set(handles.tag_i_getriebe,'String','4.9, 1.36, 1.0, 0.73');
set(handles.tag_eta_getriebe,'string','0.7,0.96,0.94,0.93');
set(handles.tag_i_mainreducer,'string','9.81');
assignin('base','model_selection',1);
% Hint: get(hObject,'Value') returns toggle state of tag_diesel


% --- Executes on button press in tag_elektro.
function tag_elektro_Callback(hObject, eventdata, handles)
% hObject    handle to tag_elektro (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit_Fahrzeughoehe,'String','3400');
set(handles.edit_Podesthoehe,'string','320');
set(handles.edit_MasseFahrzeug,'string','14000');
set(handles.tag_i_getriebe,'string','22.6');
set(handles.tag_eta_getriebe,'string','0.94');
set(handles.tag_i_mainreducer,'string','1');
assignin('base','model_selection',0);
% Hint: get(hObject,'Value') returns toggle state of tag_elektro
