function stim_exp(GP,w,s,id_fix,id_spgabor)

Screen('DrawTexture', w, id_fix);
Screen('Flip', w);
WaitSecs(0.2+(0.5-0.2).*rand(1));
PsychPortAudio('FillBuffer', GP.pahandle, s);
PsychPortAudio('Start', GP.pahandle); 

% Flash stimulus for two refresh-rates

Screen('DrawTexture', w, id_fix);
t0 = Screen('Flip',w);
dt = ((0.075+(0.15-0.075).*rand(1)));
Screen('DrawTexture',w,id_spgabor);
t1 = Screen('Flip',w,t0+dt);
Screen('DrawTexture',w,id_fix);
Screen('Flip',w,t1+GP.ifi*10);

PsychPortAudio('Stop', GP.pahandle); 

end
