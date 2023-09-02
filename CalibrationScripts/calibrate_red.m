function r_points = calibrate_red(GP,Params)

r_table = [(0:255)' zeros(256,2)];

[w,GP.screenRect]=Screen('OpenWindow',GP.screenNumber,[0 0 0],GP.screen_res);
Screen('FillRect',w,r_table(1,1:3));
Screen('Flip',w);
c = 1;
r_points = [0,0,0];
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
        Screen('FillRect',w,r_table(c,1:3));
        Screen('Flip',w);
        r_points = [r_points;r_table(c,1:3)];
        Screen('Close');
        
        
    elseif keyCode(Params.dKey)
        
        c = c-GP.steps;
        if c < 1
            
            c = 1;
            
        elseif c >= 255
            
            sca;
            break;
            
        end
        Screen('FillRect',w,r_table(c,1:3));
        Screen('Flip',w);
        r_points = [r_points;r_table(c,1:3)];
        Screen('Close');
        
    end

    
end

end