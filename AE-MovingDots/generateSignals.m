function [esound] = generateSignals(esound,f0)

% Generate sound

t = 0:1/esound.fs:0.5;

ramp_time = 0.005;

if f0==0
    fprintf('No sound condition\n');
    
    esound.s = zeros(2,length(t));
    
elseif f0~=0
     fprintf('Sound condition\n');
        
        s = sin(f0*2*pi*t);
        s = cosramp(s,ramp_time,esound.fs);
        s(2,:)=(s);
        esound.s = s;
    
end

end

