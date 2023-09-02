function out = ck_conv(in,filter)

% function out = ck_conv(in,filter)
out = conv(in,filter);
n = length(filter);
n1 = floor(n/2);
n2 = n-n1;
out = out(n1:end-n2);