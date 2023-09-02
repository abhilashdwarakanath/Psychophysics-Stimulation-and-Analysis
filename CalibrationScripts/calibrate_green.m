function g_points = calibrate_green(GP,Params)

g_table = [zeros(256,1) (0:255)' zeros(256,1)];

[w,GP.screenRect]=Screen('OpenWindow',GP.screenNumber,[0 0 0],GP.screen_res);
Screen('FillRect',w,g_table(1,1:3));
Screen('Flip',w);
c = 1;
g_points = [0,0,0];
[v,keyCode] = KbWait([],2);

while keyCode(Params.proceedKey) ~= 1
    
    [v,keyCode] = KbWait([],2);
    
    if keyCode(Params.endKey)
        
        sca;
        break;
        
    end
    
    if keyCode(Params.uKey)
        
        c = c+GP.steps;
        if c < 1
            
            c = 1;
            
        elseif c >= 255
            
            sca;
            break;
            
        end
        Screen('FillRect',w,g_table(c,1:3));
        Screen('Flip',w);
        g_points = [g_points;g_table(c,1:3)];
        Screen('Close');
        
        
    elseif keyCode(Params.dKey)
        
        c = c-GP.steps;
        if c < 1
            
            c = 1;
            
        elseif c >= 255
            
            sca;
            break;
            
        end
        Screen('FillRect',w,g_table(c,1:3));
        Screen('Flip',w);
        g_points = [g_points;g_table(c,1:3)];
        Screen('Close');
        
    end

end

end