clear all
close all
clc
warning('off','MATLAB:MKDIR:DirectoryExists');
warning('off','MATLAB:dispatcher:InexactMatch');

%%-------------------------------------------------------------------------START------------------------------------------------------------------------------%%

% This program presents stimuli for the Predictive Coding Experiments and
% analyses the data to compute classical and new d', fit psychometric curves
% across conditions and bootstrap the fitted parameters.
% Change the experimental parameters as you wish but please do not change any of the hardware parameters.

% (c) Abhilash Dwarakanath. MPI für Biologische Kybernetik. 24.11.2012

%% Acquiring Subject info, creating dedicated directory -

Names.subjName = input('Please enter your name here : ', 's'); % Subject name is entered and requires minimum 4 characters
experiment = input('Experiment number : '); % 1-6
if size(Names.subjName,2) < 4
    Names.subjName = 'dummy';
end

log_rec1=sprintf('\nHello %s. Let us start experiment: %d \n',Names.subjName,experiment);
disp(log_rec1);

if isunix == 1
    Names.dirName = ['/home/aglo-lab/Documents/MATLAB/Abhi/PredCod_discrim/Data/' Names.subjName '/'];
    %Names.dirName = ['/home/abhilash/Dokumente/MATLAB/Doctoral Work/PredCod_discrim/Data/' Names.subjName '/'];
