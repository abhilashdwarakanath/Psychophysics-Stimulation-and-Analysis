function response = stim_ct(ExpParams,Names,GP,w,s,id_fix,gOr_target,i,j,response,logfile,type,f01,order)

if j == 1
    dev = -7.5*GP.jnd;
elseif j == 2
    dev = -5*GP.jnd;
elseif j == 3
    dev = -2.5*GP.jnd;
elseif j == 4
    dev = 0;
elseif j == 5
    dev = 2.5*GP.jnd;
elseif j == 6
    dev = 5*GP.jnd;
elseif j == 7
    dev = 7.5*GP.jnd;
end

Screen('DrawTexture', w, id_fix);
Screen('Flip', w);
WaitSecs(0.6+(0.9-0.6).*rand(1));
PsychPortAudio('FillBuffer', GP.pahandle, s);
PsychPortAudio('Start', GP.pahandle);
%WaitSecs(0.075+(0.15-0.075).*rand);

% Flash stimulus for two refresh-rates

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
        Screen('DrawTexture',w,id_spgabor,[],[],gOr_target+dev);
        Screen('Flip',w);
        Screen('DrawTexture',w,id_spgabor,[],[],gOr_target+dev);
        Screen('Flip',w);
        %Screen('Close');
    else
        Screen('DrawTexture',w,id_noise);
        Screen('Flip',w);
        %Screen('Close');
    end
    
end

% Screen('DrawTexture', w, id_fix);
% t0 = Screen('Flip',w);
% dt = ((0.2+(0.5-0.2).*rand(1)));
% Screen('DrawTexture',w,id_spgabor,[],[],gOr_target+dev);
% t1 = Screen('Flip',w,t0+dt);
% Screen('DrawTexture',w,id_fix);
% Screen('Flip',w,t1+GP.ifi*3);

%PsychPortAudio('Stop', GP.pahandle);

Screen('DrawTexture', w, id_fix);
Screen('Flip', w);
WaitSecs(((0.3+(0.7-0.3).*rand(1))));

Screen('DrawText', w, 'ANTI-CLOCKWISE     - ? -     CLOCKWISE', GP.screen_centre(1)-200,GP.screen_centre(2),[255 255 255]);
[v,sot]=Screen('Flip', w);

[v,secs,keyCode1] = KbCheck;

while sum([keyCode1(ExpParams.endKey) keyCode1(ExpParams.lKey) keyCode1(ExpParams.rKey)]) ~= 1
    
    [v,v,keyCode1] = KbCheck;
    
end

if keyCode1(ExpParams.endKey)
    
    resp = NaN;
    
    quitVal = 1;
    
    log_rec=sprintf('Voluntarily exited... \n');
    disp(log_rec);
    dlmwrite(logfile, log_rec, '-append');
    
    % Collect responses and save every trial. Each variable is saved in
    % its own file.
    
    response = [response resp]; %#ok<*NASGU>
    Screen('Close');
    
    if type == 'c'
        save([Names.subjName 'UfnBlockC' num2str(i)],'f01','response','order');
    elseif type == 't'
        save([Names.subjName 'UfnBlockT' num2str(i)],'f01','response','order');
    end
    
    Screen('DrawText',w,'You have exited voluntarily...',GP.screen_centre(1)-200,GP.screen_centre(2),[255 255 255]);
    Screen('Flip',w);
    WaitSecs(3);
    sca;
    return;
    
elseif keyCode1(ExpParams.lKey)
    
    resp = ExpParams.lKey;
    
    quitVal = 0;
    
    log_rec=sprintf('Recognised as Anti-Clockwise \n');
    
    disp(log_rec);
    dlmwrite(logfile, log_rec, '-append');
    
    % Collect responses and save every trial. Each variable is saved in
    % its own file.
    
    response = [response resp];
    Screen('DrawTexture', w, id_fix);
    Screen('Flip',w);
    WaitSecs(1+(1.5-1)*rand);
    Screen('Close');
    
    
    if type == 'c'
        save([Names.subjName 'UfnBlockC' num2str(i)],'f01','response','order');
    elseif type == 't'
        save([Names.subjName 'UfnBlockT' num2str(i)],'f01','response','order');
    end
    
elseif keyCode1(ExpParams.rKey)
    
    resp = ExpParams.rKey;
    
    quitVal = 0;
    
    log_rec=sprintf('Recognised as Clockwise \n');
    
    disp(log_rec);
    dlmwrite(logfile, log_rec, '-append');
    
    % Collect responses and save every trial. Each variable is saved in
    % its own file.
    
    response = [response resp];
    Screen('DrawTexture', w, id_fix);
    Screen('Flip',w);
    WaitSecs(1+(1.5-1)*rand);
    Screen('Close');
    
    if type == 'c'
        save([Names.subjName 'UfnBlockC' num2str(i)],'f01','response','order');
    elseif type == 't'
        save([Names.subjName 'UfnBlockT' num2str(i)],'f01','response','order');
    end
    
end

end