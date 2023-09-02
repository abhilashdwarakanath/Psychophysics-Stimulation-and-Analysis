function y = psychWeibull(a,b,t,x)

%y = Weibull(p,x)
%
%Parameters:  b = slope
%             t = threshold yeilding 50% discrimination
%             a = performance at threshold
%             x   stimulus values - implicit variable

g = 0; % lower asymptote
l = 0; % upper asymptote bound

k = (-log( (1-a)/(1-g)))^(1/b);

y = 1- (1-g-l).*exp(- ((k.*x)./t).^b);