function [response,quitval] = stim_s_b(ExpParams,Names,dots,esound,display,gOr_target,c,response,f01,g_targets,quitval)

% Set direction and coherence

% if gOr_target < 0
%     dots.coherence = abs(gOr_target);
%     dots.direction = 270;
% elseif gOr_target > 0
%     dots.coherence = gOr_target;
%     dots.direction = 90;
% elseif gOr_target == 0
%     dots.coherence = 0;
%     dots.direction = rand;
% end 

dots.coherence = gOr_target;

% Show fixation cross

fixTime = 0.5; %s
fixFrames = round(fixTime*(1/display.ifi));

for i=1:fixFrames
    drawBlank(display);
end

% Play sound
    
PsychPortAudio('FillBuffer', esound.pahandle, esound.s);
PsychPortAudio('Start', esound.pahandle);

% Present stimulus and show fixation cross
redflag = 

movingDots2(dots,display,redflag);

% for i=1:fixFrames
%     drawFixation(display);
% end

drawBlank(display);

% Ask for and collect responses

[v,v,keyCode1] = KbCheck;
while sum([keyCode1(ExpParams.endKey) keyCode1(ExpParams.lKey) keyCode1(ExpParams.rKey)]) ~= 1
    
    [v,v,keyCode1] = KbCheck;
    
end

if keyCode1(ExpParams.endKey)
    
    resp = NaN;
    
    quitval = 1;
    
    log_rec=sprintf('Voluntarily exited... \n');
    disp(log_rec);
    %dlmwrite(logfile, log_rec, '-append');
    
    % Collect responses and save every trial. Each variable is saved in
    % its own file.
    
    response = [response resp]; %#ok<*NASGU>
    drawBlank(display);
    WaitSecs(0.01);
    
    save([Names.subjName 'UfnBlock' num2str(c)],'f01','response','g_targets');
    
    Screen('DrawText',display.windowPtr,'You have exited voluntarily...',display.screenCentre(1)-200,display.screenCentre(2),[255 255 255]);
    Screen('Flip',display.windowPtr);
    WaitSecs(1);
    sca;
    return;
    
elseif keyCode1(ExpParams.lKey)
    
    resp = ExpParams.lKey;
    
    quitval = 0;
    
    log_rec=sprintf('More left \n');
    
    disp(log_rec);
    %dlmwrite(logfile, log_rec, '-append');
    
    % Collect responses and save every trial. Each variable is saved in
    % its own file.
    
    response = [response resp];
    drawBlank(display);
    WaitSecs(0.001);
    
    save([Names.subjName 'UfnBlock' num2str(c)],'f01','response','g_targets');
    
elseif keyCode1(ExpParams.rKey)
    
    resp = ExpParams.rKey;
    
    quitval = 0;
    
    log_rec=sprintf('More right \n');
    
    disp(log_rec);
    %dlmwrite(logfile, log_rec, '-append');
    
    % Collect responses and save every trial. Each variable is saved in
    % its own file.
    
    response = [response resp];
    drawBlank(display);
    WaitSecs(0.001);
    
    save([Names.subjName 'UfnBlock' num2str(c)],'f01','response','g_targets');
    
end

