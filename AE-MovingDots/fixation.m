function fixation(display);

center = display.resolution/2;
center = [center(3) center(4)];

X = center(1);
Y = center(2);
FixCross = [X-3,Y-3,X+3,Y+3;X-3,Y-3,X+3,Y+3];
Screen('FillRect', display.windowPtr, [255,0,0], FixCross');
Screen('Flip', display.windowPtr);
end