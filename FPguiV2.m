function varargout = FPguiV2(varargin)
% FPGUIV2 MATLAB code for FPguiV2.fig
%      FPGUIV2, by itself, creates a new FPGUIV2 or raises the existing
%      singleton*.
%
%      H = FPGUIV2 returns the handle to a new FPGUIV2 or the handle to
%      the existing singleton*.
%
%      FPGUIV2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FPGUIV2.M with the given input arguments.
%
%      FPGUIV2('Property','Value',...) creates a new FPGUIV2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FPguiV2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FPguiV2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FPguiV2

% Last Modified by GUIDE v2.5 26-May-2022 19:20:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FPguiV2_OpeningFcn, ...
                   'gui_OutputFcn',  @FPguiV2_OutputFcn, ...
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


% --- Executes just before FPguiV2 is made visible.
function FPguiV2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FPguiV2 (see VARARGIN)

% Choose default command line output for FPguiV2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FPguiV2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FPguiV2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in load.
function load_Callback(hObject, eventdata, handles)
% hObject    handle to load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dataset = readcell('ahp_alts.xlsx', 'Range', 'A2:D22');
header = readcell('ahp_alts.xlsx', 'Range', 'A1:D1');

set(handles.table, 'Data', dataset, 'ColumnName', header);

% --- Executes on button press in calc.
function calc_Callback(hObject, eventdata, handles)
% hObject    handle to calc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dataset = xlsread('ahp_alts.xlsx','Sheet1','B2:D22');
dataName = readcell('ahp_alts.xlsx','Range','A2:A22');

c1 = zeros(21,1);
c2 = zeros(21,1);
c3 = zeros(21,1);

for i=1:21,
    if dataset(i,3) == 0
        c1(i,1) = dataset(1,1) / dataset(i,1);
        c2(i,1) = dataset(1,2) / dataset(i,2);
        c3(i,1) = 0; 
    else
        c1(i,1) = dataset(1,1) / dataset(i,1);
        c2(i,1) = dataset(1,2) / dataset(i,2);
        c3(i,1) = dataset(1,3) / dataset(i,3); 
    end
end;

c1_nor = calc_norm(c1);
c2_nor = calc_norm(c2);
c3_nor = calc_norm(c3);

c12 = str2double(get(handles.c12,'string'));
c13 = str2double(get(handles.c13,'string'));
c23 = str2double(get(handles.c23,'string'));

MPB = [1, c12, c13;
       1/c12, 1 ,c23;
       1/c13, 1/c23, 1];
   
   
MPBw = calc_norm(MPB);
[m n] = size(MPBw);
for i=1:m,
    sumRow = 0;
    for j=1:n,
        sumRow = sumRow + MPBw(i,j);
    end;
    V(i) = (sumRow);
end;
MPBw = transpose(V)/m;

wM = [c1_nor c2_nor c3_nor];
MC_scores = wM * MPBw;
[maxValue maxIndex] = max(MC_scores);

set(handles.resOutput,'string',dataName(maxIndex));
set(handles.resValue,'string',maxValue);


function [normvect ] = calc_norm(M)
    sM = sum(M);
    normvect = M./sM;


function c12_Callback(hObject, eventdata, handles)
% hObject    handle to c12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of c12 as text
%        str2double(get(hObject,'String')) returns contents of c12 as a double


% --- Executes during object creation, after setting all properties.
function c12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function w2_Callback(hObject, eventdata, handles)
% hObject    handle to w2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of w2 as text
%        str2double(get(hObject,'String')) returns contents of w2 as a double


% --- Executes during object creation, after setting all properties.
function w2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to w2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function w3_Callback(hObject, eventdata, handles)
% hObject    handle to w3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of w3 as text
%        str2double(get(hObject,'String')) returns contents of w3 as a double


% --- Executes during object creation, after setting all properties.
function w3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to w3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c23_Callback(hObject, eventdata, handles)
% hObject    handle to c23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of c23 as text
%        str2double(get(hObject,'String')) returns contents of c23 as a double


% --- Executes during object creation, after setting all properties.
function c23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c13_Callback(hObject, eventdata, handles)
% hObject    handle to c13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of c13 as text
%        str2double(get(hObject,'String')) returns contents of c13 as a double


% --- Executes during object creation, after setting all properties.
function c13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
