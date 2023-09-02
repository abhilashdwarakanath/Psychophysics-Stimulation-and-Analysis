function [spk,results] = psychfit(response,x,Params,type)

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

if nargin < 3
    disp('You have not entered the correct number of input arguments. Program is exiting')
    return
end

%% Analysing responses

% P(x) is plotted as the percentage of trials percieved as the higher tone
% coming from behind the lower tone.
% The SD of the data is also calculated to be used for error bars.

for i = 1:Params.spkNum
    
    spk(1,i).hits = 0;
    spk(1,i).valTrials = 0;
    %#ok<*AGROW,*SAGROW>
    
end

response(:,4) = -1.*response(:,4);
meanRT = mean(response(:,4));
sdRT = std(response(:,4));
zsRT = round((response(:,4) - meanRT)./sdRT);

for i = 1:size(response,1)
    
    for j = 1:Params.spkNum
        
        if response(i,2) == 0 && response(i,1) == j &&  response(i,3) == 38;
            spk(1,j).hits = spk(1,j).hits+1;
            
        elseif response(i,2) == 1 && response(i,1) == j &&  response(i,3) == 40;
            spk(1,j).hits = spk(1,j).hits+1;
            
        end
        
    end
    
end

for i = 1:size(response,1)
    
    for j = 1:Params.spkNum
        
        if response(i,1) == j && zsRT(i,1) < 5 && zsRT(i,1) > -5;
            spk(1,j).valTrials = spk(1,j).valTrials+1;
        end
    end
end

data = zeros(1,Params.spkNum);

for k = 1:Params.spkNum
    
    data(1,k) = spk(1,k).hits/spk(1,k).valTrials;
    sdData(1,k) = data(1,k).*(1-data(1,k))./sqrt(spk(1,k).valTrials);
    
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
            
            logLikeWeib(j,k) = llsfit(Params,p(j,1), p(k,2),data,x);
            
        end
    end
    
    [~, idx] = min(logLikeWeib(:));
    
    [idx1, idx2] = ind2sub(size(logLikeWeib), idx);
    
    if idx1 < 20
        s1 = 1;
    else
        s1 = idx1-19;
    end
    
    
    if idx2 < 20
        s2 = 1;
    else
        s2 = idx2-19;
    end
    
    paramsStart = [p(s1,1) p(s2,2)];
    
    if idx1 > (Params.nIter-19)
        e1 = Params.nIter;
    else
        e1 = idx1+19;
    end
    
    
    if idx2 > (Params.nIter-19)
        e2 = Params.nIter;
    else
        e2 = idx2+19;
    end
    
    paramsEnd = [p(e1,1) p(e2,2)];
    
end

X = 0.00005:0.01:x(end)+0.75;

y = psychWeibull(Params.a,p(idx1,1),p(idx2,2),x);
Y = psychWeibull(Params.a,p(idx1,1),p(idx2,2),X);

logLikelihood = -sum(data.*log(y) + (1-data).*log(1-y));

lls = logLikWeibull(Params,data,x);

%[~, t25ind] = min(abs(Y-Params.cuts(1)));
%[~, t75ind] = min(abs(Y-Params.cuts(3)));
 
fitEst = [p(idx1, 1) p(idx2, 2)];

t25 = interp1(Y,X,Params.cuts(1),'spline');
t50 = interp1(Y,X,Params.cuts(2),'spline');
t75 = interp1(Y,X,Params.cuts(3),'spline');

% thresholds = [X(t25ind) fitEst(2) X(t75ind)];
thresholds = [t25 t50 t75];
slope = fitEst(1,1);

%% Goodness of fit

gFit = gfit(data,y,'7');

% p11 = predint(y,x,0.95,'observation','off');
% p12 = predint(y,x,0.95,'observation','on');
% p21 = predint(y,x,0.95,'functional','off');
% p22 = predint(y,x,0.95,'functional','on');

%% Collecting outputs

results.model = Y;
results.likelihood = logLikelihood;
results.slope = slope;
results.thresholds = thresholds;
results.goodnessoffit = gFit;
results.stderror = sdData;
results.jnd = ((thresholds(3) - thresholds(1))/2)+0.0001;
results.lls = lls;
results.data = data;
%results.valTrials = spk.valTrials;

%% Plotting

%ylim = fitEst(1,1)+5*fitEst(1,1);
ylim = 3;

s = get(0, 'ScreenSize');
figure('Position',[1 1 s(3) s(4)]);

subplot(2,4,[1 2])
plot(X,real(Y),'b-')
hold on
for i = 1:length(data)
    mSize = (data(i)*Params.ntrials)+2;
    plot(x(i),data(i),'ro','MarkerSize',mSize,'MarkerFaceColor','r')
    errorbar(x(i),data(i),sdData(i),'bo','MarkerFaceColor','b');
end
plot(([min(X),thresholds(1),thresholds(1)]),Params.cuts(1)*[1,1,0],'k-');
plot(([min(X),thresholds(2),thresholds(2)]),Params.cuts(2)*[1,1,0],'k-');
plot(([min(X),thresholds(3),thresholds(3)]),Params.cuts(3)*[1,1,0],'k-');
title('a = 0.5')
axis([0 max(X) 0 1])
xlabel('delta d')
ylabel('P(x)')
subplot(2,4,[5 6])
contour((Params.t),(Params.b),lls,linspace(0.01,25,75))
xlabel('t')
ylabel('b')
hold on
plot(Params.t(1),Params.b(1),'o','MarkerFaceColor','r');
plot(thresholds(2),thresholds(2),'o','MarkerFaceColor','g','MarkerSize',10);
axis([min(Params.t) max(Params.t) min(Params.b) ylim])

% subplot(2,4,3)
% plot(y,x,data), hold on, plot(x,p11,'m--'), xlim([0 max(x)])
% title('Nonsimultaneous observation bounds','Color','m')
% subplot(2,4,4)
% plot(y,x,data), hold on, plot(x,p12,'m--'), xlim([0 max(x)])
% title('Simultaneous observation bounds','Color','m')
% subplot(2,4,7)
% plot(y,x,data), hold on, plot(x,p21,'m--'), xlim([0 max(x)])
% title('Nonsimultaneous functional bounds','Color','m')
% subplot(2,4,8)
% plot(y,x,data), hold on, plot(x,p22,'m--'), xlim([0 max(x)])
% title('Simultaneous functional bounds','Color','m')

if type == 0
    [~,h3]=suplabel('2AFC weibull fit for static condition'  ,'t');
elseif type == 1
    [~,h3]=suplabel('2AFC weibull fit for moving condition'  ,'t');
end
set(h3,'FontSize',30)

end
%-------------------------------------------------------------------PROGRAM   END------------------------------------------------------------------------------%