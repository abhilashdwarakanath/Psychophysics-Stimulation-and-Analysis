function movingDots1(dots,display)

w = display.windowPtr;
rect = display.screenRect;
coherence = dots.coherence;
fps = 60;

showSprites = 0;
waitframes = 1;


%% based on DotDemo

%additional parameters



% ------------------------
% set dot field parameters
% ------------------------
X_shift_pixels=-100;
Y_shift_pixels=0;

nframes     = round(60*0.5);%3600; % number of animation frames in loop
mon_width   = 37.8;   % horizontal dimension of viewable screen (cm)
v_dist      = 45;   % viewing distance (cm)


dot_speed   = 2;    % dot speed (deg/sec)
f_kill      = 0.1; % fraction of dots to kill each frame (limited lifetime)

ndots       = 150;%300; % number of dots
max_d       = 3.25;   % maximum radius of  annulus (degrees)
min_d       = 0;    % minumum
dot_w       = 0.1;  % width of dot (deg)
fix_r       = 0.2; % radius of fixation point (deg)
differentcolors =0; % Use a different color for each point if == 1. Use common color white if == 0.
differentsizes = 0; % Use different sizes for each point if >= 1. Use one common size if == 0.


if differentsizes>0  % drawing large dots is a bit slower
    ndots=round(ndots/5);
end

% ---------------
% open the screen
% ---------------


% Enable alpha blending with proper blend-function. We need it
% for drawing of smoothed points:
Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
[center(1), center(2)] = RectCenter(rect);
%     fps=Screen('FrameRate',w);      % frames per second
%     ifi=Screen('GetFlipInterval', w);
ifi = display.ifi;
%     if fps==0
%         fps=1/ifi;
%     end;
%
white = WhiteIndex(w);
%HideCursor;	% Hide the mouse cursor
%     Priority(MaxPriority(w));
%
%      Do initial flip...
vbl=Screen('Flip', w);
%
% ---------------------------------------
% initialize dot positions and velocities
% ---------------------------------------

ppd = pi * (rect(3)-rect(1)) / atan(mon_width/v_dist/2) / 360;    % pixels per degree
pfs = dot_speed * ppd / fps;                            % dot speed (pixels/frame)
s = dot_w * ppd;                                        % dot size (pixels)
fix_cord = [center-fix_r*ppd center+fix_r*ppd];

%xymatrix_shift=-X_shift_pixels*[ones(1,ndots);zeros(1,ndots)];
xymatrix_shift=[-X_shift_pixels*ones(1,ndots);Y_shift_pixels*ones(1,ndots)];

% Create a vector with different colors for each single dot, if
% requested:
if (differentcolors==1)
    colvect = uint8(round(rand(3,ndots)*255));
else
    colvect=white;
end;

% --------------
% animation loop
% --------------


ndots_rand=round(ndots*(1-abs(coherence)));
ndots_coherent=ndots-ndots_rand;
%% initialize dot position
rmax = max_d * ppd;	% maximum radius of annulus (pixels from center)
rmin = min_d * ppd; % minimum
r = rmax * sqrt(rand(ndots,1));	% r
r(r<rmin) = rmin;
t = 2*pi*rand(ndots,1);                     % theta polar coordinate
cs = [cos(t), sin(t)];
xy = [r r] .* cs;   % dot positions in Cartesian coordinates (pixels from center)

%% initialize dot direction
if coherence >0
    dir_theta=2*pi*[rand(ndots_rand,1);zeros(ndots_coherent,1)];
else
    dir_theta=2*pi*[rand(ndots_rand,1);1/2*ones(ndots_coherent,1)];
end
dxdy = pfs*[cos(dir_theta) sin(dir_theta)];

xymatrix = transpose(xy);
for i = 1:nframes
    if (i>=1)
       Screen('FillOval', w, uint8(white), fix_cord);	% draw fixation dot (flip erases it)
        
        % Draw nice dots:
        Screen('DrawDots', w, xymatrix+xymatrix_shift, s, colvect, center,1);  % change 1 to 0 to draw square dots
        
        Screen('DrawingFinished', w); % Tell PTB that no further drawing commands will follow before Screen('Flip')
    end;
    
    % Break out of animation loop if any key on keyboard or any button
    % on mouse is pressed:
    %         [mx, my, buttons]=GetMouse(screenNumber);
    %         if any(buttons)
    %             break;
    %         end
    %
    %         if KbCheck
    %             break;
    %         end;
    
    xy = xy + dxdy;						% move dots
    [th,r]=cart2pol(xy(:,1),xy(:,2));
    
    
    % check to see which dots have gone beyond the borders of the annuli
    
    r_out = find(r > rmax | r < rmin | rand(ndots,1) < f_kill);	% dots to reposition
    nout = length(r_out);
    
    if nout
        
        % choose new coordinates
        
        r(r_out) = rmax * sqrt(rand(nout,1));
        r(r<rmin) = rmin;
        t(r_out) = 2*pi*(rand(nout,1));
        
        % now convert the polar coordinates to Cartesian
        
        cs(r_out,:) = [cos(t(r_out)), sin(t(r_out))];
        xy(r_out,:) = [r(r_out) r(r_out)] .* cs(r_out,:);
        
        
    end;
    xymatrix = transpose(xy);
    
    vbl=Screen('Flip', w, vbl + (waitframes-0.5)*ifi);
end;


Screen('FillOval', w, uint8(white), fix_cord);	% draw fixation dot (flip erases it)

vbl=Screen('Flip', w, vbl + (waitframes-0.5)*ifi);

%WaitSecs(1);

%     Priority(0);
%     ShowCursor
%Screen('Close');

end
