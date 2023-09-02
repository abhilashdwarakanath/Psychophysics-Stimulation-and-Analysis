clear all
close all
clc

% Analysis program for the Predictive coding experiments. Abhilash
% Dwarakanath. MPI f�r Biologische Kybernetik. 27.02.2013.

%% Analyse psych

fn = input('Enter name  :  ','s');
%dirName = ['Y:\Documents\MATLAB\Abhi\AE-MovingDots\Data\' fn '\'];
dirName = ['/home/aglo-lab/Documents/MATLAB/Abhi/AE-MovingDots/Data/' fn '/'];

cd(dirName);

cohs = [-100 100]/100; % 100% coherence Left and Right 
freqss = [500 2000]; % PLEASE COUNTER-BALANCE THIS ACROSS SUBJECTS, i.e. AB-BA!!!
association = [freqss' cohs'];

KbName('UnifyKeyNames'); 
ExpParams.lKey = 115;%Right
% ExpParams.lKey = 39;

cd('Control')
load('resplogtest');
type = 't';
[hitsC,trlsC] = processdata(ExpParams,resplog,association,conds);
clear resplog
cd ..

cd('Test')
load('resplogtest');
type = 'e';
[hitsT,trlsT] = processdata(ExpParams,resplog,association,conds);
clear responses; clear trial_order; clear freq_order; clear s_or_cs; clear gOr_targets;

x = conds';

niter = 1999;
cuts_f = [0.25 0.5 0.75];

dataC.sone = [x hitsC.sone' (trlsC.sone)'];
dataC.stwo = [x hitsC.stwo' (trlsC.stwo)'];
dataC.ns = [x hitsC.sns' (trlsC.sns)'];

dataT.sone = [x hitsT.sone' (trlsT.sone)'];
dataT.stwo = [x hitsT.stwo' (trlsT.stwo)'];
dataT.ns = [x hitsT.sns' (trlsT.sns)'];

%% Run
 
resultsC_sone=pfit(dataC.sone,'no plot','shape', 'c', 'n_intervals', 1, 'runs', niter, 'verbose',0, 'sens', 0, 'cuts',cuts_f,'CONF',[.025 .975]);%,'FIX_GAMMA',0);
resultsC_stwo=pfit(dataC.stwo,'no plot','shape', 'c', 'n_intervals', 1, 'runs', niter, 'verbose',0, 'sens', 0, 'cuts',cuts_f,'CONF',[.025 .975]);%,'FIX_GAMMA',0);
resultsC_ns=pfit(dataC.ns,'no plot','shape', 'c', 'n_intervals', 1, 'runs', niter, 'verbose',0, 'sens', 0, 'cuts',cuts_f,'CONF',[.025 .975]);%,'FIX_GAMMA',0);

resultsT_sone=pfit(dataT.sone,'no plot','shape', 'c', 'n_intervals', 1, 'runs', niter, 'verbose',0, 'sens', 0, 'cuts',cuts_f,'CONF',[.025 .975]);%,'FIX_GAMMA',0);
resultsT_stwo=pfit(dataT.stwo,'no plot','shape', 'c', 'n_intervals', 1, 'runs', niter, 'verbose',0, 'sens', 0, 'cuts',cuts_f,'CONF',[.025 .975]);%,'FIX_GAMMA',0);
resultsT_ns=pfit(dataT.ns,'no plot','shape', 'c', 'n_intervals', 1, 'runs', niter, 'verbose',0, 'sens', 0, 'cuts',cuts_f,'CONF',[.025 .975]);%,'FIX_GAMMA',0);

ciCns = resultsC_ns.thresholds.lims(:,2)';
sciCns = resultsC_ns.slopes.lims(:,2)';
ciTns = resultsT_ns.thresholds.lims(:,2)';
sciTns = resultsT_ns.slopes.lims(:,2)';

x1c = -0.1;
x1t = +0.1;

ciCsone = resultsC_sone.thresholds.lims(:,2)';
sciCsone = resultsC_sone.slopes.lims(:,2)';
ciTsone = resultsT_sone.thresholds.lims(:,2)';
sciTsone = resultsT_sone.slopes.lims(:,2)';

