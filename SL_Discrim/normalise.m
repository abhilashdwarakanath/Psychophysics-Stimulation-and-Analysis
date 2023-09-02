function out = normalise(signal);

out = (signal - mean(signal))/max(abs(signal - mean(signal)));

end