function varargout = gui(varargin)
% Last Modified by GUIDE v2.5 06-Apr-2022 13:54:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
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


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function Input_Callback(hObject, eventdata, handles)
in = str2num(get(handles.Input, 'String'));
setappdata(0,'Input',in);

% --- Executes during object creation, after setting all properties.
function Input_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit2_Callback(hObject, eventdata, handles)
  
% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit5_Callback(hObject, eventdata, handles)
in1 = str2num(get(handles.edit5, 'String'));
setappdata(0,'edit_5',in1);

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit6_Callback(hObject, eventdata, handles)
  
% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
  
sd          = getappdata(0, 'edit_5');
Freq        = 12e9;
Sector      = (0.1:0.1:360)';
AmpNoise    = [0 sd];
TestAOA = getappdata(0, 'Input');

N = length(Sector);
Alpha = 2.16;
Temp = gausswin(1800, Alpha);

Lvl = 0.07;
AmpMat(:,1) = [Lvl.*ones(450,1); Temp; Lvl*ones(1350,1)];
AmpMat(:,2) = [Lvl.*ones(1350,1); Temp; Lvl*ones(450,1)];
AmpMat(:,3) = [Temp(1351:end,1); Lvl*ones(1800,1); Temp(1:1350,1)];
AmpMat(:,4) = [Temp(451:end,1); Lvl.*ones(1800,1); Temp(1:450,:)];
NoiseMat = AmpNoise(1) + AmpNoise(2).*randn(N,4);

AmpMat_true = 10*log10(AmpMat);
AmpMat_noisy = 10*log10(AmpMat + NoiseMat);
NoiseMat_dB = AmpMat_noisy - AmpMat_true;

CDFMat_true_0dBmRef = [(Sector-180) AmpMat_true];
CDFMat_true = [(Sector-180) (-60+AmpMat_true)];
CDFMat_noisy = [(Sector-180) (-60+AmpMat_noisy)];
Ref =(TestAOA*10)+1800;

Test_Powers = CDFMat_noisy(Ref,2:5);

i=1;
for c=1:4%traverse through 4 columns (4 antennas)
   Test_Power = Test_Powers(c);
   if Test_Power ~= min(Test_Powers)
       ThreeAntennas(i)=c;
       i=i+1;
   else
       EliminatedAntenna = c;
   end
end

CDFMat_noisy(:,6) = CDFMat_noisy(:,(ThreeAntennas(1)+1))-CDFMat_noisy(:,(ThreeAntennas(2)+1));
CDFMat_noisy(:,7) = CDFMat_noisy(:,(ThreeAntennas(1)+1))-CDFMat_noisy(:,(ThreeAntennas(3)+1));
CDFMat_noisy(:,8) = CDFMat_noisy(:,(ThreeAntennas(2)+1))-CDFMat_noisy(:,(ThreeAntennas(3)+1));

r1 = CDFMat_noisy(Ref,6);
r2 = CDFMat_noisy(Ref,7);
r3 = CDFMat_noisy(Ref,8);

if (r1>0) && (r2>0)
    ClosestAntenna = ThreeAntennas(1);
    if r3>0
        SecondClosestAntenna = ThreeAntennas(2);
    else
        SecondClosestAntenna = ThreeAntennas(3);
    end
elseif (r3>0)
    ClosestAntenna = ThreeAntennas(2);
    if r2>0
        SecondClosestAntenna = ThreeAntennas(1);
    else
        SecondClosestAntenna = ThreeAntennas(3);
    end
else
    ClosestAntenna = ThreeAntennas(3);
    if r2>0
        SecondClosestAntenna = ThreeAntennas(1);
    else
        SecondClosestAntenna = ThreeAntennas(2);
    end
end

Max_power = max([Test_Powers]);
y=CDFMat_noisy(:,ClosestAntenna+1);
% index=find(y == Max_power);
 index=find((y >= (Max_power-0.008)) & (y<=(Max_power+0.008)));
%To identify the exact angle
EstimatedRefs=(index);
min_dif = Max_power - CDFMat_noisy(EstimatedRefs(1),ClosestAntenna+1);
EstimatedRef = EstimatedRefs(1);
for j = 2:length(EstimatedRefs)
    if Max_power - CDFMat_noisy(EstimatedRefs(j),ClosestAntenna+1) < min_dif
        min_dif = Max_power - CDFMat_noisy(EstimatedRefs(j),ClosestAntenna+1);
        EstimatedRef = EstimatedRefs(j);
    end
end
 EstimatedAOA = (EstimatedRef - 1800)/10;

if ClosestAntenna == 4 & EstimatedAOA > 100
    EstimatedAOA = 0 - EstimatedAOA;
end

edit2 = EstimatedAOA;
edit2 = num2str(edit2);
set(handles.edit2,'String',edit2);

