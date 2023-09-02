function moa_training(ExpParams,GP,w)

%==========================================================================
% parameters and stimulus order
%==========================================================================
Ntrial = 128;
load('resp_right.mat'); resp_right = resp_right';
load('resp_wrong.mat'); resp_wrong = resp_wrong';

load('association.mat');

for k=1:16
    ContrastOrder(k,:) = randperm(8);
end

ContrastOrder = ContrastOrder'; ContrastOrder =ContrastOrder(:);

GOOD_KEYS = [ExpParams.lKey,ExpParams.rKey];

GP.subject_cont = GP.gCont;
sf = 48+3*randn;
while sf < 36
    sf = 48+3*randn;
    
end

jnd = GP.jnd;
%==========================================================================
% CREATE GABORS
%==========================================================================

% Set of different contrasts gabors

GP.oris = [jnd*-7.5 jnd*-5 jnd*-2.5 0 jnd*2.5 jnd*5 jnd*7.5 jnd*9];

% Fixation dot

gEmpty = local_make_Gabor(GP.imgSize,GP.img_bgnd,sf,GP.gBand,0/180*pi,0);
gEmpty(GP.centre(1)+(-2:2),GP.centre(2)+(-2:2)) = 255;

%==========================================================================
% Start trials
%==========================================================================

Screen('DrawText', w, 'Press Enter to start MOA training', 500,400,[255 255 255]);
Screen('Flip', w);
HideCursor;
ListenChar(2);

[v,v,keyCode1] = KbCheck;

while keyCode1(ExpParams.proceedKey) ~= 1
    
    [v,v,keyCode1] = KbCheck;
    
    if keyCode1(ExpParams.endKey)
        
        sca;
        break;
        
    end
    
end

for trial = 1:Ntrial
    
    sf = 48+3*randn;
    while sf < 36
        sf = 48+3*randn;
    end
    
    gStd = local_make_Gabor(GP.imgSize,GP.img_bgnd,sf,GP.gBand,0,GP.subject_cont);
    
    
    cont_trial = ContrastOrder(trial);
    
    stds = shuffle([association(1,2).*ones(1,Ntrial/2) association(2,2).*ones(1,Ntrial/2)]);
    
    ori_std = stds(trial);
    
    id_fix=Screen('MakeTexture', w, gEmpty);
    id_std = Screen('MakeTexture',w,gStd);
    
    % wait until next trial start
    delay = (200+rand*100)/1000;
    fprintf('trial %d of %d.  Cont: %d    ',trial,Ntrial,cont_trial);
    WaitSecs(delay);
    
    % present fixation dot
    Screen('DrawTexture', w, id_fix);
    Screen('Flip', w);
    
    % wait period unti target
    delay = (200+rand*300)/1000; % s delay
    % convert to refresh
    WaitSecs(delay);
    
    % Flash standard gabor
    Screen('DrawTexture',w,id_std,[],[],ori_std);
    Screen('Flip',w);
    Screen('DrawTexture',w,id_std,[],[],ori_std);
    Screen('Flip',w);
    Screen('DrawTexture',w,id_fix);
    Screen('Flip',w);
    WaitSecs(delay+0.3);
    
    % target
    
    r = round(3+(10-3)*rand);
    sf = 48+3*randn;
    while sf < 36
        sf = 48+3*randn;
        
    end
    for tt = 1:12
        noise = local_make_Noise(GP.imgSize,GP.img_bgnd,GP.gBand,GP.gCont);
        id_noise = Screen('MakeTexture',w,noise);
        if tt==r
            
            G = local_make_GNoise(GP.imgSize,GP.img_bgnd,sf,GP.gBand,0,GP.gCont);
            id_spgabor = Screen('MakeTexture',w,G);
            Screen('DrawTexture',w,id_spgabor,[],[],ori_std+GP.oris(cont_trial));
            Screen('Flip',w);
            Screen('DrawTexture',w,id_spgabor,[],[],ori_std+GP.oris(cont_trial));
            Screen('Flip',w);
            %Screen('Close');
        else
            Screen('DrawTexture',w,id_noise);
            Screen('Flip',w);
            %Screen('Close');
        end
        
    end
    
    %     Screen('DrawTexture', w, id_gabor,[],[],ori_std+GP.oris(cont_trial));
    %     Screen('Flip', w);
    %     Screen('DrawTexture', w, id_gabor,[],[],ori_std+GP.oris(cont_trial));
    %     Screen('Flip', w);
    Screen('DrawTexture', w, id_fix);
    Screen('Flip', w);
    WaitSecs(delay);
    
    % present ? and wait for response
    g0 = local_make_Gabor(GP.imgSize,GP.img_bgnd,48,GP.gBand,0,GP.gCont);
    id_0 = Screen('MakeTexture', w, g0);
    
    % Present 0 Gabor
    
    Screen('DrawTexture', w, id_0);
    Screen('Flip', w);
    
    bdown=0;
    
    th = 0; % initial rotation angle (degrees)
    
    SetMouse(1440,800); % Set random start pos to remove bias
    
    %[~,~,keyCode] = KbCheck;
    
    while(~any(bdown)) % exit loop if mouse button is pressed
        [x,y,bdown]=GetMouse;
        th=(180*((x)/2879));
        Screen('DrawTexture',w,id_0,[],[],th);
        Screen('Flip',w);
    end
    
    Screen('DrawTexture', w, id_fix);
    Screen('Flip',w);
    resp = th;
    
    if abs(ori_std+GP.oris(cont_trial)-resp)<3*jnd
        PsychPortAudio('FillBuffer', GP.pahandle, resp_right);
        PsychPortAudio('Start', GP.pahandle);
        fprintf('Close! Good \n');
        
    else
        PsychPortAudio('FillBuffer', GP.pahandle, resp_wrong);
        PsychPortAudio('Start', GP.pahandle);
        fprintf('Nääh \n');
    end
    
    WaitSecs(delay+0.5);
    Screen('Close');
    
end
sca;
ShowCursor;
ListenChar(0);
end

