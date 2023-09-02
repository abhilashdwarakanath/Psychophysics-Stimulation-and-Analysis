function [filtered_signal] = butterworth(timeseries,fc,fs,flag)

%% high-pass filtering

nq = fs/2;

if strcmp(flag,'high') == 1
    
    Wn = fc./nq;

    [b,a] = butter(3,Wn,'high');
    
elseif strcmp(flag,'low') == 1
    
    Wn = fc./nq;
    
    [b,a] = butter(3,Wn,'low');
    
elseif strcmp(flag,'notch') == 1
    
    Wn = [fc-10 fc+10]./nq;
    
    [b,a] = butter(2,Wn,'stop');
    
elseif strcmp(flag,'pass') == 1;
    
    Wn = fc./nq;
    
    [b,a] = butter(2,Wn);
    
end

filtered_signal = filter(b,a,timeseries);

end