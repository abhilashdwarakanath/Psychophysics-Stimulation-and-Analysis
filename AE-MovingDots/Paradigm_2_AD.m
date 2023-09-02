clear all
close all
clc

%%-------------------------------------------------------------------------START------------------------------------------------------------------------------%%

% This program presents the stimuli, records responses and saves them for
% the set of contigent after-effect experiments, the first one of which is
% a reproduction of the Sugita 2011 BMC Neuroscience paper
% (c) Abhilash Dwarakanath. MPI fuer Biologische Kybernetik. 14.05.2014

%% Acquiring Subject info, creating dedicated directory - 1

Names.subjName = input('Please enter your name here : ', 's'); % Subject name is entered and requires minimum 4 characters
experiment = input('Experiment number : '); % 1-2
if size(Names.subjName,2) < 4
    Names.subjName = 'dummy';
end

log_rec1=sprintf('\nHello %s. Let us start experiment: %d \n',Names.subjName,experiment);
disp(log_rec1);

if isunix == 1
    Names.dirName = ['/home/aglo-lab/Documents/MATLAB/Abhi/AE-MovingDots/Data/' Names.subjName '/'];
    %Names.dirName = ['/home/abhilash/Dokumente/MATLAB/Doctoral Work/PredCod_discrim - S-D/Data/' Names.subjName '/'];
else
    Names.dirName = ['C:\MATLAB\Abhi\Psychophysics\PredCodScripts\AE-MovingDots\Data\' Names.subjName '\'];
end

if exist(Names.dirName,'file') == 7
    
    cd(Names.dirName);
    
else
    
    Names.dirNameC = 'Control';
    Names.dirNameT = 'Test';% Each subject gets a dedicated directory
    Names.dirNameTest = 'FuncTest';
    
    log_rec2=sprintf('\nCreating directories... \n');
    disp(log_rec2);
    
    mkdir(Names.dirName);
    addpath(Names.dirName);
    cd(Names.dirName)
    mkdir(Names.dirNameC);
    addpath([Names.dirName Names.dirNameC]);
    mkdir(Names.dirNameT);
    addpath([Names.dirName Names.dirNameT]);
    mkdir(Names.dirNameTest);
    addpath([Names.dirName Names.dirNameTest]);
    
end

% 1 data files will be saved with four variables for each experiments. 1
% log file will be saved

Names.fileNameC = [Names.subjName 'dataC' num2str(experiment)];
Names.fileNameT = [Names.subjName 'dataT' num2str(experiment)];
Names.fileNameTest = [Names.subjName 'dataTest' num2str(experiment)];
Names.resultsC = [Names.subjName 'resultsC' num2str(experiment)];
Names.resultsT = [Names.subjName 'resultsT' num2str(experiment)];
Names.resultsTest = [Names.subjName 'resultsTest' num2str(experiment)];

%% Initialise Screen and Audio

AssertOpenGL;
Screen('Preference', 'SkipSyncTests', 0);
Screen('Preference', 'Verbosity', 2);
display.screenRect = [0 0 1024 768];
display.screenNumber=0;
[display.windowPtr,display.screenRect]=Screen('OpenWindow',display.screenNumber,0,display.screenRect);
display.ifi=Screen('GetFlipInterval', display.windowPtr);
Screen('TextFont', display.windowPtr,'Arial');
Screen('TextSize',display.windowPtr,24);
sca;

% Psychportaudio initialisation

InitializePsychSound(1);
esound.fs = 44100;
esound.pahandle = PsychPortAudio('Open', [], 1, 3,esound.fs,2);

%% Set parameters

% display params

display.dist = 63;  %cm
display.width = 51.4; %cm
display.bkColor=[0,0,0];         %background color (default is [0,0,0])       
display.frameRate=round(1/display.ifi); %frame rate, set by 'OpenWindow'
display.resolution = [1024 768];
display.fixation.size=0.4;
display.fixation.color={[255,0,0],[255,0,0]};
display.fixation.mask = 0.4;

% Dots params
dots.nDots=300;            %Number of dots in the field
dots.speed=2;            %Speed of the dots (degrees/second)
dots.lifetime=12; %Number of frames for each dot to live
dots.apertureSize=[5,5];     %[x,y] size of elliptical aperture (degrees)
dots.Centre=[5,0];           %[x,y] Centre of the aperture (degrees)
dots.color=[255,255,255];            %Color of the dot field [r,g,b] from 0-255
dots.size=angle2pix(display,0.05);             %Size of the dots (in pixels)        
dots.duration = 0.5; % stimulus duration
display.screenCentre = [512 384]; % Screen Centre in pixels

% Experiment params
cohs = [-100 100]/100; % 22.6 = 0.78 cyc/deg % 57.3 = 1.75 cyc/deg
freqss = [500 2000]; % PLEASE COUNTER-BALANCE THIS ACROSS SUBJECTS, i.e. AB-BA!!!
%freqss = [2000 500];
ExpParams.association = [freqss' cohs'];

KbName('UnifyKeyNames'); % Unifying Mac and PC Keyboards
ExpParams.lKey = KbName('LeftArrow'); %Sparser
ExpParams.rKey = KbName('RightArrow'); % Denser
ExpParams.proceedKey = KbName('return'); % subject presses this key to move on
ExpParams.endKey = KbName('escape'); % End key

%% Test if all the params are fine

[display.windowPtr,display.screenRect]=Screen('OpenWindow',display.screenNumber,0,display.screenRect);

dots.coherence=1;
dots.direction = 90;
dots.duration = 5;
movingDots(display,dots)
drawBlank(display);
WaitSecs(0.5);
sca;
% Reset duration
dots.duration = 0.5;

%% Psych function test

cd('FuncTest')

PsychImaging('PrepareConfiguration');
PsychImaging('AddTask','General','UseVirtualFramebuffer');
[display.windowPtr,display.screenRect]=PsychImaging('OpenWindow',display.screenNumber,display.bkColor,display.screenRect);
priorityLevel=MaxPriority(display.windowPtr);
Priority(priorityLevel);
exp_stimuli_test(ExpParams,Names,display,esound,dots)

%% Process this result
load('resplogtest.mat');
[hits,trls] = processdatatest(ExpParams,resplog,conds);
clear resplog

x = conds';
niter = 1999;
cuts_f = [0.25 0.5 0.75];

dataTest = [x hits' trls'];
pfit(dataTest,'plot without stats','shape', 'c', 'n_intervals', 1, 'runs', niter, 'verbose',0, 'sens', 0, 'cuts',cuts_f,'CONF',[.025 .975]);%,'FIX_GAMMA',0);
xlabel('coherence')
ylabel('P(leftward)')
title('Pscych Func Test')
axis([min(x) max(x) 0 1])
set(gca,'XTick',x)
clear dataTest
cd ..