ciCstwo = resultsC_stwo.thresholds.lims(:,2)';
sciCstwo = resultsC_stwo.slopes.lims(:,2)';
ciTstwo = resultsT_stwo.thresholds.lims(:,2)';
sciTstwo = resultsT_stwo.slopes.lims(:,2)';

thresholds = [resultsC_sone.thresholds.est(2) resultsC_stwo.thresholds.est(2) resultsC_ns.thresholds.est(2);resultsT_sone.thresholds.est(2) resultsT_stwo.thresholds.est(2) resultsT_ns.thresholds.est(2)];
Lci = [ciCsone(:,1) ciCstwo(:,1) ciCns(:,1);ciTsone(:,1) ciTstwo(:,1) ciTns(:,1)];
Uci = [ciCsone(:,2) ciCstwo(:,2) ciCns(:,2); ciTsone(:,2) ciTstwo(:,2) ciTns(:,2)];

slopes = [resultsC_sone.slopes.est(2) resultsC_stwo.slopes.est(2) resultsC_ns.slopes.est(2);resultsT_sone.slopes.est(2) resultsT_stwo.slopes.est(2) resultsT_ns.slopes.est(2)];
sLci = [sciCsone(:,1) sciCstwo(:,1) sciCns(:,1);sciTsone(:,1) sciTstwo(:,1) sciTns(:,1)];
sUci = [sciCsone(:,2) sciCstwo(:,2) sciCns(:,2); sciTsone(:,2) sciTstwo(:,2) sciTns(:,2)];

figure(1)

subplot(2,2,[1 3])
pfit(dataC.sone,'plot without stats','shape', 'c', 'n_intervals', 1, 'runs', niter, 'verbose',0, 'sens', 0, 'cuts',cuts_f,'CONF',[.025 .975]);%,'FIX_GAMMA',0);
hold on
pfit(dataC.stwo,'plot without stats','shape', 'c', 'n_intervals', 1, 'runs', niter, 'verbose',0, 'sens', 0, 'cuts',cuts_f,'CONF',[.025 .975]);%,'FIX_GAMMA',0);
pfit(dataC.ns,'plot without stats','shape', 'c', 'n_intervals', 1, 'runs', niter, 'verbose',0, 'sens', 0, 'cuts',cuts_f,'CONF',[.025 .975]);%,'FIX_GAMMA',0);
xlabel('coherence')
ylabel('P(rightward)')
title('Pre-Conditioning')
axis([min(x) max(x) 0 1])
set(gca,'XTick',x)

subplot(2,2,[2 4])
pfit(dataT.sone,'plot without stats','shape', 'c', 'n_intervals', 1, 'runs', niter, 'verbose',0, 'sens', 0, 'cuts',cuts_f,'CONF',[.025 .975]);%,'FIX_GAMMA',0);
hold on
pfit(dataT.stwo,'plot without stats','shape', 'c', 'n_intervals', 1, 'runs', niter, 'verbose',0, 'sens', 0, 'cuts',cuts_f,'CONF',[.025 .975]);%,'FIX_GAMMA',0);
pfit(dataT.ns,'plot without stats','shape', 'c', 'n_intervals', 1, 'runs', niter, 'verbose',0, 'sens', 0, 'cuts',cuts_f,'CONF',[.025 .975]);%,'FIX_GAMMA',0);
xlabel('coherence')
ylabel('P(rightward)')
title('Post-Conditioning')
axis([min(x) max(x) 0 1])
set(gca,'XTick',x)

figure(2)

subplot(2,2,[1 3])
pfit(dataT.sone,'plot without stats','shape', 'c', 'n_intervals', 1, 'runs', niter, 'verbose',0, 'sens', 0, 'cuts',cuts_f,'CONF',[.025 .975]);%,'FIX_GAMMA',0);
hold on
pfit(dataT.ns,'plot without stats','shape', 'c', 'n_intervals', 1, 'runs', niter, 'verbose',0, 'sens', 0, 'cuts',cuts_f,'CONF',[.025 .975]);%,'FIX_GAMMA',0);
xlabel('coherence')
ylabel('P(rightward)')
title('Pre-Conditioning')
axis([min(x) max(x) 0 1])
set(gca,'XTick',x)