else
    Names.dirName = ['C:\MATLAB\Abhi\Psychophysics\PredCodScripts\PredCod_discrim\Data\' Names.subjName '\'];
end

if exist(Names.dirName,'file') == 7
    
    cd(Names.dirName);
    cd('JND');
    load jnd.mat;
    GP.jnd = sub_jnd;
    cd ..
    
else
    
    Names.dirName_con = 'JND';
    Names.dirNameC = 'Control';
    Names.dirNameT = 'Test';% Each subject gets a dedicated directory
    Names.dirNameExp = 'Exposure';
    
    log_rec2=sprintf('\nCreating directories... \n');
    disp(log_rec2);
    
    mkdir(Names.dirName);
    addpath(Names.dirName);
    cd(Names.dirName)
    mkdir(Names.dirNameC);
    addpath([Names.dirName Names.dirNameC]);
    mkdir(Names.dirNameT);
    addpath([Names.dirName Names.dirNameT]);
    mkdir(Names.dirName_con);
    addpath([Names.dirName Names.dirName_con]);
    mkdir(Names.dirNameExp);
    addpath([Names.dirName Names.dirNameExp]);
    
end

% 1 data files will be saved with four variables for each experiments. 1
% log file will be saved

Names.fileNameExp = [Names.subjName 'dataExp' num2str(experiment)];
Names.fileNameC = [Names.subjName 'dataC' num2str(experiment)];
Names.fileNameT = [Names.subjName 'dataT' num2str(experiment)];% Responses in 0s and 1s, 6 cells, 1 for each block, each with 36 elements
Names.logFileC = [Names.subjName 'LogFileC' num2str(experiment) '.txt'];
Names.logFileExp = [Names.subjName 'LogFileExp' num2str(experiment) '.txt'];
Names.logFileT = [Names.subjName 'LogFileT' num2str(experiment) '.txt'];% Record every event
Names.resultsC = [Names.subjName 'resultsC' num2str(experiment)];
Names.resultsT = [Names.subjName 'resultsT' num2str(experiment)];
Names.resultsExp = [Names.subjName 'resultsExp' num2str(experiment)];

%% Setting parameters

% Randomise seed

rand('twister', sum(100*clock)); %#ok<*RAND>

% Screen Initialisation

AssertOpenGL;
Screen('Preference', 'SkipSyncTests', 0);
Screen('Preference', 'Verbosity', 2);
GP.screen_res = [0 0 1920 1080];
GP.screenNumber=1;
[w,GP.screenRect]=Screen('OpenWindow',GP.screenNumber,50,GP.screen_res);
GP.ifi=Screen('GetFlipInterval', w);
Screen('TextFont', w,'Arial');
Screen('TextSize',w,24);
sca;

% Psychportaudio initialisation

InitializePsychSound(1);
GP.pahandle = PsychPortAudio('Open', [], 1, 3,44100,2);

% Load gamma table

if isunix == 1
    load('/home/aglo-lab/Documents/MATLAB/Abhi/PredCod_discrim/CALIBRATION.mat', 'inverseCLUT');
else
    load('C:\MATLAB\Abhi\Psychophysics\PredCodScripts\PredCod_discrim\CALIBRATION.mat','inverseCLUT');
end
inverseCLUT(1,:) = 0;
originalCLUT=Screen('LoadNormalizedGammaTable',GP.screenNumber,inverseCLUT);

% Visual target parameters

GP.imgSize = [1080 1920];
GP.img_bgnd = 25;
GP.oris(1,:) = [30 45 60];
GP.oris(2,:) =  [120 135 150];
GP.gBand = 36;  % std of Gaussian 
GP.gCont = 22;
GP.dist = 200; % Distance to shift the gabors by
GP.centre = GP.imgSize/2;
GP.screen_centre = [GP.screenRect(3) GP.screenRect(4)]/2;
GP.aFreq = shuffle(round(linspace(2^7,2^10,6)));

if exist([Names.dirName 'association.mat'],'file') == 2
    load association.mat
    ExpParams.association = association;
else
    o1 = randperm(3);
    oris = [GP.oris(1,o1(1)) GP.oris(2,o1(2))];
    freqs = [GP.aFreq(1) GP.aFreq(2)];
    association = [shuffle(freqs)' (shuffle(oris))'];
    save([Names.dirName 'association'], 'association');
    ExpParams.association = association;
end

% Experiment Parameters

ExpParams.blocks = 2;
ExpParams.fs = 44100;
KbName('UnifyKeyNames'); % Unifying Mac and PC Keyboards
ExpParams.lKey = KbName('LeftArrow'); % Map to response : ACW
ExpParams.rKey = KbName('RightArrow'); % Map to response : CW
ExpParams.proceedKey = KbName('return'); % subject presses this key to move on
ExpParams.endKey = KbName('escape'); % End key

%% Estimate Thresholds
% jnd

cd('JND')

PsychImaging('PrepareConfiguration');
PsychImaging('AddTask','General','UseVirtualFramebuffer');
[w,GP.screenRect]=PsychImaging('OpenWindow',GP.screenNumber,25,GP.screen_res);
[datajnd] = estimate_jnd(ExpParams,GP,w);

results_jnd = pfit(datajnd,'plot without stats','shape', 'c', 'n_intervals', 1, 'runs', 1999, 'verbose',0, 'sens', 0, 'cuts',[0.25 0.5 0.75]);
GP.jnd = ((results_jnd.thresholds.est(3) - results_jnd.thresholds.est(1))/2);
sub_jnd = GP.jnd;
save('jnd','sub_jnd');
cd ..

%% Discrimination training

PsychImaging('PrepareConfiguration');
PsychImaging('AddTask','General','UseVirtualFramebuffer');
[w,GP.screenRect]=PsychImaging('OpenWindow',GP.screenNumber,25,GP.screen_res);
discrim_training(ExpParams,GP,w);

%% MOA training

PsychImaging('PrepareConfiguration');
PsychImaging('AddTask','General','UseVirtualFramebuffer');
[w,GP.screenRect]=PsychImaging('OpenWindow',GP.screenNumber,25,GP.screen_res);
moa_training(ExpParams,GP,w);

%% Pre-exposure phase

type = 'c';
cd('Control')

PsychImaging('PrepareConfiguration');
PsychImaging('AddTask','General','UseVirtualFramebuffer');
[w,GP.screenRect]=PsychImaging('OpenWindow',GP.screenNumber,25,GP.screen_res);
priorityLevel=MaxPriority(w);
Priority(priorityLevel);

[c_freq_order, c_trial_order,c_responses] = exp_stimuli(ExpParams,GP,Names,w,type);

cd ..

%% Exposure phase

cd('Exposure');

PsychImaging('PrepareConfiguration');
PsychImaging('AddTask','General','UseVirtualFramebuffer');
[w,GP.screenRect]=PsychImaging('OpenWindow',GP.screenNumber,25,GP.screen_res);
priorityLevel=MaxPriority(w);
Priority(priorityLevel);

exposure_stimulus2(ExpParams,GP,Names,w);

cd ..
%% Test phase

type = 't';
cd('Test');

PsychImaging('PrepareConfiguration');
PsychImaging('AddTask','General','UseVirtualFramebuffer');
[w,GP.screenRect]=PsychImaging('OpenWindow',GP.screenNumber,25,GP.screen_res);
priorityLevel=MaxPriority(w);
Priority(priorityLevel);

[t_freq_order, t_trial_order,t_responses] = exp_stimuli(ExpParams,GP,Names,w,type);

cd ..

%------------------------------------------------------------------END-----------------------------------------------------------------------------------------%
