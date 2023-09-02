function results = hrflsefit(Params,data)

% function results = hrflsefit(varargin) takes in parameters for the model
% and the data from the Contrast Gain experiment, fits the model to the
% data and returns the parameters "Gain", "C50" and "N"
%
% It uses the inbuilt MATLAB function fminsearch for optimisation


%% Computing best fit parameters

% A zoom-in search in successive steps is used to minimise the negative of
% the maximum likelihood estimate. A log likelihood surface is created
% which is used later for the contour plot

err = zeros(Params.nIter, Params.nIter, Params.nIter);

paramsStart = [Params.G(1) Params.N(1) Params.C50(1)];

paramsEnd = [Params.G(2) Params.N(2) Params.C50(2)];

p = zeros(Params.nIter,3);

for h = 1:numel(paramsStart)
    
    p(1,:) = paramsStart;
    
    for i = 1:Params.nIter
        
        p(i+1,:) = paramsStart + (i)*(paramsEnd-paramsStart)./Params.nIter ;
        
    end
    
    for j = 1:Params.nIter
        
        for k = 1:Params.nIter
            
            for l = 1:Params.nIter
                
                err(j,k,l) = hrflse(Params,p(j,1), p(k,2), p(l,3),data);
                
            end
            
        end
    end
    
    [~, idx] = min(err(:));
    
    [idx1, idx2, idx3] = ind2sub(size(err), idx);
    
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
    
    if idx3 < 5
        s3 = 1;
    else
        s3 = idx3-4;
    end
    
    paramsStart = [p(s1,1) p(s2,2) p(s3,3)];
    
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
    
    if idx3 > (Params.nIter-4)
        e3 = Params.nIter;
    else
        e3 = idx3+4;
    end

    paramsEnd = [p(e1,1) p(e2,2) p(e3,3)];
    
end

param_ests = [p(idx1, 1) p(idx2, 2) p(idx3, 3)];


%% Generate model from fitted parameters

model = hrf(Params,param_ests(1),param_ests(2),param_ests(3));

new_C = 10^-5:0.05:Params.C(end)+(Params.C(end)/numel(Params.C));

Params.C = new_C;

full_model = hrf(Params,param_ests(1),param_ests(2),param_ests(3));

%% Collect results

results.model = model;
results.full_model = full_model;
results.G = param_ests(1);
results.N = param_ests(2);
results.C50 = param_ests(3);
results.full_axis = new_C;
results.data = data;
results.offset = Params.offset;
end