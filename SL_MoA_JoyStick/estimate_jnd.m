function [data] = estimate_jnd(ExpParams,GP,w)

%==========================================================================
% parameters and stimulus order
%==========================================================================
Ntrial = 128;

for k=1:16
   ContrastOrder(k,:) = randperm(8);
end

ContrastOrder = ContrastOrder'; ContrastOrder =ContrastOrder(:);

GOOD_KEYS = [ExpParams.uKey,ExpParams.dKey];

GP.subject_cont = 20;
%==========================================================================
% CREATE GABORS
%==========================================================================

% Set of different contrasts gabors

GP.oris = deg2rad([-15 -10 -5 0 5 10 15 20]);

for l=1:length(GP.conts)
   Gabors{l} = local_make_Gabor(GP.imgSize,GP.img_bgnd,GP.gFreq,GP.gBand,GP.oris(l),GP.subject_cont);
end

% Fixation dot

gEmpty = local_make_Gabor(GP.imgSize,GP.img_bgnd,GP.gFreq,GP.gBand,0/180*pi,0);
gEmpty(GP.centre(1)+(-2:2),GP.centre(2)+(-2:2)) = 255;

% Standard gabor

gStd = local_make_Gabor(GP.imgSize,GP.img_bgnd,GP.gFreq,GP.gBand,0/180*pi,GP.subject_cont);
%==========================================================================
% Start trials
%==========================================================================   

Screen('DrawText', w, 'Press Enter to start JND estimation', 500,400,[255 255 255]);
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

response = zeros(2,Ntrial); RT = zeros(1,Ntrial);


for trial = 1:Ntrial
    
    cont_trial = ContrastOrder(trial);
    
    id_fix=Screen('MakeTexture', w, gEmpty);
    id_gabor=Screen('MakeTexture', w, Gabors{cont_trial});
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
    Screen('DrawTexture',w,id_std);
    Screen('Flip',w);
    Screen('DrawTexture',w,id_std);
    Screen('Flip',w);
    Screen('DrawTexture',w,id_fix);
    Screen('Flip',w);
    WaitSecs(delay+0.3);
    
    % target

    Screen('DrawTexture', w, id_gabor);
    Screen('Flip', w);
    Screen('DrawTexture', w, id_gabor);
    Screen('Flip', w);  
    Screen('DrawTexture', w, id_fix);
    Screen('Flip', w);
    WaitSecs(delay);

    % present ? and wait for response
    Screen('DrawText', w, '?', GP.screen_centre(1),GP.screen_centre(2),[255 255 255]);
    Screen('Flip', w);  
    [secs, keyCode] = KbWait([],2);
    resp = find(keyCode);
    if sum(resp==GOOD_KEYS)==0
       resp = NaN;
    end
    
    if resp == ExpParams.lKey
        fprintf('  More Left\n');
    elseif resp == ExpParams.rKey
        fprintf('  More Right\n');
    end

    Screen('Close');
    response(1,trial) = cont_trial;
    response(2,trial) = resp;
    RT(trial) = secs;

    save('jnd_dat','response');
    
end
    ShowCursor;
    ListenChar(0);
%% Estimate proportion of p(brighter) for each contrast value

hits = zeros(1,8);

for i = 1:size(response,2)
    
    for j = 1:length(GP.oris)
        
        if response(1,i) == j && response(2,i) == ExpParams.lKey
            
            hits(1,j) = hits(1,j)+1;
            
        end
        
    end
    
end

caxis = GP.oris;
data = [caxis' hits' 16.*ones(8,1)];

sca;

end
