function [s,standard] = generateSignals(ExpParams,GP,f0)

% This function generates a set of stimuli per trial
% It needs the audenv.mat, GP structure, the target, rest and frequency
% band

t_subb = 1.5; % length of sound stimulus in s
sf = 48+3*randn;
while sf < 36
    sf = 48+3*randn;
    
end

standard = local_make_Gabor(GP.imgSize,GP.img_bgnd,sf,GP.gBand,0,GP.gCont);
% sf = 48+6*randn;
% 
% G = local_make_Ga(GP.imgSize,GP.img_bgnd,sf,GP.gBand,0,GP.gCont);

% [x,y] = find(G~=50);
% occ = 0.3/10;
% T = round(1+((length(x)-1) - 1).*rand(round(length(x)*occ),1));
% 
% rx = x(T);
% ry = y(T);
% 
% for tt = 1:length(rx)-4;
%     
%     G(rx(tt):rx(tt)+3,ry(tt):ry(tt)+3) = 40+(70-40)*rand;%G(rx(tt):rx(tt)+3,ry(tt):ry(tt)+3) - (7+(15-7)*rand);
%     
% end

% Generate sound

ramp_time = 0.050;

t = linspace(0,1,ExpParams.fs*t_subb);

if f0==0
    
    s = zeros(2,length(t));
    
else
    
    s = sin(2*pi*f0*t);
    
    s = cosramp(s,ramp_time,ExpParams.fs);
    
    s = normalise(s);
    s(2,:) = s;
    
end

end

