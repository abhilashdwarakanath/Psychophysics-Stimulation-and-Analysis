clear all
clc

GP.snrs = [linspace(0.4,0.9,7) linspace(0.4,0.9,7)];
GP.imgSize = [800,1280];
GP.img_bgnd = 50;
GP.gFreq = 36; % cycles per image dimension (720 pixels)
GP.gBand = 48;  % std of Gaussian
GP.gOris = deg2rad([60 45 30 -30 -45 -60]);
GP.gCont = 75; % for exposure only
GP.dist = 200; % Distance to shift the gabors by
GP.centre = GP.imgSize/2;

gabor = local_make_Gabor(GP.imgSize,GP.img_bgnd,GP.gFreq,GP.gBand,0,GP.gCont);

AssertOpenGL;
Screen('Preference', 'SkipSyncTests', 1);
rot_spd = 1;  
KbName('UnifyKeyNames');
larrow = KbName('UpArrow'); % modify this for Windows  
rarrow = KbName('DownArrow');  
[w,GP.screenRect]=Screen('OpenWindow',0,50,[0 0 1280 800]);   
t = Screen('MakeTexture',w,gabor);  
bdown=0;  
th = 0; % initial rotation angle (degrees)  
HideCursor  

SetMouse(1600,540);
while(~any(bdown)) % exit loop if mouse button is pressed  
    [x,y,bdown]=GetMouse;
    th=(180*((x-1600)/3200));
    Screen('DrawTexture',w,t,[],[],th);  
    Screen('Flip',w);   
end 


sca;
angle = 90+th