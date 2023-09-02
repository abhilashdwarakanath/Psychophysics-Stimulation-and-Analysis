function response = stim_joystick(ExpParams,Names,GP,w,s,id_fix,gOr_target,i,j,response,logfile,type,g_targets,f01,order)

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

g0 = local_make_Gabor(GP.imgSize,GP.img_bgnd,48,GP.gBand,0,GP.gCont);
id_0 = Screen('MakeTexture', w, g0);

% Present 0 Gabor

Screen('DrawTexture', w, id_0);
Screen('Flip', w);

bdown=0;

th = 0; % initial rotation angle (degrees)

SetMouse(1440,800); % Set random start pos to remove bias

[~,~,keyCode] = KbCheck;

if keyCode(ExpParams.endKey)
    
    log_rec=sprintf('Voluntarily exited... \n');
    disp(log_rec);
    dlmwrite(logfile, log_rec, '-append');
    
    if type == 'c'
        save([Names.subjName 'UfnBlockC' num2str(i)],'g_targets','f01','response','order');
    elseif type == 't'
        save([Names.subjName 'UfnBlockT' num2str(i)],'g_targets','f01','response','order');
    end
    sca;
    return;
    
else
    
    while(~any(bdown)) % exit loop if mouse button is pressed
        [x,y,bdown]=GetMouse;
        th=(180*((x)/2879));
        Screen('DrawTexture',w,id_0,[],[],th);
        Screen('Flip',w);
    end
end
Screen('DrawTexture', w, id_fix);
Screen('Flip',w);
resp = th;
response = [response resp];
log_rec=sprintf('%d Set to %d. \n',round(gOr_target+dev),round(resp));
    disp(log_rec);
    dlmwrite(logfile, log_rec, '-append');
    
    if type == 'c'
        save([Names.subjName 'UfnBlockC' num2str(i)],'g_targets','f01','response','order');
    elseif type == 't'
        save([Names.subjName 'UfnBlockT' num2str(i)],'g_targets','f01','response','order');
    end
WaitSecs(1+(1.5-1)*rand);
Screen('Close');
