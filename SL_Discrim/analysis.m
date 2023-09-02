clear all
close all
clc

% Analysis program for the Predictive coding experiments. Abhilash
% Dwarakanath. MPI f�r Biologische Kybernetik. 27.02.2013.

%% Analyse psych

fn = input('Enter name  :  ','s');
dirName = ['Y:\Documents\MATLAB\Abhi\PredCod_discrim\Data\' fn '\'];
%dirName = ['/home/aglo-lab/Documents/MATLAB/Abhi/PredCod_discrim/Data/' fn '/'];

cd(dirName);

filenameC = [fn 'dataC' '1' '.mat'];
filenameT = [fn 'dataT' '1' '.mat'];

KbName('UnifyKeyNames'); % Unifying Mac and PC Keyboards
ExpParams.lKey = 114;%KbName('LeftArrow'); % Map to response : left detected
ExpParams.rKey = 115;%KbName('RightArrow'); % Map to response : right detected

cd('JND');
load('jnd.mat');
jnd = (sub_jnd);
cd ..

cd('Control');
load([filenameC]);

[hitsC,trlsC,vecC,istC,sollC,ind_istC,ind_sollC] = processdata(dirName,ExpParams,responses,trial_order,freq_order,jnd);
%[hitsC,trlsC,vecC,istC,sollC] = processdata2(dirName,ExpParams,responses,trial_types,trial_order,freq_order,jnd);
clear responses; clear trial_types; clear trial_order; clear freq_order;

cd('Test')
load([filenameT]);

[hitsT,trlsT,vecT,istT,sollT,ind_istT,ind_sollT] = processdata(dirName,ExpParams,responses,trial_order,freq_order,jnd);
%[hitsT,trlsT,vecT,istT,sollT] = processdata2(dirName,ExpParams,responses,trial_types,trial_order,freq_order,jnd);
clear responses; clear trial_order; clear freq_order;

% Prepare for psignifit

ax = ([jnd*-7.5 jnd*-5 jnd*-2.5 0 jnd*2.5 jnd*5 jnd*7.5])';
niter = 1999;
cuts_f = [0.25 0.5 0.75];
%%
dataC.s = [ax hitsC.sound' (trlsC.sound)'];
dataC.ws = [ax hitsC.wsound' (trlsC.wsound)'];
dataC.ns = [ax hitsC.nosound' (trlsC.nosound)'];
dataT.s = [ax hitsT.sound' (trlsT.sound)'];
dataT.ws = [ax hitsT.wsound' (trlsT.wsound)'];
dataT.ns = [ax hitsT.nosound' (trlsT.nosound)'];
%% Run

figure(1)

subplot(3,1,1)
results_asc = pfit(dataC.s,'plot without stats','shape', 'c', 'n_intervals', 1, 'runs', niter, 'verbose',0, 'sens', 0, 'cuts',cuts_f);%,'FIX_GAMMA',0);
hold on
results_ast = pfit(dataT.s,'plot without stats','shape', 'c', 'n_intervals', 1, 'runs', niter, 'verbose',0, 'sens', 0, 'cuts',cuts_f);%,'FIX_GAMMA',0);
xlabel('dt')
ylabel('P(clockwise)')
title('Pre vs Post - WITH Aud. Pred.')
legend('Pre','Post','Location','NorthWest')
axis([min(ax) max(ax) 0 1])

subplot(3,1,2)
results_awsc = pfit(dataC.ws,'plot without stats','shape', 'c', 'n_intervals', 1, 'runs', niter, 'verbose',0, 'sens', 0, 'cuts',cuts_f);%,'FIX_GAMMA',0);
hold on
results_awst = pfit(dataT.ws,'plot without stats','shape', 'c', 'n_intervals', 1, 'runs', niter, 'verbose',0, 'sens', 0, 'cuts',cuts_f);%,'FIX_GAMMA',0);
xlabel('dt')
ylabel('P(clockwise)')
title('Pre vs Post - WRONG AUD.Pred.')
legend('Pre','Post','Location','NorthWest')
axis([min(ax) max(ax) 0 1])