sd = getappdata(0, 'edit_5');
Freq        = 12e9;
Sector      = (0.1:0.1:360)';
AmpNoise    = [0 sd];
ConingAngle = 0;
TestAOAs = [-179.9:0.1:180];
Sens        = -72;
ErrorMat = zeros(3600,4);
ErrorSum = zeros(20,1);
%% Block2:  Amplitude profile generation over 360deg Azimuth
N = length(Sector);
Alpha = 2.16;
Temp = gausswin(1800, Alpha);

Lvl = 0.07;
AmpMat(:,1) = [Lvl.*ones(450,1); Temp; Lvl*ones(1350,1)];
AmpMat(:,2) = [Lvl.*ones(1350,1); Temp; Lvl*ones(450,1)];
AmpMat(:,3) = [Temp(1351:end,1); Lvl*ones(1800,1); Temp(1:1350,1)];
AmpMat(:,4) = [Temp(451:end,1); Lvl.*ones(1800,1); Temp(1:450,:)];

for a = 1:10:3600 %3600 angles
    TestAOA = TestAOAs(a);
    Ref = int32((TestAOA*10)+1800);
    for b = 1:20 %20 times

NoiseMat = AmpNoise(1) + AmpNoise(2).*randn(N,4);

AmpMat_true = 10*log10(AmpMat);
AmpMat_noisy = 10*log10(AmpMat + NoiseMat);
NoiseMat_dB = AmpMat_noisy - AmpMat_true;

CDFMat_true_0dBmRef = [(Sector-180) AmpMat_true];
CDFMat_true = [(Sector-180) (-60+AmpMat_true)];
CDFMat_noisy = [(Sector-180) (-60+AmpMat_noisy)];

Test_Powers = CDFMat_noisy(Ref,2:5);

i=1;
for c=1:4%traverse through 4 columns (4 antennas)
   Test_Power = Test_Powers(c);
   if Test_Power ~= min(Test_Powers)
       ThreeAntennas(i)=c;
       i=i+1;
   else
       op1 = sprintf('Eliminating antenna %d ',c);
   end
end
CDFMat_noisy(:,6) = CDFMat_noisy(:,(ThreeAntennas(1)+1))-CDFMat_noisy(:,(ThreeAntennas(2)+1));
CDFMat_noisy(:,7) = CDFMat_noisy(:,(ThreeAntennas(1)+1))-CDFMat_noisy(:,(ThreeAntennas(3)+1));
CDFMat_noisy(:,8) = CDFMat_noisy(:,(ThreeAntennas(2)+1))-CDFMat_noisy(:,(ThreeAntennas(3)+1));

r1 = Test_Powers((ThreeAntennas(1))) - Test_Powers((ThreeAntennas(2)));
r2 = Test_Powers((ThreeAntennas(1))) - Test_Powers((ThreeAntennas(3)));
r3 = Test_Powers((ThreeAntennas(2))) - Test_Powers((ThreeAntennas(3)));

if (r1>0) && (r2>0)
    ClosestAntenna = ThreeAntennas(1);
    if r3>0
        SecondClosestAntenna = ThreeAntennas(2);
    else
        SecondClosestAntenna = ThreeAntennas(3);
    end
elseif (r3>0)
    ClosestAntenna = ThreeAntennas(2);
    if r2>0
        SecondClosestAntenna = ThreeAntennas(1);
    else
        SecondClosestAntenna = ThreeAntennas(3);
    end
else
    ClosestAntenna = ThreeAntennas(3);
    if r2>0
        SecondClosestAntenna = ThreeAntennas(1);
    else
        SecondClosestAntenna = ThreeAntennas(2);
    end
end

%%
AOAVect = CDFMat_noisy(:,1);

%% Estimating AOA

Max_power = max([Test_Powers]);
y=CDFMat_noisy(:,ClosestAntenna+1);
index=find((y >= (Max_power-0.1)) & (y<=(Max_power+0.1)));
%To identify the exact angle
EstimatedRefs=(index);
min_dif = Max_power - CDFMat_noisy(EstimatedRefs(1),ClosestAntenna+1);
EstimatedRef = EstimatedRefs(1);
for j = 2:length(EstimatedRefs)
    if Max_power - CDFMat_noisy(EstimatedRefs(j),ClosestAntenna+1) < min_dif
        min_dif = Max_power - CDFMat_noisy(EstimatedRefs(j),ClosestAntenna+1);
        EstimatedRef = EstimatedRefs(j);
    end
end
 EstimatedAOA = (EstimatedRef - 1800)/10;

if ClosestAntenna == 4 & EstimatedAOA > 100
    EstimatedAOA = 0 - EstimatedAOA;
end

%%
Error = TestAOA - EstimatedAOA;
if Error<-180
    Error = Error + 360;
elseif Error>180
    Error = Error - 360;
end
ErrorMat(a,b) = Error;
% ErrorMat = [ErrorMat;Error];
% ErrorSum(b) = ErrorSum + Error*Error ;
    ErrorSum(b) = ErrorSum(b) + abs(Error) ;
    end
