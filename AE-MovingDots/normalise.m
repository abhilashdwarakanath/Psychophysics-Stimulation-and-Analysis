function out = normalise(signal,n);

if n==1

out = (signal - mean(signal))/max(abs(signal - mean(signal)));

else
    
    out = (signal-mean(signal))./std(signal);

end