subplot(2,2,[2 4])
pfit(dataT.stwo,'plot without stats','shape', 'c', 'n_intervals', 1, 'runs', niter, 'verbose',0, 'sens', 0, 'cuts',cuts_f,'CONF',[.025 .975]);%,'FIX_GAMMA',0);
hold on
pfit(dataT.ns,'plot without stats','shape', 'c', 'n_intervals', 1, 'runs', niter, 'verbose',0, 'sens', 0, 'cuts',cuts_f,'CONF',[.025 .975]);%,'FIX_GAMMA',0);
xlabel('coherence')
ylabel('P(rightward)')
title('Post-Conditioning')
axis([min(x) max(x) 0 1])
set(gca,'XTick',x)


figure(3)
subplot(2,2,1)
pfit(dataC.sone,'plot without stats','shape', 'c', 'n_intervals', 1, 'runs', niter, 'verbose',0, 'sens', 0, 'cuts',cuts_f,'CONF',[.025 .975]);%,'FIX_GAMMA',0);
hold on
pfit(dataT.sone,'plot without stats','shape', 'c', 'n_intervals', 1, 'runs', niter, 'verbose',0, 'sens', 0, 'cuts',cuts_f,'CONF',[.025 .975]);%,'FIX_GAMMA',0);
xlabel('coherence')
ylabel('P(rightward)')
title('Pre vs Post - Sound 1')
axis([min(x) max(x) 0 1])
set(gca,'XTick',x)

subplot(2,2,2)
pfit(dataC.stwo,'plot without stats','shape', 'c', 'n_intervals', 1, 'runs', niter, 'verbose',0, 'sens', 0, 'cuts',cuts_f,'CONF',[.025 .975]);%,'FIX_GAMMA',0);
hold on
pfit(dataT.stwo,'plot without stats','shape', 'c', 'n_intervals', 1, 'runs', niter, 'verbose',0, 'sens', 0, 'cuts',cuts_f,'CONF',[.025 .975]);%,'FIX_GAMMA',0);
xlabel('coherence')
ylabel('P(rightward)')
title('Pre vs Post - Sound 2')
axis([min(x) max(x) 0 1])
set(gca,'XTick',x)

subplot(2,2,3)
for i = 1:2
    xc = thresholds(1,i);
    xt = thresholds(2,i);
    
    uc = Uci(1,i);
    ut = Uci(2,i);
    
    lc = Lci(1,i);
    lt = Lci(2,i);
    
    errorbar(x1c+i,xc,abs(xc-lc),abs(xc-uc),'.k')
    hold on
    errorbar(x1t+i,xt,abs(xt-lt),abs(xt-ut),'.r')
end
ylabel('PSE');
title('95% CIs of the shifts in PSEs');
legend('Preconditioning', 'Post conditioning');

subplot(2,2,4)
pfit(dataC.ns,'plot without stats','shape', 'c', 'n_intervals', 1, 'runs', niter, 'verbose',0, 'sens', 0, 'cuts',cuts_f,'CONF',[.025 .975]);%,'FIX_GAMMA',0);
hold on
pfit(dataT.ns,'plot without stats','shape', 'c', 'n_intervals', 1, 'runs', niter, 'verbose',0, 'sens', 0, 'cuts',cuts_f,'CONF',[.025 .975]);%,'FIX_GAMMA',0);
xlabel('coherence')
ylabel('P(rightward)')
title('Pre vs Post - No Sound')
axis([min(x) max(x) 0 1])
set(gca,'XTick',x)

% for i = 1:3
%     xc = slopes(1,i);
%     xt = slopes(2,i);
%     
%     uc = sUci(1,i);
%     ut = sUci(2,i);
%     
%     lc = sLci(1,i);
%     lt = sLci(2,i);
%     
%     errorbar(x1c+i,xc,abs(xc-lc),abs(xc-uc),'.k')
%     hold on
%     errorbar(x1t+i,xt,abs(xt-lt),abs(xt-ut),'.r')
% end
% ylabel('PSE');
% title('95% CIs of the difference in Slopes');
% legend('Preconditioning', 'Post conditioning');
% 



