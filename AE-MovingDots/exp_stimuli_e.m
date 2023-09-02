function exp_stimuli_e(ExpParams,display,esound,dots)

ExpParams.blocks = 1:1:6;
ExpParams.trials = 30;
numblocks = 6;
%numblocks=36;

clc

%% Present stimuli

log_rec = sprintf('\n Loading data... \n');
disp(log_rec);

log_rec = sprintf('\n Generating empty screen and fixation cross... \n');
disp(log_rec);

ListenChar(2);
HideCursor;

log_rec = sprintf('\nStarting experiment... \n');
disp(log_rec);

% Initialise response collection variables and quit value (to exit the loop
% if required)

quitval = 0;

% Start the experiment

f1 = ExpParams.association(1,1);
f2 = ExpParams.association(2,1);

g1 = ExpParams.association(1,2);
g2 = ExpParams.association(2,2);

c = 0;

freq = [f1 f2];
cohs = [g1 g2];

tic;

Screen('DrawText', display.windowPtr, 'Press Enter to continue', display.screenCentre(1)-200,display.screenCentre(2), [255 255 255]);
    Screen('Flip', display.windowPtr);
    
    KbWait;
    
    [v,v,keyCode] = KbCheck;
    
    while sum([keyCode(ExpParams.proceedKey) keyCode(ExpParams.endKey)]) ~= 1
        
        [v,v,keyCode] = KbCheck;
        
        if keyCode(ExpParams.endKey)
            quitval=1;
            sca;
            break;
            
        end
        
    end

for i = 1:numblocks
    c = c+1;
    
    m(1,:) = repmat(freq,1,ExpParams.trials);
    m(2,:) = repmat(cohs,1,ExpParams.trials);
    
    f01 = m(1,:);
    g_targets = m(2,:);
    
    % Generate the sound signal, the gabors, the order of trials and fixation cross
    
    log_rec = sprintf('\nBlock %d of %d',c,numblocks);
    disp(log_rec);
    
%     Screen('DrawText', display.windowPtr, 'Press Enter to continue', display.screenCentre(1)-200,display.screenCentre(2), [255 255 255]);
%     Screen('Flip', display.windowPtr);
%     
%     KbWait;
%     
%     [v,v,keyCode] = KbCheck;
%     
%     while sum([keyCode(ExpParams.proceedKey) keyCode(ExpParams.endKey)]) ~= 1
%         
%         [v,v,keyCode] = KbCheck;
%         
%         if keyCode(ExpParams.endKey)
%             quitval=1;
%             sca;
%             break;
%             
%         end
%         
%     end
    
    % Start trials
    
    log_rec = sprintf('\nStarting trials... \n');
    disp(log_rec);
    
    
    for j = 1:ExpParams.trials*2
        
        quitval = 0;
        f0 = f01(j);
        gOr_target = g_targets(j);
        
        log_rec=sprintf('Trial %d of %d. Target: %d. Frequency band: %d ',j,ExpParams.trials,gOr_target,f01(j));
        disp(log_rec);
        
        [esound] = generateSignals(esound,f0);
        
       [quitval] = stim_s_e(dots,esound,display,gOr_target,quitval);
        % If end key has been pressed, close all screens, save all variables
        % and exit
        
        if quitval == 1
            sca;
            ListenChar(0);
            return;
            
        end
        
    end
    
    if quitval == 1
        sca;
        ListenChar(0);
        return;
        
    end
    
    
    log_rec=sprintf('End of block: %d \n',i);
    disp(log_rec);
    
end

%% Saving relevant files
if quitval == 1
    sca;
    ListenChar(0);
    return;
    
end
% At the end of the experiment, save all, close all screens, exit

Screen('DrawText',display.windowPtr,'Well done! Here ends the experiment.',display.screenCentre(1)-200,display.screenCentre(2),[255 255 255]);
Screen('Flip',display.windowPtr);
WaitSecs(3);

log_rec=sprintf('End of experiment, saving and exiting. Thanks for playing... \n');
disp(log_rec);


%save(filename,'gOr_targets','freq_order','responses','trial_order');

ListenChar(0);
ShowCursor;
sca;
toc;
end

%%--------------------------------------------------------------------------END-------------------------------------------------------------------------------%%
