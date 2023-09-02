clear all
close all
clc

% This is a script used to present N levels of RGB/W values to record
% luminance values and then generate an inverse gamma LUT to calibrate a
% monitor

% Abhilash Dwarakanath. 12.08.13. MPIBK Tübingen.

%% Start

% Screen Initialisation

AssertOpenGL;
Screen('Preference', 'SkipSyncTests', 0);
Screen('Preference', 'Verbosity', 2);
GP.screen_res = [0 0 1920 1080];
GP.screenNumber=1;
GP.steps = 10; % Number of samples = 255/steps

% Keys

KbName('UnifyKeyNames'); % Unifying Mac and PC Keyboards
Params.uKey = KbName('UpArrow'); % Map to response : left detected
Params.dKey = KbName('DownArrow'); % Map to response : right detected
Params.proceedKey = KbName('return'); % subject presses this key to move on
Params.endKey = KbName('escape'); % End key

%% Calibrate white

w_points = calibrate_white(GP,Params);

%% Calibrate R

r_points = calibrate_red(GP,Params);

%% Calibrate G

g_points = calibrate_green(GP,Params);

%% Calibrate B

b_points = calibrate_blue(GP,Params);

%% Generate inverse CLUT

% Read the values. Navigate to the folder in which the files are. Change
% the names, i.e. White/Red/Green/Blue. Change the wavelength ranges

range = [1:26]; %replace with proper numbers, these are the file indices

spec_range(1,:) = [380 800]; %White
spec_range(2,:) = [600 740]; %Red
spec_range(3,:) = [520 570]; %Green
spec_range(4,:) = [450 495]; %Blue

unit = 1; %nm

for i = range
    
    fn = ['blue' num2str(i)];
    [~,spect_temp] = oceanoptics_read(fn,unit,spec_range(4,:));
    spect(i,:) = spect_temp;
    
end

for i = 1:size(spect,1)
    
    lut(i) = mean(spect(i,:));
    
end

% Change the w_points and load the LUT according to the colour/grayscale
% you wish to calibrate
inverseCLUT = genInvGamma(lut,w_points);

%% END