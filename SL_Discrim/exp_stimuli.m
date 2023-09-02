function [gOr_targets,freq_order, trial_order, responses] = exp_stimuli(ExpParams,GP,Names,w,type)

if type == 'c'
    filename = Names.fileNameC;
    logfile = Names.logFileC;
elseif type == 't'
    filename = Names.fileNameT;
    logfile = Names.logFileT;
end

clc

ExpParams.trials = 350;
GP.gCont = 35;

%% Present stimuli

log_rec = sprintf('\n Loading data... \n');
disp(log_rec);
dlmwrite(logfile, log_rec, '-append');

log_rec = sprintf('\n Generating empty screen and fixation cross... \n');
disp(log_rec);
dlmwrite(logfile, log_rec, '-append');

gFix = local_make_Gabor(GP.imgSize,GP.img_bgnd,24,GP.gBand,0/180*pi,0);
gFix(GP.centre(1)+(-2:2),GP.centre(2)+(-2:2)) = 255;

ListenChar(2);
HideCursor;

log_rec = sprintf('\nStarting experiment... \n');
disp(log_rec);
dlmwrite(logfile, log_rec, '-append');

% Initialise response collection variables and quit value (to exit the loop
% if required)

responses = zeros(ExpParams.blocks,ExpParams.trials);
trial_order = zeros(ExpParams.blocks,ExpParams.trials);
gOr_targets = zeros(ExpParams.blocks,ExpParams.trials);
freq_order = zeros(ExpParams.blocks,ExpParams.trials);
quitVal = 0;

% Start the experiment

f1 = ExpParams.association(1,1);
f2 = ExpParams.association(2,1);

g1 = ExpParams.association(1,2);
g2 = ExpParams.association(2,2);

for i = 1:ExpParams.blocks
    
    m(1,:) = [f1.*ones(1,105) round(502+(1014-502).*rand(1,35)) zeros(1,35) f2.*ones(1,105) round(502+(1014-502).*rand(1,35)) zeros(1,35)];
    m(2,:) = ([g1.*ones(1,105) g1.*ones(1,35) g1.*ones(1,35) g2.*ones(1,105) g2.*ones(1,35) g2.*ones(1,35)]);
    m(3,:) = [repmat(1:7,1,15) repmat(1:7,1,5) repmat(1:7,1,5) repmat(1:7,1,15) repmat(1:7,1,5) repmat(1:7,1,5)];
        
    m = shuffle2(m);
    
    f01 = m(1,:);
    g_targets = m(2,:);
    order = m(3,:);
    
    % Generate the sound signal, the gabors, the order of trials and fixation cross
    
    log_rec = sprintf('\nBlock %d of %d',i,ExpParams.blocks);
    disp(log_rec);
    dlmwrite(logfile, log_rec, '-append');
    
    response = [];
    
    Screen('DrawText', w, 'Press Enter to continue', GP.screen_centre(1)-200,GP.screen_centre(2), [255 255 255]);
    Screen('Flip', w);
    
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
        
        if mod(j,30) == 0
            
            WaitSecs(0.2);
            
            Screen('DrawText',w,'Time for a break! Press Enter to continue', GP.screen_centre(1)-200,GP.screen_centre(2), [255 255 255]);
            Screen('Flip',w);
            
            KbWait;
            
            [v,v,keyCode] = KbCheck;
            
            while keyCode(ExpParams.proceedKey) ~= 1
                
                [v,v,keyCode] = KbCheck;
                
                if keyCode(ExpParams.endKey)
                    
                    quitVal = 1;
                    
                    log_rec=sprintf('Voluntarily exited... \n');
                    disp(log_rec);
                    dlmwrite(logfile, log_rec, '-append');
                    
                    if type == 'c'
                        save([Names.subjName 'UfnBlockC' num2str(i)],'g_targets','f01','response','order');
                    elseif type == 't'
                        save([Names.subjName 'UfnBlockT' num2str(i)],'g_targets','f01','response','order');
                    end
                    
                    Screen('DrawText',w,'You have exited voluntarily...',GP.screen_centre(1)-200,GP.screen_centre(2),[255 255 255]);
                    Screen('Flip',w);
                    WaitSecs(3);
                    sca;
                    ListenChar(0);
                    return;
                    
                end
                
            end
            
        end
        
        f0 = f01(j);
        
        gOr_target = g_targets(j);
        
        [s,standard] = generateSignals(ExpParams,GP,f0);
        
        log_rec=sprintf('Trial %d of %d. Trial Type - %d Target ORI: %d. Frequency band: %d ',j,ExpParams.trials,order(j),gOr_target,f01(j));
        disp(log_rec);
        dlmwrite(logfile, log_rec, '-append');
        
        id_std = Screen('MakeTexture',w,standard);
        
        id_fix=Screen('MakeTexture', w, gFix);
        %id_spgabor=Screen('MakeTexture', w, G);
        
        % Present fixation cross for 0.75 s
        % Play sound
        % Wait 0.6s to avoid cue integration
        
        Screen('DrawTexture', w, id_fix);
        Screen('Flip', w);
        WaitSecs(0.3+(0.5-0.3).*rand(1));
        
        % If AFC is run first - if mod(i,2) ~= 0
        % If MOA is run first - if mod(i,2) == 0
        
        if mod(i,2) ~= 0
            Screen('DrawTexture',w,id_std,[],[],gOr_target);
            Screen('Flip',w);
            WaitSecs(GP.ifi*2);
            response = stim_ct(ExpParams,Names,GP,w,s,id_fix,gOr_target,i,order(j),response,logfile,type,f01,order);
            
        else
            Screen('DrawTexture',w,id_std,[],[],gOr_target);
            Screen('Flip',w);
            WaitSecs(GP.ifi*2);
            response = stim_joystick(ExpParams,Names,GP,w,s,id_fix,gOr_target,i,order(j),response,logfile,type,g_targets,f01,order);
            
        end
        
        % If end key has been pressed, close all screens, save all variables
        % and exit
        
        if quitVal == 1
            sca;
            ListenChar(0);
            return;
            
        end
        
    end
    
    if quitVal == 1
        sca;
        ListenChar(0);
        return;
        
    end
    
    Screen('DrawText',w,'End of block. The next one begins shortly...',GP.screen_centre(1)-200,GP.screen_centre(2),[255 255 255]);
    Screen('Flip',w);
    WaitSecs(3);
    
    log_rec=sprintf('End of block: %d \n',i);
    disp(log_rec);
    dlmwrite(logfile, log_rec, '-append');
    responses(i,:) = response;
    freq_order(i,:) = f01;
    trial_order(i,:) = order;
    gOr_targets(i,:) = g_targets;
    save(filename,'gOr_targets','freq_order','responses','trial_order')
    
end

%% Saving relevant files

% At the end of the experiment, save all, close all screens, exit

Screen('DrawText',w,'Well done! Here ends the experiment.',GP.screen_centre(1)-200,GP.screen_centre(2),[255 255 255]);
Screen('Flip',w);
WaitSecs(3);

log_rec=sprintf('End of experiment, saving and exiting. Thanks for playing... \n');
disp(log_rec);
dlmwrite(logfile, log_rec, '-append');

save(filename,'gOr_targets','freq_order','responses','trial_order');

ListenChar(0);
ShowCursor;
sca;

end

%%--------------------------------------------------------------------------END-------------------------------------------------------------------------------%%