function x = interpolate(y1, x1, y2, x2, y)

% Calculate corresponding x-coordinate

x = x1 + (x2-x1)/(y2-y1) * (y-y1);