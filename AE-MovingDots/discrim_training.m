function [percent_correct] = discrim_training(ExpParams,GP,w)

%==========================================================================
% parameters and stimulus order
%==========================================================================
Ntrial = 70;
load('resp_right.mat'); resp_right = 2.*resp_right';
load('resp_wrong.mat'); resp_wrong = 2.*resp_wrong';

load('association.mat');

for k=1:10
    ContrastOrder(k,:) = randperm(7);
end

ContrastOrder = ContrastOrder'; ContrastOrder =ContrastOrder(:);

GOOD_KEYS = [ExpParams.sKey,ExpParams.dKey];

GP.subject_cont = GP.gCont;

%==========================================================================
% CREATE GABORS
%==========================================================================

% Set of different sf gabors

[GP.cf*2^(-1) GP.cf*2^(-0.67) GP.cf*2^(-0.33) GP.cf*2^(0) GP.cf*2^(0.33) GP.cf*2^(0.67) GP.cf*2^(1)];

% Fixation dot

gEmpty = local_make_Gabor(GP.imgSize,GP.img_bgnd,48,GP.gBand,0/180*pi,0);
gEmpty(GP.centre(1)+(-2:2),GP.centre(2)+(-2:2)) = 255;

%==========================================================================
% Start trials
%==========================================================================

Screen('DrawText', w, 'Press Enter to start AFC training', 500,400,[255 255 255]);
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
    
    cont_trial = ContrastOrder(trial);
    
    gOr_target = stds(trial);
    
    id_fix=Screen('MakeTexture', w, gEmpty);
    
    % wait until next trial start

    fprintf('trial %d of %d.  del(SF): %d    ',trial,Ntrial,cont_trial);

    
for i = 1:8
    noise{i} = local_make_GNoise(GP.imgSize,GP.img_bgnd,gOr_target,GP.gBand,0,0);
    id_noise(i) = Screen('MakeTexture',w,noise{i});
end

for i = 1:3
    sample{i} = local_make_GNoise(GP.imgSize,GP.img_bgnd,gOr_target,GP.gBand,0,GP.gCont);
    id_sample(i) = Screen('MakeTexture',w,sample{i});
end

for i = 1:3
    test{i} = local_make_GNoise(GP.imgSize,GP.img_bgnd,gOr_target+dev(cont_trial),GP.gBand,0,GP.gCont);
    id_test(i) = Screen('MakeTexture',w,test{i});
end

delay = 0.6+(0.9-0.6).*rand(1);
WaitSecs(0.5);

Screen('DrawTexture', w, id_fix);
Screen('Flip', w);
WaitSecs(delay);

% Flash stimulus for three refresh-rates
tic;
for tt = 1:7    
    if tt==1       
        Screen('DrawTexture',w,id_noise(1));
        Screen('Flip',w);toc
    elseif tt==2
        Screen('DrawTexture',w,id_noise(2));
        Screen('Flip',w);toc
    elseif tt==3  
        Screen('DrawTexture',w,id_sample(1));
        Screen('Flip',w);toc
    elseif tt == 4        
        Screen('DrawTexture',w,id_sample(2));
        Screen('Flip',w);toc
    elseif tt == 5        
        Screen('DrawTexture',w,id_sample(3));
        Screen('Flip',w);toc
    elseif tt==6        
        Screen('DrawTexture',w,id_noise(3));
        Screen('Flip',w);toc
    else        
        Screen('DrawTexture',w,id_noise(4));
        Screen('Flip',w);toc
    end    
end

Screen('DrawTexture', w, id_fix);
Screen('Flip', w);
WaitSecs(1.25);

for tt = 1:7    
    if tt==1       
        Screen('DrawTexture',w,id_noise(5));
        Screen('Flip',w);
    elseif tt==2
        Screen('DrawTexture',w,id_noise(6));
        Screen('Flip',w);
    elseif tt==3  
        Screen('DrawTexture',w,id_test(1));
        Screen('Flip',w);
    elseif tt == 4        
        Screen('DrawTexture',w,id_test(2));
        Screen('Flip',w);
    elseif tt == 5        
        Screen('DrawTexture',w,id_test(3));
        Screen('Flip',w);
    elseif tt==6        
        Screen('DrawTexture',w,id_noise(7));
        Screen('Flip',w);
    else        
        Screen('DrawTexture',w,id_noise(8));
        Screen('Flip',w);
    end    
end
    Screen('DrawTexture', w, id_fix);
    Screen('Flip', w);
    WaitSecs(delay);
    
    % present ? and wait for response
    Screen('DrawText', w, 'GLEICH ? VERSCHIEDEN', GP.screen_centre(1)-200,GP.screen_centre(2),[255 255 255]);
    Screen('Flip', w);
    [secs, keyCode] = KbWait([],2);
    resp = find(keyCode);
    if sum(resp==GOOD_KEYS)==0
        resp = NaN;
    end
    
    if dev(cont_trial)~= 0 && resp == ExpParams.dKey
        fprintf('  Correct \n');
        resp1 = 1;
        PsychPortAudio('FillBuffer', GP.pahandle, resp_right);
        PsychPortAudio('Start', GP.pahandle);
    elseif dev(cont_trial)== 0 && resp == ExpParams.sKey
        resp1 = 1;
        PsychPortAudio('FillBuffer', GP.pahandle, resp_right);
        PsychPortAudio('Start', GP.pahandle);
        fprintf('  Correct \n');
    else
        resp1 = 0;
        PsychPortAudio('FillBuffer', GP.pahandle, resp_wrong);
        PsychPortAudio('Start', GP.pahandle);
        fprintf('  Wrong \n');
    end
    
    Screen('Close');
    response(1,trial) = cont_trial;
    response(2,trial) = resp1;
    WaitSecs(delay+0.5);
    
end
ShowCursor;
ListenChar(0);
sca;

percent_correct = (sum(response(2,:))/Ntrial)*100;