subplot(3,1,3)
results_ansc = pfit(dataC.ns,'plot without stats','shape', 'c', 'n_intervals', 1, 'runs', niter, 'verbose',0, 'sens', 0, 'cuts',cuts_f);%,'FIX_GAMMA',0);
hold on
results_anst = pfit(dataT.ns,'plot without stats','shape', 'c', 'n_intervals', 1, 'runs', niter, 'verbose',0, 'sens', 0, 'cuts',cuts_f);%,'FIX_GAMMA',0);
xlabel('dt')
ylabel('P(clockwise)')
title('Pre vs Post - WITHOUT AUD.Pred.')
legend('Pre','Post','Location','NorthWest')
axis([min(ax) max(ax) 0 1])

figure(2)

subplot(2,1,1)
results_Cs = pfit(dataC.s,'plot without stats','shape', 'c', 'n_intervals', 1, 'runs', niter, 'verbose',0, 'sens', 0, 'cuts',cuts_f);%,'FIX_GAMMA',0);
hold on
results_Cws = pfit(dataC.ws,'plot without stats','shape', 'c', 'n_intervals', 1, 'runs', niter, 'verbose',0, 'sens', 0, 'cuts',cuts_f);%,'FIX_GAMMA',0);
results_Cns = pfit(dataC.ns,'plot without stats','shape', 'c', 'n_intervals', 1, 'runs', niter, 'verbose',0, 'sens', 0, 'cuts',cuts_f,'FIX_GAMMA',0);
xlabel('dt')
ylabel('P(clockwise)')
title('Pre-test - With sound vs No Sound')
legend('S','NS','Location','NorthWest')
axis([min(ax) max(ax) 0 1])

subplot(2,1,2)
results_Ts = pfit(dataT.s,'plot without stats','shape', 'c', 'n_intervals', 1, 'runs', niter, 'verbose',0, 'sens', 0, 'cuts',cuts_f);%,'FIX_GAMMA',0);
hold on
results_Tws = pfit(dataT.ws,'plot without stats','shape', 'c', 'n_intervals', 1, 'runs', niter, 'verbose',0, 'sens', 0, 'cuts',cuts_f);%,'FIX_GAMMA',0);
results_Tns = pfit(dataT.ns,'plot without stats','shape', 'c', 'n_intervals', 1, 'runs', niter, 'verbose',0, 'sens', 0, 'cuts',cuts_f);%,'FIX_GAMMA',0);
xlabel('dt')
ylabel('P(clockwise)')
title('Post-test - With sound vs No Sound')
legend('S','NS','Location','NorthWest')
axis([min(ax) max(ax) 0 1])

%% Analyse MoA Gaussians

load association.mat

if association(1,2) < 90
        a = association(1,2);
        o = association(2,2);
    else
        a = association(2,2);
        o = association(1,2);
end

ori1 = vecC.sound(vecC.sound<100);
ori2 = vecC.sound(vecC.sound>100);
ori1 = ori1-a;
ori2 = ori2-o;
ori = [ori1 ori2];
vecC.sound = shuffle(ori);
ori1 = vecT.sound(vecT.sound<100);
ori2 = vecT.sound(vecT.sound>100);
ori1 = ori1-a;
ori2 = ori2-o;
ori = [ori1 ori2];
vecT.sound = shuffle(ori);

clear ori1
clear ori2

ori1 = vecC.wsound(vecC.wsound<100);
ori2 = vecC.wsound(vecC.wsound>100);
ori1 = ori1-a;
ori2 = ori2-o;
ori = [ori1 ori2];
vecC.wsound = shuffle(ori);
ori1 = vecT.wsound(vecT.wsound<100);
ori2 = vecT.wsound(vecT.wsound>100);
ori1 = ori1-a;
ori2 = ori2-o;
ori = [ori1 ori2];
vecT.wsound = shuffle(ori);

clear ori1
clear ori2

ori1 = vecC.nosound(vecC.nosound<100);
ori2 = vecC.nosound(vecC.nosound>100);
ori1 = ori1-a;
ori2 = ori2-o;
ori = [ori1 ori2];
vecC.nosound = shuffle(ori);
ori1 = vecT.nosound(vecT.nosound<100);
ori2 = vecT.nosound(vecT.nosound>100);
ori1 = ori1-a;
ori2 = ori2-o;
ori = [ori1 ori2];
vecT.nosound = shuffle(ori);