end
MeanError = ErrorSum./3600;
%%
FinalMean = sum(MeanError)/20;
edit6 = FinalMean;
edit6 = num2str(edit6);
set(handles.edit6,'String',edit6);


% --- Executes on button press in pushbutton2.
function pushbutton4_Callback(hObject, eventdata, handles)
sd = getappdata(0, 'edit_5');

Freq        = 12e9;
Sector      = (0.1:0.1:360)';
AmpNoise    = [0 sd];
TestAOA = getappdata(0, 'Input');

N = length(Sector);
Alpha = 2.16;
Temp = gausswin(1800, Alpha);

Lvl = 0.07;
AmpMat(:,1) = [Lvl.*ones(450,1); Temp; Lvl*ones(1350,1)];
AmpMat(:,2) = [Lvl.*ones(1350,1); Temp; Lvl*ones(450,1)];
AmpMat(:,3) = [Temp(1351:end,1); Lvl*ones(1800,1); Temp(1:1350,1)];
AmpMat(:,4) = [Temp(451:end,1); Lvl.*ones(1800,1); Temp(1:450,:)];
NoiseMat = AmpNoise(1) + AmpNoise(2).*randn(N,4);

AmpMat_true = 10*log10(AmpMat);
AmpMat_noisy = 10*log10(AmpMat + NoiseMat);
NoiseMat_dB = AmpMat_noisy - AmpMat_true;

CDFMat_true_0dBmRef = [(Sector-180) AmpMat_true];
CDFMat_true = [(Sector-180) (-60+AmpMat_true)];
CDFMat_noisy = [(Sector-180) (-60+AmpMat_noisy)];
Ref =(TestAOA*10)+1800;

Test_Powers = CDFMat_noisy(Ref,2:5);

i=1;
for c=1:4%traverse through 4 columns (4 antennas)
   Test_Power = Test_Powers(c);
   if Test_Power ~= min(Test_Powers)
       ThreeAntennas(i)=c;
       i=i+1;
   else
       EliminatedAntenna = c;
   end
end

CDFMat_noisy(:,6) = CDFMat_noisy(:,(ThreeAntennas(1)+1))-CDFMat_noisy(:,(ThreeAntennas(2)+1));
CDFMat_noisy(:,7) = CDFMat_noisy(:,(ThreeAntennas(1)+1))-CDFMat_noisy(:,(ThreeAntennas(3)+1));
CDFMat_noisy(:,8) = CDFMat_noisy(:,(ThreeAntennas(2)+1))-CDFMat_noisy(:,(ThreeAntennas(3)+1));

r1 = CDFMat_noisy(Ref,6);
r2 = CDFMat_noisy(Ref,7);
r3 = CDFMat_noisy(Ref,8);

if (r1>0) && (r2>0)
    ClosestAntenna = ThreeAntennas(1);
    if r3>0
        SecondClosestAntenna = ThreeAntennas(2);
    else
        SecondClosestAntenna = ThreeAntennas(3);
    end
elseif (r3>0)
    ClosestAntenna = ThreeAntennas(2);
    if r2>0
        SecondClosestAntenna = ThreeAntennas(1);
    else
        SecondClosestAntenna = ThreeAntennas(3);
    end
else
    ClosestAntenna = ThreeAntennas(3);
    if r2>0
        SecondClosestAntenna = ThreeAntennas(1);
    else
        SecondClosestAntenna = ThreeAntennas(2);
    end
end

Max_power = max([Test_Powers]);
y=CDFMat_noisy(:,ClosestAntenna+1);
% index=find(y == Max_power);
 index=find((y >= (Max_power-0.008)) & (y<=(Max_power+0.008)));
%To identify the exact angle
EstimatedRefs=(index);
min_dif = Max_power - CDFMat_noisy(EstimatedRefs(1),ClosestAntenna+1);
EstimatedRef = EstimatedRefs(1);
for j = 2:length(EstimatedRefs)
    if Max_power - CDFMat_noisy(EstimatedRefs(j),ClosestAntenna+1) < min_dif
        min_dif = Max_power - CDFMat_noisy(EstimatedRefs(j),ClosestAntenna+1);
        EstimatedRef = EstimatedRefs(j);
    end
end
 EstimatedAOA = (EstimatedRef - 1800)/10;

if ClosestAntenna == 4 & EstimatedAOA > 100
    EstimatedAOA = 0 - EstimatedAOA;
end

AOAVect = CDFMat_noisy(:,1);

cla;
axes(handles.axes2);
hold on;
plot(AOAVect,CDFMat_noisy(:,2:5));
plot(TestAOA*ones(1,4), CDFMat_noisy(Ref,2:5), '.', 'linewidth', 2, 'markersize', 40); grid on; hold on; datacursormode on;
xlabel('angle of arrival (in degrees)');
ylabel('power (in dbm)');
title('Amplitude Comparision with 4 Antennas');
legend('Antenna 1','Antenna 2','Antenna 3','Antenna 4','Powers');
axis([-180 180 -75 -60]);
grid on;
