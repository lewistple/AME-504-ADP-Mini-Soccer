%% Y-Rotation Geometry Calculator

%% Clear

clear, clc, close all;

%% UI Setup

fig = uifigure('Position', [300, 300, 1000, 700]);
ax = uiaxes(fig, 'Position', [100, 200, 600, 450]);

%-------------------------------*
% Numeric Field: Linkage Length |
%-------------------------------*
RField = uieditfield(fig, 'numeric', 'Position', [750, 550, 100, 30]);
RField.Value = 50;
RField.ValueDisplayFormat = '%.1f mm';
RField.ValueChangedFcn = @(src, event) updatePlot;

fmaxLbl = uilabel(fig, 'Position', [750 585 200 30]);
fmaxLbl.Text = '🔴 Linkage Length';

%----------------------------------*
% Numeric Field: Pivot Coordinates |
%----------------------------------*
cField = uieditfield(fig, 'numeric', 'Position', [765, 480, 75, 30]);
cField.Value = 90;
cField.ValueDisplayFormat = '%.1f mm';
cField.ValueChangedFcn = @(src, event) updatePlot;

dField = uieditfield(fig, 'numeric', 'Position', [875, 480, 75, 30]);
dField.Value = 0;
dField.ValueDisplayFormat = '%.1f mm';
dField.ValueChangedFcn = @(src, event) updatePlot;

pLbl = uilabel(fig, 'Position', [750 515 200 22]);
pLbl.Text = '🔵 Pivot Coordinates';

cLbl = uilabel(fig, 'Position', [750 480 50 30]);
cLbl.Text = 'X';

dLbl = uilabel(fig, 'Position', [860 480 50 30]);
dLbl.Text = 'Y';

%------------------------------------*
% Numeric Field: Sliding Rail Length |
%------------------------------------*
LField = uieditfield(fig, 'numeric', 'Position', [750, 410, 100, 30]);
LField.Value = 90;
LField.ValueDisplayFormat = '%.1f mm';
LField.ValueChangedFcn = @(src, event) updatePlot;

LLbl = uilabel(fig, 'Position', [750 445 200 30]);
LLbl.Text = '⚫ Sliding Rail Length';

%---------------------------------*
% Slider: Linkage Elevation Angle |
%---------------------------------*
sld = uislider(fig, 'Position', [100, 100, 800, 3]);
sld.Value = 0;
sld.Limits = [-30 90];
sld.MajorTicks = -30: 10: 90;
sld.MajorTickLabels = sld.MajorTicks + "°";
sld.ValueChangedFcn = @(src, event) updatePlot;

sldLbl = uilabel(fig, 'Position', [100 120 200 30]);
sldLbl.Text = 'Linkage Elevation Angle [°]';

%-------------------------------------*
% Text Area: Launcher Elevation Angle |
%-------------------------------------*
betaField = uilabel(fig, 'Position', [750, 350, 250, 30]);
betaField.Text = 'Launcher Elevation Angle: NaN';

%--------------------------------------*
% Text Area: Tangent Point Coordinates |
%--------------------------------------*
tpField = uilabel(fig, 'Position', [750, 320, 250, 30]);
tpField.Text = '🟣 Tangent Point Coordinates:';

tpxyField = uilabel(fig, 'Position', [750, 290, 250, 30]);
tpxyField.Text = 'X    NaN    Y    NaN';

%% Update Plot

updatePlot;


