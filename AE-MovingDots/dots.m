clear all
clc
close all

%% Start

dots.nDots = 100;                % number of dots
dots.color = [255,255,255];      % color of the dots
dots.size = 1;                   % size of dots (pixels)
dots.center = [0,0];           % center of the field of dots (x,y)
dots.apertureSize = [12,12];     % size of rectangular aperture [w,h] in degrees.
dots.speed = 3;       %degrees/second
dots.duration = 5;    %seconds
dots.direction = 30; 
dots.lifetime = 12; %degrees (clockwise from straight up)
display.screenRect = [0 0 1024 768];
display.frameRate=60;
display.screenNumber=0;

dots.life =    ceil(rand(1,dots.nDots)*dots.lifetime);

display.dist = 45;  %cm
display.width = 37.8; %cm
display.resolution = [1024 768]; %resolution
nFrames = round(dots.duration*60);

dx = dots.speed*sin(dots.direction*pi/180)/display.frameRate;
dy = -dots.speed*cos(dots.direction*pi/180)/display.frameRate;

l = dots.center(1)-dots.apertureSize(1)/2;
r = dots.center(1)+dots.apertureSize(1)/2;
b = dots.center(2)-dots.apertureSize(2)/2;
t = dots.center(2)+dots.apertureSize(2)/2;

dots.x = (rand(1,dots.nDots)-.5)*dots.apertureSize(1) + dots.center(1);
dots.y = (rand(1,dots.nDots)-.5)*dots.apertureSize(2) + dots.center(2);

try
    [display.windowPtr,display.screenRect]=Screen('OpenWindow',display.screenNumber,0,display.screenRect);
    for i=1:nFrames
        %convert from degrees to screen pixels
        pixpos.x = angle2pix(display,dots.x)+ display.resolution(1)/2;
        pixpos.y = angle2pix(display,dots.y)+ display.resolution(2)/2;

        Screen('DrawDots',display.windowPtr,[pixpos.x;pixpos.y], dots.size, dots.color,[0,0],1);
        %update the dot position
        dots.x = dots.x + dx;
        dots.y = dots.y + dy;

        %move the dots that are outside the aperture back one aperture
        %width.
        dots.x(dots.x<l) = dots.x(dots.x<l) + dots.apertureSize(1);
        dots.x(dots.x>r) = dots.x(dots.x>r) - dots.apertureSize(1);
        dots.y(dots.y<b) = dots.y(dots.y<b) + dots.apertureSize(2);
        dots.y(dots.y>t) = dots.y(dots.y>t) - dots.apertureSize(2);

        %increment the 'life' of each dot
        dots.life = dots.life+1;

        %find the 'dead' dots
        deadDots = mod(dots.life,dots.lifetime)==0;

        %replace the positions of the dead dots to a random location
        dots.x(deadDots) = (rand(1,sum(deadDots))-.5)*dots.apertureSize(1) + dots.center(1);
        dots.y(deadDots) = (rand(1,sum(deadDots))-.5)*dots.apertureSize(2) + dots.center(2);

        Screen('Flip',display.windowPtr);
    end
catch ME
    Screen('CloseAll');
    rethrow(ME)
end
Screen('CloseAll');