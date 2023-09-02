function s = filtering_targets(ExpParams,signal,f0)


%% high-pass filtering

%f = round(linspace(100,8000,7));

freqs = [2^7 2^8 2^9 2^10 2^11 2^12 2^13];

% jitter frequencies

if f0==0
    
    s = zeros(1,length(ExpParams.fs*0.5));
    
else

f = freqs(f0:f0+1);
fc = f+10.*((-2+(-2+3).*randn(1,2)));

flag = 'pass';

s = zeros(1,length(signal));
    
s= butterworth(signal,fc,ExpParams.fs,flag);

end
