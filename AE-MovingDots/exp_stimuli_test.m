function exp_stimuli_test(ExpParams,Names,display,esound,dots)
    
    numblocks = 5;
    filename = Names.fileNameTest;

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



% Start the experiment

%conds = [-1 -0.875 -0.75 0.75 0.875 1];
%conds = [-1 -0.75 -0.5 -0.25 0 0.25 0.5 0.75 1];
%conds = [-0.75 0 0.75];
conds = linspace(-0.7,0.7,5);
ExpParams.trials = length(conds)*2;
responses = zeros(numblocks,ExpParams.trials);
trial_order = zeros(numblocks,ExpParams.trials);
freq_order = zeros(numblocks,ExpParams.trials);
gOr_targets = zeros(numblocks,ExpParams.trials);

quitval = 0;


c = 0;

for i = 1:numblocks
    
    c = c+1;

        m(1,:) = [zeros(1,2*length(conds))];
        m(2,:) = [repmat(conds,1,2)];
        m(3,:) = [repmat(1:length(conds),1,2)];
    
    m = shuffle2(m);
    
    f01 = m(1,:);
    g_targets = m(2,:);
    order = m(3,:);
    
    % Generate the sound signal, the gabors, the order of trials and fixation cross
    
    log_rec = sprintf('\nBlock %d of %d',c,numblocks);
    disp(log_rec);
    
    response = [];
    
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
    
    % Start trials
    
    log_rec = sprintf('\nStarting trials... \n');
    disp(log_rec);
    
    for j = 1:ExpParams.trials
        
        f0 = f01(j);
        quitval = 0;
        gOr_target = g_targets(j);
        
        log_rec=sprintf('Trial %d of %d. Trial Type - %d Target Coherence: %d. Frequency band: %d ',j,ExpParams.trials,order(j),g_targets(j),f01(j));
        disp(log_rec);
        
        [esound] = generateSignals(esound,f0);
        [response,quitval] = stim_s_b(ExpParams,Names,dots,esound,display,gOr_target,c,response,f01,g_targets,quitval);        
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
    
    Screen('DrawText',display.windowPtr,'Please take a break...',display.screenCentre(1)-200,display.screenCentre(2),[255 255 255]);
    Screen('Flip',display.windowPtr);
    WaitSecs(3);
    
    log_rec=sprintf('End of block: %d \n',i);
    disp(log_rec);

    responses(c,:) = response;
    freq_order(c,:) = f01;
    trial_order(c,:) = order;
    gOr_targets(c,:) = g_targets;
    
    save(filename,'gOr_targets','freq_order','responses','trial_order')
    
end

%% Saving relevant files

if quitval == 1
    sca;
    ListenChar(0);
    return;
    
end

% At the end of the experiment, save all, close all screens, exit

Screen('DrawText',display.windowPtr,'Well done! Here ends the current phase.',display.screenCentre(1)-200,display.screenCentre(2),[255 255 255]);
Screen('Flip',display.windowPtr);
WaitSecs(3);

log_rec=sprintf('End of experiment, saving and exiting. Thanks for playing... \n');
disp(log_rec);

save(filename,'gOr_targets','freq_order','responses','trial_order');

resplog(:,1) = responses(:);
resplog(:,2) = freq_order(:);
resplog(:,3) = trial_order(:);
resplog(:,4) = gOr_targets(:);
save('resplogtest','resplog','conds');

ListenChar(0);
ShowCursor;
sca;

end

%%--------------------------------------------------------------------------END-------------------------------------------------------------------------------%%