%% Pre-

cd('Control')

type = 'c';

PsychImaging('PrepareConfiguration');
PsychImaging('AddTask','General','UseVirtualFramebuffer');
[display.windowPtr,display.screenRect]=PsychImaging('OpenWindow',display.screenNumber,display.bkColor,display.screenRect);
priorityLevel=MaxPriority(display.windowPtr);
Priority(priorityLevel);
exp_stimuli_b(ExpParams,Names,display,esound,dots,type)

cd ..

%% Exposure

PsychImaging('PrepareConfiguration');
PsychImaging('AddTask','General','UseVirtualFramebuffer');
[display.windowPtr,display.screenRect]=PsychImaging('OpenWindow',display.screenNumber,display.bkColor,display.screenRect);
priorityLevel=MaxPriority(display.windowPtr);
Priority(priorityLevel);
exp_stimuli_e(ExpParams,display,esound,dots)

%% Post-exposure

cd('Test')

type = 't';
PsychImaging('PrepareConfiguration');
PsychImaging('AddTask','General','UseVirtualFramebuffer');
[display.windowPtr,display.screenRect]=PsychImaging('OpenWindow',display.screenNumber,display.bkColor,display.screenRect);
priorityLevel=MaxPriority(display.windowPtr);
Priority(priorityLevel);
exp_stimuli_b(ExpParams,Names,display,esound,dots,type)

cd ..
%%--------------------------------------------------------------------------END-------------------------------------------------------------------------------%%