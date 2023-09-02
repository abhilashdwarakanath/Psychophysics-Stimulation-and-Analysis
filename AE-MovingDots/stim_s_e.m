function [quitval] = stim_s_e(dots,esound,display,gOr_target,quitval);

% if gOr_target < 0
%     dots.coherence = abs(gOr_target);
%     dots.direction = 270;
% else
%     dots.coherence = gOr_target;
%     dots.direction = 90;
% end 

dots.coherence=gOr_target;

% Show fixation cross

fixTime = 0.5; %s
fixFrames = round(fixTime*(1/display.ifi));

% for i=1:fixFrames
%     drawFixation(display);
% end

% Play sound
    
PsychPortAudio('FillBuffer', esound.pahandle, esound.s);
PsychPortAudio('Start', esound.pahandle);

% Present stimulus and show fixation cross

movingDots2(dots,display,1);

% for i=1:fixFrames
%     drawFixation(display);
% end

drawBlank(display);
WaitSecs(0.01);

end