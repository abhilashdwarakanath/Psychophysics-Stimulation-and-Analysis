function exposure_stimulus2(ExpParams,GP,Names,w)

filename = Names.fileNameExp;
logfile = Names.logFileExp;

clc

ExpParams.trials = 400;

%% Present stimuli

log_rec = sprintf('\n Loading data... \n');
disp(log_rec);
dlmwrite(logfile, log_rec, '-append');

log_rec = sprintf('\n Generating empty screen and fixation cross... \n');
disp(log_rec);
dlmwrite(logfile, log_rec, '-append');

gEmpty = local_make_Gabor(GP.imgSize,GP.img_bgnd,48,GP.gBand,0/180*pi,0);
gFix = local_make_Gabor(GP.imgSize,GP.img_bgnd,48,GP.gBand,0/180*pi,0);
gFix(GP.centre(1)+(-2:2),GP.centre(2)+(-2:2)) = 255;

ListenChar(2);
HideCursor;

log_rec = sprintf('\nStarting experiment... \n');
disp(log_rec);
dlmwrite(logfile, log_rec, '-append');

id_empty = Screen('MakeTexture', w, gEmpty);
Screen('DrawTexture',w,id_empty);
Screen('Flip',w);

% Initialise response collection variables and quit value (to exit the loop
% if required)
% Start the experiment

match = 1;
conflict = 2;

f1 = ExpParams.association(1,1);
f2 = ExpParams.association(2,1);

g1 = (ExpParams.association(1,2));
g2 = (ExpParams.association(2,2));

responses = zeros(ExpParams.blocks-1,ExpParams.trials);
trial_order = zeros(ExpParams.blocks-1,ExpParams.trials);
freq_order =zeros(ExpParams.blocks-1,ExpParams.trials);
gOr_targets = zeros(ExpParams.blocks-1,ExpParams.trials);
directions = zeros(ExpParams.blocks-1,ExpParams.trials);

quitVal = 0;

% Start the experiment

for i = 1:ExpParams.blocks*2
    clear m
    clear n
    m(1,:) = [f1.*ones(1,150) f2.*ones(1,150)]; n(1,:) = shuffle([391.*ones(1,25) 589.*ones(1,25) 871.*ones(1,25) 943.*ones(1,25)]);
    m(2,:) = [g1.*ones(1,150) g2.*ones(1,150)]; n(2,:) = shuffle([9.*ones(1,25) 71.*ones(1,25) 92.*ones(1,25) 173.*ones(1,25)]);
    m(3,:) = [match.*ones(1,300)]; n(3,:) = conflict.*ones(1,100);
    mm(1,:) = [m(1,:) n(1,:)];
    mm(2,:) = [m(2,:) n(2,:)];
    mm(3,:) = [m(3,:) n(3,:)];
    n1 = shuffle([ones(1,ExpParams.trials/2) 2.*ones(1,ExpParams.trials/2)]);
    n2 = zeros(1,ExpParams.trials);
    ind1 = find(n1==1);
    n2(ind1) = 2;
    n2(n2==0) = 1;
    clear m
    m = shuffle2(mm);
    
    f01 = m(1,:);
    g_targets = m(2,:);
    order = m(3,:);
    direction = [n1;n2];
    
    % Generate the sound signal, the gabors, the order of trials and fixation cross
    
    log_rec = sprintf('\nBlock %d of %d',i,ExpParams.blocks);
    disp(log_rec);
    dlmwrite(logfile, log_rec, '-append');
    
    response = [];
    
    Screen('DrawText', w, 'Press Enter to continue', 550, 400, [255 255 255]);
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
        
        if mod(j,50) == 0
            
            WaitSecs(0.2);
            
            Screen('DrawText',w,'Time for a break! Press Enter to continue', 450,400, [255 255 255]);
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
                    
                    sca;
                    return;
                    
                end
                
            end
            
        end

        
        gOr_target = g_targets(j); % Set the target gabor orientation from association.mat
        
        gOr_rest = gOr_target + 3*randn;
        
        while abs(gOr_target - gOr_rest) <= 15
            gOr_rest = gOr_target + 3*randn;
        end

        GP.gFreq = 48+4*randn;
        dir = direction(:,j);
        
        [s,G,sample_G] = generateSignals2(ExpParams,GP,gOr_target,gOr_rest,f01(j),dir);
        
        log_rec=sprintf('Trial %d of %d. Trial Type - %d Target orientation: %d. Frequency band: %d',j,ExpParams.trials,order(j),gOr_target,f01(j));
        disp(log_rec);
        dlmwrite(logfile, log_rec, '-append');
        
        id_fix=Screen('MakeTexture', w, gFix);
        id_spgabor=Screen('MakeTexture', w, G);
        id_sample=Screen('MakeTexture', w, sample_G);
        
        % Present fixation cross for 0.75 s
        % Play sound
        % Wait 0.6s to avoid cue integration
        
        stim_exp(GP,w,s,id_fix,id_spgabor);
        
        % Look for key-response. If any other key apart from the End
        % key, YES key and NO has been preseed, register NaNs for response
        % and reaction time. If detected=YES, input 1, else 0. Record
        % reaction time as the time-stamp of the keypress - timestamp of
        % first flip (sot = stimulus onset time). If end key has been pressed, set quitVal to 1=QUIT.
        
        WaitSecs(round((0.5+(0.8-0.5).*rand(1))));
        
        Screen('DrawTexture', w, id_sample);
        Screen('DrawText', w, '?', GP.screen_centre(1),GP.screen_centre(2),[255 255 255]);
        Screen('Flip', w);
        
        [v,secs,keyCode1] = KbCheck;
        
        while sum([keyCode1(ExpParams.endKey) keyCode1(ExpParams.rKey) keyCode1(ExpParams.lKey)]) ~= 1
            
            [v,v,keyCode1] = KbCheck;
            
        end
        
        [resp,quitVal] = an_resp(GP,Names,ExpParams,dir,keyCode1,logfile,response,direction,j,order,quitVal);
        
        response = [response resp];
        WaitSecs(round((0.3+(0.5-0.3).*rand(1))));
        Screen('Close')
        
        % If end key has been pressed, close all screens, save all variables
        % and exit
        
        if quitVal == 1
            sca;
            ListenChar(0);
            return;
            
        end
        
    end
    
    Screen('DrawText',w,'End of block. The next one begins shortly...',GP.screen_centre(1)-200,GP.screen_centre(2),[255 255 255]);
    Screen('Flip',w);
    WaitSecs(3);
    
    log_rec=sprintf('End of block: %d \n',i);
    disp(log_rec);
    dlmwrite(logfile, log_rec, '-append');
    
    responses(i,:) = response;
    trial_order(i,:) = order;
    freq_order(i,:) = f01;
    gOr_targets(i,:) = g_targets;
    directions(i,:) = direction(2,:);
    save(filename,'directions','gOr_targets','freq_order','responses','trial_order');
    
end

%% Saving relevant files

% At the end of the experiment, save all, close all screens, exit

Screen('DrawText',w,'Well done! Here ends the Training.',GP.screen_centre(1)-200,GP.screen_centre(2),[255 255 255]);
Screen('Flip',w);
WaitSecs(3);

log_rec=sprintf('End of experiment, saving and exiting. Thanks for playing... \n');
disp(log_rec);
dlmwrite(logfile, log_rec, '-append');

ListenChar(0);
ShowCursor;
sca;

end

%%--------------------------------------------------------------------------END-------------------------------------------------------------------------------%%
