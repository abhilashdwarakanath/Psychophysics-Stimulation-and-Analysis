clear all
clc

GP.snrs = [linspace(0.4,0.9,7) linspace(0.4,0.9,7)];
GP.imgSize = [200,200];
GP.img_bgnd = 50;
GP.gFreq = 100; % cycles per image dimension (720 pixels)
GP.gBand = 72;  % std of Gaussian
GP.gOris = deg2rad([60 45 30 -30 -45 -60]);
GP.gCont = 20; % for exposure only
GP.dist = 200; % Distance to shift the gabors by
GP.centre = GP.imgSize/2;

gabor = local_make_Gabor(GP.imgSize,GP.img_bgnd,GP.gFreq,GP.gBand,0,GP.gCont);

[yimg,ximg,z]=size(GP.imgSize);  
rot_spd = 1/750;  
KbName('UnifyKeyNames');
larrow = KbName('UpArrow'); % modify this for Windows  
rarrow = KbName('DownArrow');  
[w,GP.screenRect]=Screen('OpenWindow',0,50,[0 0 1280 800]);  
sx = 200; % desired x-size of image (pixels)  
sy = yimg*sx/ximg; % desired y-size--keep proportional  
t = Screen('MakeTexture',w,gabor);  
bdown=0;  
th = 0; % initial rotation angle (degrees)  
HideCursor  
X = [0];
%Y = [0];
while(~any(bdown)) % exit loop if mouse button is pressed  
    [x]=spcmouse;
    X = [X x(6)];
    %Y = [Y y];
    if (X(end) - X(end-1)) > 0 
        rot_spd = rot_spd+0.01/750; % accelrate clockwise  
        th = th+rot_spd;
    end
    
    if (X(end) - X(end-1)) < 0
        rot_spd = rot_spd-0.01/750; % accelrate clockwise  
        th = th-rot_spd;
    end
     
    %destrect=[x-sx/2,y-sy/2,x+sx/2,y+sy/2];  
    Screen('DrawTexture',w,t,[],[],th);  
    Screen('Flip',w);   
end  
sca;

angle = 90+th