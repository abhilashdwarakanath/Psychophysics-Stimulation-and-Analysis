function exp_stimuli(ExpParams,GP,Names,w,type)

    ExpParams.blocks = ExpParams.blocks*2;
    filename = Names.fileName;
    logfile = Names.logFile;
clc

%% Present stimuli

log_rec = sprintf('\n Loading data... \n');
disp(log_rec);
dlmwrite(logfile, log_rec, '-append');

log_rec = sprintf('\n Generating empty screen and fixation cross... \n');
disp(log_rec);
dlmwrite(logfile, log_rec, '-append');

gEmpty = local_make_Gabor(GP.imgSize,GP.img_bgnd,GP.gFreq(1),GP.gBand,0/180*pi,0);
gFix = local_make_Gabor(GP.imgSize,GP.img_bgnd,GP.gFreq(1),GP.gBand,0/180*pi,0);
gFix(GP.centre(1)+(-2:2),GP.centre(2)+(-2:2)) = 255;

ListenChar(2);
HideCursor;

log_rec = sprintf('\nStarting experiment... \n');
disp(log_rec);
dlmwrite(logfile, log_rec, '-append');

id_empty(1) = Screen('MakeTexture', w(1), gEmpty);
id_empty(2) = Screen('MakeTexture', w(2), gEmpty);
Screen('DrawTexture',w(1),id_empty(1));
Screen('DrawTexture',w(2),id_empty(2));
Screen('Flip',w(1));
Screen('Flip',w(2));

% Initialise response collection variables and quit value (to exit the loop
% if required)
% Start the experiment

responses = zeros(ExpParams.blocks,ExpParams.trials);
trial_type = zeros(ExpParams.blocks,ExpParams.trials);
trial_order = zeros(ExpParams.blocks,ExpParams.trials);

quitVal = 0;

blank = local_make_Gabor(GP.imgSize,GP.img_bgnd,GP.gFreq,GP.gBand,0,0);

% Start the experiment