figure(3)
subplot(321)
histfit(vecC.sound,20)
axis([-35 35 0 40])
xlabel('d(theta)')
ylabel('Hits')
title('Pre-training - Correct Sound')
subplot(322)
histfit(vecT.sound,20)
axis([-35 35 0 40])
xlabel('d(theta)')
ylabel('Hits')
title('Post-training - Correct Sound')

subplot(323)
histfit(vecC.wsound,20)
axis([-35 35 0 20])
xlabel('d(theta)')
ylabel('Hits')
title('Pre-training - Wrong Sound')
subplot(324)
histfit(vecT.wsound,20)
axis([-35 35 0 20])
xlabel('d(theta)')
ylabel('Hits')
title('Post-training - wrong Sound')

subplot(325)
histfit(vecC.nosound,20)
axis([-35 35 0 20])
xlabel('d(theta)')
ylabel('Hits')
title('Pre-training - Wrong Sound')
subplot(326)
histfit(vecT.nosound,20)
axis([-35 35 0 20])
xlabel('d(theta)')
ylabel('Hits')
title('Post-training - wrong Sound')

%% Analyse MoA scatter

figure(4)

%subplot(3,1,1)
[mC]=polyfit(sollC.sound,istC.sound,1);
f = polyval(mC,sollC.sound);
errorbar(sollC.sound,istC.sound,ind_istC.err,'bo')
hold on
plot(sollC.sound,f,'-b','LineWidth',1.5);
mT = polyfit(sollT.sound,istT.sound,1);
f = polyval(mT,sollT.sound);
errorbar(sollT.sound,istT.sound,ind_istT.err,'ro')
hold on
plot(sollT.sound,f,'-r','LineWidth',1.5);
plot([jnd*-12:jnd*12],[jnd*-12:jnd*12],'-k')
axis([jnd*-12 jnd*12 jnd*-12 jnd*12])
legend('BA - data','BA - Fit','AA - data','AA - Fit','Identity line','Location','NorthWest');
xlabel('d(theta) - Presented')
ylabel('d(theta) - Percieved')
title('Percieved vs Presented - WITH aud. predictor')

figure(5)
for i = 1:7
plot(ind_sollC.(['sound' num2str(i)]),ind_istC.(['sound' num2str(i)]),'ob')
hold on
plot(ind_sollT.(['sound' num2str(i)]),ind_istT.(['sound' num2str(i)]),'or')
plot([jnd*-9:jnd*9],[jnd*-9:jnd*9],'-k')
end

% subplot(3,1,2)
% [mC]=polyfit(sollC.wsound,istC.wsound,1);
% f = polyval(mC,sollC.wsound);
% plot(sollC.wsound,istC.wsound,'bo')
% hold on
% plot(sollC.wsound,f,'-b','LineWidth',1.5);
% mT = polyfit(sollT.wsound,istT.wsound,1);
% f = polyval(mT,sollT.wsound);
% plot(sollT.wsound,istT.wsound,'ro')
% hold on
% plot(sollT.wsound,f,'-r','LineWidth',1.5);
% plot([jnd*-9:jnd*9],[jnd*-9:jnd*9],'-k')
% axis([jnd*-9 jnd*9 jnd*-9 jnd*9])
% legend('BA - data','BA - Fit','AA - data','AA - Fit','Identity line','Location','NorthWest');
% xlabel('d(theta) - Presented')
% ylabel('d(theta) - Percieved')
% title('Percieved vs Presented - WITH aud. predictor')
% 
% subplot(3,1,3)
% [mC]=polyfit(sollC.nsound,istC.nsound,1);
% f = polyval(mC,sollC.nsound);
% plot(sollC.nsound,istC.nsound,'bo')
% hold on
% plot(sollC.nsound,f,'-b','LineWidth',1.5);
% mT = polyfit(sollT.nsound,istT.nsound,1);
% f = polyval(mT,sollT.nsound);
% plot(sollT.nsound,istT.nsound,'ro')
% hold on
% plot(sollT.sound,f,'-r','LineWidth',1.5);
% plot([jnd*-9:jnd*9],[jnd*-9:jnd*9],'-k')
% axis([jnd*-9 jnd*9 jnd*-9 jnd*9])
% legend('BA - data','BA - Fit','AA - data','AA - Fit','Identity line','Location','NorthWest');
% xlabel('d(theta) - Presented')
% ylabel('d(theta) - Percieved')
% title('Percieved vs Presented - WITH aud. predictor')
