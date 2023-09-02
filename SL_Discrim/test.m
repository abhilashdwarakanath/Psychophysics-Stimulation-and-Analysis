clear all
clc

IMGSIZE = [1080,1920];
IMG_BGND = 50;
G_FREQ = 48;
G_BAND = 36;
G_ORI = deg2rad(30);
G_CONTR = 20;

AssertOpenGL;
Screen('Preference', 'SkipSyncTests', 1);
Screen('Preference', 'Verbosity', 2);
GP.screen_res = [0 0 1920 1080];
GP.screenNumber=0;
[w,GP.screenRect]=Screen('OpenWindow',GP.screenNumber,50,GP.screen_res);
GP.ifi=Screen('GetFlipInterval', w);
Screen('TextFont', w,'Arial');
Screen('TextSize',w,24);
sca;

PsychImaging('PrepareConfiguration');
PsychImaging('AddTask','General','UseVirtualFramebuffer');
[w,GP.screenRect]=PsychImaging('OpenWindow',GP.screenNumber,50,GP.screen_res);


for i = 1:40
    noise = local_make_Noise(IMGSIZE,IMG_BGND,G_BAND,G_CONTR);
    id_noise = Screen('MakeTexture',w,noise);
    if i==20
        target = local_make_GNoise(IMGSIZE,IMG_BGND,G_FREQ,G_BAND,G_ORI,G_CONTR);
        id_target = Screen('MakeTexture',w,target);
        Screen('DrawTexture',w,id_target);
        Screen('Flip',w);
        Screen('Close');
    else
        Screen('DrawTexture',w,id_noise);
        Screen('Flip',w);
        Screen('Close');
    end
    
    if i == 40
        sca;
    end
    
end

