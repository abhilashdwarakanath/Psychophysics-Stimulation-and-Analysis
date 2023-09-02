function [data] = estimate_jnd(ExpParams,GP,w)

%==========================================================================
% parameters and stimulus order
%==========================================================================
Ntrial = 128;

for k=1:16
    ContrastOrder(k,:) = randperm(8);
end

ContrastOrder = ContrastOrder'; ContrastOrder =ContrastOrder(:);

GOOD_KEYS = [ExpParams.lKey,ExpParams.rKey];

GP.subject_cont = GP.gCont;
GP.gFreq = 48+3*randn;

%==========================================================================
% CREATE GABORS
%==========================================================================

% Set of different contrasts gabors

GP.oris = fliplr([(20) (15) (10) (5) 0 (-5) (-10) (-15)]);

% Fixation dot

gEmpty = local_make_Gabor(GP.imgSize,GP.img_bgnd,GP.gFreq,GP.gBand,0/180*pi,0);
gEmpty(GP.centre(1)+(-2:2),GP.centre(2)+(-2:2)) = 255;

gStd = local_make_Gabor(GP.imgSize,GP.img_bgnd,GP.gFreq,GP.gBand,0,GP.subject_cont);
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
    
    sf = 48+3*randn;
    while sf < 36
        sf = 48+3*randn;
    end
    
    gStd = local_make_Gabor(GP.imgSize,GP.img_bgnd,sf,GP.gBand,0,GP.subject_cont);
    
    cont_trial = ContrastOrder(trial);
    stds = shuffle([41.*ones(1,Ntrial/2) 133.*ones(1,Ntrial/2)]);
    
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
    Screen('DrawText', w, 'ANTICLOCKWISE ? CLOCKWISE', GP.screen_centre(1)-200,GP.screen_centre(2),[255 255 255]);
    Screen('Flip', w);
    [secs, keyCode] = KbWait([],2);
    resp = find(keyCode);
    if sum(resp==GOOD_KEYS)==0
        resp = NaN;
    end
    
    if resp == ExpParams.lKey
        fprintf('  ACW\n');
    elseif resp == ExpParams.rKey
        fprintf('  CW\n');
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
        
        if response(1,i) == j && response(2,i) == ExpParams.rKey
            
            hits(1,j) = hits(1,j)+1;
            
        end
        
    end
    
end

caxis = GP.oris;
data = [caxis' hits' 16.*ones(8,1)];

sca;

sca;

end
