function param_ests = pf_for_bootstrap(data,Params)

% This function fits a psychometric function to a given dataset using the
% maximum likelihood maximisation method
% A fit will be displayed and the parameter values that are the most
% appropriate fit will be returned.
% A contour plot displays the goodness of fit.
% In the future, this program will be modified to take in strings such as
% "cumulative Gaussian", "gumbel", "logistic" etc for different types of
% psychometric fits. It will also be expanded to include both
% discrimination and detection tasks.

%-------------------------------------------------------------------PROGRAM START------------------------------------------------------------------------------%

if nargin < 2
    disp('You have not entered the correct number of input arguments. Program is exiting')
    return
end

%% Computing best fit parameters

% A zoom-in search in successive steps is used to minimise the negative of
% the maximum likelihood estimate. A log likelihood surface is created
% which is used later for the contour plot

logLikeWeib = zeros(Params.nIter, Params.nIter);

paramsStart = [Params.b(1) Params.t(1)];

paramsEnd = [Params.b(end) Params.t(end)];

p = zeros(Params.nIter,2);

for h = 1:numel(paramsStart)
    
    p(1,:) = paramsStart;
    
    for i = 1:Params.nIter
        
        p(i+1,:) = paramsStart + (i)*(paramsEnd-paramsStart)./Params.nIter ;
        
    end
    
    for j = 1:Params.nIter
        
        for k = 1:Params.nIter
            
            logLikeWeib(j,k) = llsfit(Params,p(j,1), p(k,2),data);
            
        end
    end
    
    [~, idx] = min(logLikeWeib(:));
    
    [idx1, idx2] = ind2sub(size(logLikeWeib), idx);
    
    if idx1 < 5
        s1 = 1;
    else
        s1 = idx1-4;
    end
    
    
    if idx2 < 5
        s2 = 1;
    else
        s2 = idx2-4;
    end
    
    paramsStart = [p(s1,1) p(s2,2)];
    
    if idx1 > (Params.nIter-4)
        e1 = Params.nIter;
    else
        e1 = idx1+4;
    end
    
    
    if idx2 > (Params.nIter-4)
        e2 = Params.nIter;
    else
        e2 = idx2+4;
    end
    
    paramsEnd = [p(e1,1) p(e2,2)];
    
end

param_ests = [p(idx1, 1) p(idx2, 2)];