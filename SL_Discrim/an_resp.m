function [resp,quitVal] = an_resp(Names,ExpParams,dir,keyCode1,logfile,response,direction,order,quitVal)

% load resp_right.mat
% resp_right(2,:) = resp_right;
% load resp_wrong.mat
% resp_wrong(2,:) = resp_wrong;

ufn_filename = [Names.subjName 'UfnBlockExp' date];


if keyCode1(ExpParams.endKey)~=1
    
    if dir(2) == 1 && keyCode1(ExpParams.lKey) == 1
        
        resp = 1;
        
        quitVal = 0;
        log_rec=sprintf('CORRECT \n');
        disp(log_rec);
        dlmwrite(logfile, log_rec, '-append');
        save(ufn_filename,'response', 'direction','order');
%         PsychPortAudio('FillBuffer', GP.pahandle, resp_right);
%         PsychPortAudio('Start', GP.pahandle);
%         WaitSecs(0.3)
%         PsychPortAudio('Stop', GP.pahandle);
        
    elseif dir(2) == 1 && keyCode1(ExpParams.rKey) == 1
        
        resp = 0;
        
        quitVal = 0;
        log_rec=sprintf('WRONG \n');
        disp(log_rec);
        dlmwrite(logfile, log_rec, '-append');
        save(ufn_filename,'response', 'direction','order');
%         PsychPortAudio('FillBuffer', GP.pahandle, resp_wrong);
%         PsychPortAudio('Start', GP.pahandle);
%         WaitSecs(0.3)
%         PsychPortAudio('Stop', GP.pahandle);
        
    elseif dir(2) == 2 && keyCode1(ExpParams.rKey) == 1
        
        resp = 1;
        
        quitVal = 0;
        log_rec=sprintf('CORRECT \n');
        disp(log_rec);
        dlmwrite(logfile, log_rec, '-append');
        save(ufn_filename,'response', 'direction','order');
%         PsychPortAudio('FillBuffer', GP.pahandle, resp_right);
%         PsychPortAudio('Start', GP.pahandle);
%         WaitSecs(0.3)
%         PsychPortAudio('Stop', GP.pahandle);
        
    elseif dir(2) == 2 && keyCode1(ExpParams.lKey) == 1
        
        resp = 0;
        
        quitVal = 0;
        log_rec=sprintf('WRONG \n');
        disp(log_rec);
        dlmwrite(logfile, log_rec, '-append');
        save(ufn_filename,'response', 'direction','order');
%         PsychPortAudio('FillBuffer', GP.pahandle, resp_wrong);
%         PsychPortAudio('Start', GP.pahandle);
%         WaitSecs(0.3)
%         PsychPortAudio('Stop', GP.pahandle);
        
    end
    
    
else
    
    resp = NaN;
    quitVal = 1;
    Screen('Close');
    log_rec=sprintf('Voluntarily exited... \n');
    disp(log_rec);
    dlmwrite(logfile, log_rec, '-append');
    save(ufn_filename,'response', 'direction','order');
    
end

end
