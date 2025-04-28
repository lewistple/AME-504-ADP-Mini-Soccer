%% Projectile Launcher Calculator

%% Clear

clear, clc, close all;

%% UI Setup

fig = uifigure('Position', [300, 300, 1000, 700]);
ax = uiaxes(fig, 'Position', [100, 200, 600, 450]);

%-------------------------*
% Numeric Field: Max Load |
%-------------------------*
fmaxField = uieditfield(fig, 'numeric', 'Position', [750, 550, 100, 30]);
fmaxField.Value = 3.56;
fmaxField.ValueChangedFcn = @(src, event) updatePlot;

fmaxLbl = uilabel(fig, 'Position', [750 585 200 22]);
fmaxLbl.Text = 'Max Load [lb]';

%--------------------------------*
% Numeric Field: Spring Constant |
%--------------------------------*
kField = uieditfield(fig, 'numeric', 'Position', [750, 480, 100, 30]);
kField.Value = 1.9;
kField.ValueChangedFcn = @(src, event) updatePlot;

kLbl = uilabel(fig, 'Position', [750 515 200 22]);
kLbl.Text = 'Spring Rate [lb/in]';

%-------------------------------------*
% Dropdown List: Rubber Ball Diameter |
%-------------------------------------*
dField = uidropdown(fig, 'Position', [750, 410, 100, 30]);
dField.Items = ["0.43 in" "0.5 in" "0.68 in"];
dField.ItemsData = [0.43 0.5 0.68];
dField.ValueChangedFcn = @(src, event) updatePlot;

dLbl = uilabel(fig, 'Position', [750 445 200 22]);
dLbl.Text = 'Rubber Ball Diameter';

%--------------------------*
% Slider: Projectile Angle |
%--------------------------*
sld = uislider(fig, 'Position', [100, 100, 600, 3]);
sld.Value = 0;
sld.Limits = [0 45];
sld.MajorTicks = 0: 5: 45;
sld.MajorTickLabels = sld.MajorTicks + "°";
sld.ValueChangedFcn = @(src, event) updatePlot;

sldLbl = uilabel(fig, 'Position', [100 120 200 22]);
sldLbl.Text = 'Projectile Angle [°]';

%% Update Plot

updatePlot;



