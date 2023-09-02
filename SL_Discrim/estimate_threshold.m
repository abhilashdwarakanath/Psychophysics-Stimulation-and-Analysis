function data = estimate_threshold(ExpParams,GP,w)

%==========================================================================
% parameters and stimulus order
%==========================================================================
Ntrial = 128;

for k=1:16
   ContrastOrder(k,:) = randperm(8);
end

ContrastOrder = ContrastOrder'; ContrastOrder =ContrastOrder(:);

side_name = {'Left','Right'};

GOOD_KEYS = [ExpParams.lKey,ExpParams.rKey];
%==========================================================================
% CREATE GABORS
%==========================================================================

for l=1:length(GP.conts)
   [GABOR] = local_make_Gabor(GP.imgSize,GP.img_bgnd,GP.gFreq,GP.gBand,0/180*pi,GP.conts(l));
   for x=1:2 %only l/r
      if x==1
         GGG2 = shiftmat(GABOR,GP.dist,1); % left
      elseif x==2
         GGG2 = shiftmat(GABOR,GP.dist,2); % right
      end
      % add fixation dot
      GGG2(GP.centre(1)+(-2:2),GP.centre(2)+(-2:2)) = 255;
      Gabors{l,x} = GGG2;
   end
end
%==========================================================================
% Start trials
%==========================================================================   

Screen('DrawText', w, 'Press Enter to start contrast threshold estimation', 500,400,[255 255 255]);
Screen('Flip', w);
HideCursor;
ListenChar(2);

[v,v,keyCode1] = KbCheck;

while keyCode1(ExpParams.proceedKey) ~= 1
    
    [v,v,keyCode1] = KbCheck;
    
    if keyCode1(ExpParams.endKey)
        
        sca;
        break;
        
    end
    
end

response = zeros(2,Ntrial); RT = zeros(1,Ntrial);


for trial = 1:Ntrial
    
    curr_side = round(rand)+1;
    cont_trial = ContrastOrder(trial);
    
    id_fix=Screen('MakeTexture', w, Gabors{1,1});
    id_gabor=Screen('MakeTexture', w, Gabors{cont_trial,curr_side});

    % wait until next trial start
    delay = (200+rand*100)/1000;    
    fprintf('trial %d of %d.  Cont: %d    Side: %s  ',trial,Ntrial,cont_trial,side_name{curr_side});
    pause(delay);
    
    % present fixation dot
    Screen('DrawTexture', w, id_fix);
    Screen('Flip', w);

    % wait period unti target
    delay = (200+rand*300)/1000; % s delay
    % convert to refresh
    pause(delay);
    % target

    Screen('DrawTexture', w, id_gabor);
    Screen('Flip', w);
    Screen('DrawTexture', w, id_gabor);
    Screen('Flip', w);
    % fix    
    Screen('DrawTexture', w, id_fix);
    Screen('Flip', w);
    % wait random period until trial end
    delay = (200+rand*300)/1000;
    pause(delay);

    % present ? and wait for response
   Screen('DrawText', w, '?', GP.screen_centre(1),GP.screen_centre(2),[255 255 255]);
    Screen('Flip', w);  
    [secs, keyCode] = KbWait([],2);
    resp = find(keyCode);
    if sum(resp==GOOD_KEYS)==0
       resp = NaN;
    end
    % determine correct, wrong
    resp_code = 0;
    if ~isnan(resp)
       if curr_side ==1  % left
          if resp==ExpParams.lKey
             resp_code = 1;
             fprintf('  correct\n');
          else
              fprintf('  wrong\n');
          end
       elseif curr_side==2 % right
          if resp==ExpParams.rKey
             resp_code = 1;
             fprintf('  correct\n');
          else
              fprintf('  wrong\n');              
          end
       end
    else
       resp_code = NaN;
    end

    Screen('Close');
    response(1,trial) = cont_trial;
    response(2,trial) = resp_code;
    RT(trial) = secs;

    save('contrast','response');
    
end
    ShowCursor;
    ListenChar(0);
%% Estimate proportion of correct for each contrast value

hits = zeros(1,8);

for i = 1:size(response,2)
        
    if response(1,i) == 1 && response(2,i) == 1

        hits(1,1) = hits(1,1)+1;
    end
    
    if response(1,i) == 2 && response(2,i) == 1

        hits(1,2) = hits(1,2)+1;
    end
    
    if response(1,i) == 3 && response(2,i) == 1

        hits(1,3) = hits(1,3)+1;
    end
    
    if response(1,i) == 4 && response(2,i) == 1

        hits(1,4) = hits(1,4)+1;
    end
    
    if response(1,i) == 5 && response(2,i) == 1

        hits(1,5) = hits(1,5)+1;
    end
    
    if response(1,i) == 6 && response(2,i) == 1

        hits(1,6) = hits(1,6)+1;
    end
    
    if response(1,i) == 7 && response(2,i) == 1

        hits(1,7) = hits(1,7)+1;
    end
    
    if response(1,i) == 8 && response(2,i) == 1

        hits(1,8) = hits(1,8)+1;
    end

end

data = [GP.conts' hits' 16.*ones(8,1)];
save('data','response');

sca;

end
