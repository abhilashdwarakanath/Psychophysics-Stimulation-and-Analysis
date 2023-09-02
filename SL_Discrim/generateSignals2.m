function [s,G,sample_G] = generateSignals2(ExpParams,GP,gOr_target,gOr_rest,f0,dir)

% This function generates a set of stimuli per trial
% It needs the audenv.mat, GP structure, the target, rest and frequency
% band

t_subb = 0.5; % length of sound stimulus in s

sf = 48+3*randn;
while sf < 36
    sf = 48+3*randn;
    
end
    
G = local_make_Gabor(GP.imgSize,GP.img_bgnd,sf,GP.gBand,deg2rad(gOr_target),GP.gCont);

% Generate samples

sf = 48+3*randn;
while sf < 36
    sf = 48+3*randn;
    
end

s_G1 = local_make_Gabor(GP.imgSize,GP.img_bgnd,sf,GP.gBand,deg2rad(gOr_rest),GP.gCont); % non-target

sf = 48+3*randn;
while sf < 36
    sf = 48+3*randn;
    
end

s_G2 = local_make_Gabor(GP.imgSize,GP.img_bgnd,sf,GP.gBand,deg2rad(gOr_target),GP.gCont); % target

s_G1 = shiftmat(s_G1,GP.dist,dir(1));

s_G2 = shiftmat(s_G2,GP.dist,dir(2)); % target

sample_G = (s_G1+s_G2)/2;

% Generate sound

ramp_time = 0.050;

t = linspace(0,1,ExpParams.fs*t_subb);

if f0 == 0
    
    s = [zeros(1,ExpParams.fs*t_subb); zeros(1,ExpParams.fs*t_subb)];
    
else
    
    s = sin(2*pi*f0*t);
    
    s = cosramp(s,ramp_time,ExpParams.fs);
    
    s = normalise(s);
    
    s(2,:) = s;
end

end

