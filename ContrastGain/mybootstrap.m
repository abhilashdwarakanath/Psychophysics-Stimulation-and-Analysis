function CI = mybootstrap(Params,results,CIrange,BCFlag)

% [CI,sampleStat] = bootstrap(myStatistic,x,[Params.nboot],[CIrange],[BCFlag])
%
% Calculates a confidence interval on the statistic (function handle
% 'myStatistic' using a nonparametric bootstrap and the bias-corrected
% accellerated' algorithm.
%
% Inputs:
%    myStatistic:       a handle to a function that takes in a vector and
%                       returns a scalar (like 'mean' or 'std')
%
%   x                   sample vector for generating the statistic and its
%                       confidence intervals
%
%   Params -            Parameters for fitting and estimation
%  
%   CIrange             confidence interval range (default 68.27)
%
%   BCFlag              boolean flag for whether or not to do the
%                       bias-correction (default 1)
%
% In Params, a field Params.nboot must exist to specify number of
% iterations.
%
% Outputs:     
%   CI:                 confidence interval
%   sampleStat          statictic evaluated on x  'myStatistic(x)'
%
% 4/10/09 Written by G.M. Boynton at the University of Washington
%         based on  Efron and Tibshirani's "Introductcion to the Bootsrap" 
%        (Chapman & Hall/CRC, 1993, pages 178-201)
%
% 19.06.2012 - Edited by A. Dwarakanath to generalise function handles. MPI
% für Biologische Kybernetik. Tübingen.

%%
% Deal with defaults

if ~exist('BCFlag','var')
    BCFlag = 1;
end

if ~exist('CIrange','var')
    CIrange = 68.27;  %corresponds to +/- 1 s.d. for a normal distribution
end

x = results.data;
prob = results.model;
sampleStat = [results.B results.T];

%% Run fit on data-sample N times.

bootstrapStat = zeros(length(sampleStat),Params.nboot);

h = waitbar(0,sprintf('Step 1: Bootstrapping with %d iterations',Params.nboot));

parfor i=1:Params.nboot
    
    resampledX = sort(min(prob) + (1 - min(prob)).*rand(size(x)));
    
    bootstrapStat(:,i) = pf_for_bootstrap(resampledX,Params);
    
    waitbar(i/Params.nboot,h)
    
end

delete(h);

%% Calculate the bias-corrected and accelerated parameters z0 and a

t = Params.C;

z0 = zeros(1,length(sampleStat));
a = zeros(1,length(sampleStat));

if BCFlag
    
    for i = 1:length(sampleStat)
        z0(i) = inverseNormalCDF(sum(bootstrapStat(i,:)<sampleStat(i))/Params.nboot);
    end

    thetai = zeros(length(x),length(sampleStat));
    
    %calculate the statistic holding one member of x out each time
    
    h = waitbar(0,'Step 2: bias corrected and accelerated algorithm');
    
    for i=1:length(x)
        
        id = [1:(i-1),(i+1):length(x)];
        Params.C = t(id);
        thetai(i,:) = hlf_for_bootstrap(x(id),Params);

        waitbar(i/length(x),h)
        
    end
    
    delete(h);
    
    %do something related to skewness.
    
    for i = 1:length(sampleStat)
        a(i) = sum( (mean(thetai(:,i))-thetai(:,i)).^3)/(6*(sum( (mean(thetai(:,i))-thetai(:,i)).^2).^(3/2)));
    end
else
    z0 = zeros(1,length(sampleStat));
    a = zeros(1,length(sampleStat));
end

%% Calculate the 'bias-corrected and accelerated' percentiles using z0 and a

zLo = inverseNormalCDF((1-CIrange/100)/2);
zHi = inverseNormalCDF((1+CIrange/100)/2);

zClo = z0 + (z0+zLo)./(1-a.*(z0+zLo));
bcaLo = normcdf(zClo,0,1);

zChi = z0 + (z0+zHi)./(1-a.*(z0+zHi));
bcaHi = normcdf(zChi,0,1);

CI = zeros(2,length(sampleStat));

for i = 1:length(sampleStat)
    CI(1,i) = prctile(bootstrapStat(i,:),100*bcaLo(i));
    CI(2,i) = prctile(bootstrapStat(i,:),100*bcaHi(i));
end

Params.C = t;

end