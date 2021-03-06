function varargout = Match(varargin)
% MATCH MATLAB code for Match.fig
%      MATCH, by itself, creates a new MATCH or raises the existing
%      singleton*.
%
%      H = MATCH returns the handle to a new MATCH or the handle to
%      the existing singleton*.
%
%      MATCH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MATCH.M with the given input arguments.
%
%      MATCH('Property','Value',...) creates a new MATCH or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Match_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Match_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Match

% Last Modified by GUIDE v2.5 27-Mar-2020 00:03:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Match_OpeningFcn, ...
                   'gui_OutputFcn',  @Match_OutputFcn, ...
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


% --- Executes just before Match is made visible.
function Match_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Match (see VARARGIN)

% Choose default command line output for Match
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Match wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Match_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in show_image.
function show_image_Callback(hObject, eventdata, handles)
% hObject    handle to show_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global image

global BW
 global img1
 global img3
 global T_Low
 global T_High
 global pan
 global leb
img = imread ('lena.jpg');
axes(handles.axes1);
imshow(img);
title('Original Image');



% --- Executes on button press in thin_image.
function thin_image_Callback(hObject, eventdata, handles)
% hObject    handle to thin_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global BW
 global img1
 global img3
 global T_Low
 global T_High
 global pan
 global leb
 
img1 = imread ('lena.jpg');

img2 = rgb2gray(img1);
img3 = double (img2);

%Value for Thresholding
T_Low = 0.075;
T_High = 0.175;

%Gaussian Filter Coefficient
B = [2, 4, 5, 4, 2; 4, 9, 12, 9, 4;5, 12, 15, 12, 5;4, 9, 12, 9, 4;2, 4, 5, 4, 2 ];
B = 1/159.* B;

%Convolution of image by Gaussian Coefficient
A=conv2(img3, B, 'same');

%Filter for horizontal and vertical direction
KGx = [-1, 0, 1; -2, 0, 2; -1, 0, 1];
KGy = [1, 2, 1; 0, 0, 0; -1, -2, -1];

%Convolution by image by horizontal and vertical filter
Filtered_X = conv2(A, KGx, 'same');
Filtered_Y = conv2(A, KGy, 'same');

%Calculate directions/orientations
arah = atan2 (Filtered_Y, Filtered_X);
arah = arah*180/pi;

pan=size(A,1);
leb=size(A,2);

%Adjustment for negative directions, making all directions positive
for i=1:pan
    for j=1:leb
        if (arah(i,j)<0) 
            arah(i,j)=360+arah(i,j);
        end;
    end;
end;

arah2=zeros(pan, leb);


%Calculate magnitude
magnitude = (Filtered_X.^2) + (Filtered_Y.^2);
magnitude2 = sqrt(magnitude);

BW = zeros (pan, leb);

%Non-Maximum Supression
for i=2:pan-1
    for j=2:leb-1
        if (arah2(i,j)==0)
            BW(i,j) = (magnitude2(i,j) == max([magnitude2(i,j), magnitude2(i,j+1), magnitude2(i,j-1)]));
        elseif (arah2(i,j)==45)
            BW(i,j) = (magnitude2(i,j) == max([magnitude2(i,j), magnitude2(i+1,j-1), magnitude2(i-1,j+1)]));
        elseif (arah2(i,j)==90)
            BW(i,j) = (magnitude2(i,j) == max([magnitude2(i,j), magnitude2(i+1,j), magnitude2(i-1,j)]));
        elseif (arah2(i,j)==135)
            BW(i,j) = (magnitude2(i,j) == max([magnitude2(i,j), magnitude2(i+1,j+1), magnitude2(i-1,j-1)]));
        end;
    end;
end;

BW = BW.*magnitude2;
axes(handles.axes2);
imshow(BW);
title('Thin Edge');
%--------------------------------------------






% --- Executes on button press in final_resolt.
function final_resolt_Callback(hObject, eventdata, handles)
% hObject    handle to final_resolt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
img1 = imread ('lena.jpg');
global BW
 global img1
 global img3
 global T_Low
 global T_High
 global pan
 global leb
img2 = rgb2gray(img1);
T_Low = 0.075;
T_High = 0.175;

img3 = double (img2);
T_Low = T_Low * max(max(BW));
T_High = T_High * max(max(BW));

T_res = zeros (pan, leb);

for i = 1  : pan
    for j = 1 : leb
        if (BW(i, j) < T_Low)
            T_res(i, j) = 0;
        elseif (BW(i, j) > T_High)
            T_res(i, j) = 1;
        %Using 8-connected components
        elseif ( BW(i+1,j)>T_High || BW(i-1,j)>T_High || BW(i,j+1)>T_High || BW(i,j-1)>T_High || BW(i-1, j-1)>T_High || BW(i-1, j+1)>T_High || BW(i+1, j+1)>T_High || BW(i+1, j-1)>T_High)
            T_res(i,j) = 1;
        end;
    end;
end;

edge_final = uint8(T_res.*255);
%Show final edge detection result


axes(handles.axes3);
imshow(edge_final);
title('Final Edge');


% --- Executes on button press in Temp_match.
function Temp_match_Callback(hObject, eventdata, handles)
% hObject    handle to Temp_match (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
I=im2double(imread('lena.jpg'));
 global img1
 global img2
 global img3

T=I(124:140,124:140,:);

[I_SSD,I_NCC]=template_matching(T,I);
[x,y]=find(I_SSD==max(I_SSD(:)));
axes(handles.axes4);
imshow(I); 
hold on;
plot(y,x,'r*');
title(' Eye Match');

axes(handles.axes5);
imshow(T);
title('The eye template');
axes(handles.axes6);
imshow(I_SSD); 
title('SSD Matching' ); 
axes(handles.axes7);
imshow(I_NCC);
title( 'Normalized-CC');