for i = 1:ExpParams.blocks
    
    m(1,:) = ([ones(1,70) zeros(1,70)]);
    m(2,:) = ([ones(1,70) 2.*ones(1,70)]);
    m(3,:)= [ones(1,70) 2.*ones(1,70)];
    m(4,:)= [2.*ones(1,70) ones(1,70)];
    
    m = shuffle2(m);
    
    order = m(1,:);
    trialtypes = m(2,:);
    
    % Generate the sound signal, the gabors, the order of trials and fixation cross
    
    log_rec = sprintf('\nBlock %d of %d',i,ExpParams.blocks);
    disp(log_rec);
    dlmwrite(logfile, log_rec, '-append');
    
    response = [];
    
    Screen('DrawText', w(1), 'Press Enter to continue', 550, 400, [255 255 255]);
    Screen('DrawText', w(2), 'Press Enter to continue', 550, 400, [255 255 255]);
    Screen('Flip', w(1));
    Screen('Flip', w(2));
    
    KbWait;
    
    [v,v,keyCode] = KbCheck;
    
    while sum([keyCode(ExpParams.proceedKey) keyCode(ExpParams.endKey)]) ~= 1
        
        [v,v,keyCode] = KbCheck;
        
        if keyCode(ExpParams.endKey)
            
            sca;
            break;
            
        end
        
    end
    
    % Start trials
    
    log_rec = sprintf('\nStarting trials... \n');
    disp(log_rec);
    dlmwrite(logfile, log_rec, '-append');
    
    for j = 1:ExpParams.trials
        
        if mod(j,35) == 0
            
            WaitSecs(0.2);
            
            Screen('DrawText',w(1),'Time for a break! Press Enter to continue', 450,400, [255 255 255]);
            Screen('DrawText',w(2),'Time for a break! Press Enter to continue', 450,400, [255 255 255]);
            Screen('Flip',w(1));
            Screen('Flip',w(2));
            
            KbWait;
            
            [v,v,keyCode] = KbCheck;
            
            while keyCode(ExpParams.proceedKey) ~= 1
                
                [v,v,keyCode] = KbCheck;
                
                if keyCode(ExpParams.endKey)
                    
                    quitVal = 1;
                    
                    log_rec=sprintf('Voluntarily exited... \n');
                    disp(log_rec);
                    dlmwrite(logfile, log_rec, '-append');

                        save([Names.subjName 'UfnBlock' num2str(i)],'s_targets','response','order');
                    
                    sca;
                    return;
                    
                end
                
            end
            
        end
        
        [stim,mask] = generateSignals(GP,j);
        
        if rand > 0.5
            mon1 = w(1);
        else
            mon2 = w(2);
        end
        
        log_rec=sprintf('Trial %d of %d. Trial Type - %d Target Tilt: %d',j,ExpParams.trials,trialtypes(j),order(j));
        disp(log_rec);
        dlmwrite(logfile, log_rec, '-append');
        
        id_blank = Screen('MakeTexture', w(1), blank);
        id_fix(1)=Screen('MakeTexture', w(1), gFix);
        id_fix(2)=Screen('MakeTexture', w(2), gFix);
        id_stim=Screen('MakeTexture', mon1, stim);
        id_mask=Screen('MakeTexture', mon2, mask);
        
        if trialtype(j) == 0 % bfs
            
            stim_exp(GP,w,aobj,id_fix,id_G1,id_G2,id_check,id_blank,t_order,j);
            
        else % 1 = PA
            
            stim_ct(GP,w,aobj,id_fix,id_G1,id_G2,id_check,id_blank,t_order,j)
            
        end
        
        % Ask participant to set perceived orientation
        
        bdown=0;
        
        th = 0; % initial rotation angle (degrees)
        
        SetMouse(m(6,j),540); % Set random start pos to remove bias
        
        if keyCode(ExpParams.endKey)
            
            log_rec=sprintf('Voluntarily exited... \n');
            disp(log_rec);
            dlmwrite(logfile, log_rec, '-append');
            
            if type == 'c'
                save([Names.subjName 'UfnBlockC' num2str(i)],'s_targets','response','order');
            elseif type == 't'
                save([Names.subjName 'UfnBlockT' num2str(i)],'s_targets','response','order');
            elseif type == 'e'
                save([Names.subjName 'UfnBlockExp' num2str(i)],'s_targets','response','order');
            end
            
            sca;
            return;
            
        else
            
            while(~any(bdown)) % exit loop if mouse button is pressed
                [x,y,bdown]=GetMouse;
                th=(180*((x-1600)/3200));
                Screen('DrawTexture',w(1),id_G2(1),[],[],th);
                Screen('DrawTexture',w(2),id_G2(2),[],[],th);
                Screen('Flip',w(1));
                Screen('Flip',w(2));
            end
        end
        Screen('Close');
        resp = th;
        response = [response resp];
        
        if type == 'c'
            save([Names.subjName 'UfnBlockC' num2str(i)],'s_targets','response','order');
        elseif type == 't'
            save([Names.subjName 'UfnBlockT' num2str(i)],'s_targets','response','order');
        elseif type == 'e'
            save([Names.subjName 'UfnBlockExp' num2str(i)],'s_targets','response','order');
        end
        
        if quitVal == 1
            sca;
            responses(i,:) = response;
            sOr_targets(i,:) = s_targets;
            trial_order(i,:) = order;
            save(filename,'sOr_targets','responses','trial_order')
            return;
            
        end
        
    end
    
    if quitVal == 1
        sca;
        responses(i,:) = response;
        sOr_targets(i,:) = s_targets;
        trial_order(i,:) = order;
        save(filename,'sOr_targets','responses','trial_order')
        return;
        
    end
    
    Screen('DrawText',w,'End of block. The next one begins shortly...',GP.screen_centre(1)-200,GP.screen_centre(2),[255 255 255]);
    Screen('Flip',w);
    WaitSecs(3);
    
    log_rec=sprintf('End of block: %d \n',i);
    disp(log_rec);
    dlmwrite(logfile, log_rec, '-append');
    responses(i,:) = response;
    sOr_targets(i,:) = s_targets;
    trial_order(i,:) = order;
    save(filename,'sOr_targets','responses','trial_order');
    
end

%% Saving relevant files

% At the end of the experiment, save all, close all screens, exit

Screen('DrawText',w,'Well done! Here ends the experiment.',GP.screen_centre(1)-200,GP.screen_centre(2),[255 255 255]);
Screen('Flip',w);
WaitSecs(3);

log_rec=sprintf('End of experiment, saving and exiting. Thanks for playing... \n');
disp(log_rec);
dlmwrite(logfile, log_rec, '-append');

save(filename,'sOr_targets','responses','trial_order');

ListenChar(0);
ShowCursor;
sca;

end

%%--------------------------------------------------------------------------END-------------------------------------------------------------------------------%%