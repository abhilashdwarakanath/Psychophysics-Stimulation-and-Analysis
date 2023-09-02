function [lls] = logLikWeibull(Params,data,x)

% Generating the log likelihood surface for the contour plot and computing
% the log likelihood negative for minimisation

lls = zeros(length(Params.b),length(Params.t));

for i = 1:length(Params.b)
    for j = 1:length(Params.t)
        y = psychWeibull(Params.a,Params.b(i),Params.t(j),x);
        y = y*.999+.001; %pull the log likelihood away from 0 to eliminate Inf and NaNs
        lls(i,j) = -sum(data.*log(y) + (1-data).*log(1-y));
    end
end

end