function b_points = calibrate_blue(GP,Params)

b_table = [zeros(256,2) (0:255)'];

[w,GP.screenRect]=Screen('OpenWindow',GP.screenNumber,[0 0 0],GP.screen_res);
Screen('FillRect',w,b_table(1,1:3));
Screen('Flip',w);
c = 1;
b_points = [0,0,0];
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
        Screen('FillRect',w,b_table(c,1:3));
        Screen('Flip',w);
        b_points = [b_points;b_table(c,1:3)];
        Screen('Close');
        
        
    elseif keyCode(Params.dKey)
        
        c = c-GP.steps;
        if c < 1
            
            c = 1;
            
        elseif c >= 255
            
            sca;
            break;
            
        end
        Screen('FillRect',w,b_table(c,1:3));
        Screen('Flip',w);
        b_points = [b_points;b_table(c,1:3)];
        Screen('Close');
        
    end

end

end