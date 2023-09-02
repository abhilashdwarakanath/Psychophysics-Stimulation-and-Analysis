function [resp,quitVal] = an_resp(Names,ExpParams,j,keyCode1,logfile,type,resp_right,resp_wrong,response,order,quitVal)

if type == 'c'
    ufn_filename = [Names.subjName 'UfnBlockC' date];
elseif type == 't'
    ufn_filename = [Names.subjName 'UfnBlockT' date];
elseif type == 'e'
    ufn_filename = [Names.subjName 'UfnBlockExp' date];
end

match = 1:7;
conflict = 8:14;

if keyCode1(ExpParams.endKey)~=1
    
    if ismember(j,match)==1
        
        if keyCode1(ExpParams.sKey) == 1
            
            resp = 1;
            quitVal = 0;
            log_rec=sprintf('MATCH detected as MATCH \n');
            disp(log_rec);
            dlmwrite(logfile, log_rec, '-append');
            save(ufn_filename,'response', 'order');
            
            if type == 'e'
                sound(resp_right,ExpParams.fs*2);
            end
            
        else
            
            resp = 0;
            quitVal = 0;
            log_rec=sprintf('MATCH detected as CONFLICT \n');
            disp(log_rec);
            dlmwrite(logfile, log_rec, '-append');
            save(ufn_filename,'response', 'order');
            
            if type == 'e'
                sound(resp_wrong,ExpParams.fs*2);
            end
            
        end
        
        
        
    elseif ismember(j,conflict)==1
        
        if keyCode1(ExpParams.sKey) == 1
            
            resp = 1;
            quitVal = 0;
            log_rec=sprintf('CONFLICT detected as MATCH \n');
            disp(log_rec);
            dlmwrite(logfile, log_rec, '-append');
            save(ufn_filename,'response', 'order');
            
            if type == 'e'
                sound(resp_right,ExpParams.fs*2);
            end
            
        else
            
            resp = 0;
            quitVal = 0;
            log_rec=sprintf('CONFLICT detected as CONFLICT \n');
            disp(log_rec);
            dlmwrite(logfile, log_rec, '-append');
            save(ufn_filename,'response', 'order');
            
            if type == 'e'
                sound(resp_right,ExpParams.fs*2);
            end
            
        end
        
    end
    
else
    
    resp = NaN;
    quitVal = 1;
    Screen('Close');
    log_rec=sprintf('Voluntarily exited... \n');
    disp(log_rec);
    dlmwrite(logfile, log_rec, '-append');
    save(ufn_filename,'response', 'order');
    
end
end