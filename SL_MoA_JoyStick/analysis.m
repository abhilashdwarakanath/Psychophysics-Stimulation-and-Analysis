clear all
close all
clc

% Analysis program for the Predictive coding experiments. Abhilash
% Dwarakanath. MPI f�r Biologische Kybernetik. 27.02.2013.

%% Analyse

fn = input('Enter name  :  ','s');
dirName = ['C:\MATLAB\Abhi\Psychophysics\PredCodScripts\PredCod_Det\Data\' fn '\'];
cd(dirName);

filenameC = [fn 'dataC' '1' '.mat'];
filenameT = [fn 'dataT' '3' '.mat'];

cd('Control');
load(filenameC);

[pc,fc,tpc,tfc] = processdata(responses,trial_order);
clear responses; clear trial_order; clear reaction_times; clear freq_order;
cd ..

cd('Test')
load(filenameT);

[pt,ft,tpt,tft] = processdata(responses,trial_order);
cd ..
clear responses; clear trial_order; clear reaction_times; clear freq_order;

caxis = linspace(0.2,0.8,7);
caxis = log10(caxis);

%% Prepare for psignifit & Plot

niter = 1999;

dat_psyc = [caxis' pc' tpc'];
dat_psyt = [caxis' pt' tpt'];
dat_psyc2 = [caxis' tfc(1)-fc' tfc'];
dat_psyt2 = [caxis' tft(1)-ft' tft'];

cuts_f = [0.25 0.5 0.75];

figure(1)
results_c = pfit(dat_psyc,'plot without stats','shape', 'c', 'n_intervals', 2, 'runs', niter, 'verbose',0, 'sens', 0, 'cuts',cuts_f);
hold on
results_t = pfit(dat_psyt,'plot without stats','shape', 'c', 'n_intervals', 2, 'runs', niter, 'verbose',0, 'sens', 0, 'cuts',cuts_f);
xlabel('contrast')
ylabel('P(M|M)')
title('Control vs Test')
legend('Control','Test','Location','NorthWest')
axis([min(caxis) max(caxis) 0.4 1])

figure(2)
results_fc = pfit(dat_psyc2,'plot without stats','shape', 'c', 'n_intervals', 2, 'runs', niter, 'verbose',0, 'sens', 0, 'cuts',cuts_f);
hold on
results_ft = pfit(dat_psyt2,'plot without stats','shape', 'c', 'n_intervals' , 2, 'runs', niter, 'verbose',0, 'sens', 0, 'cuts',cuts_f);
xlabel('contrast')
ylabel('P(M|C)')
title('Control vs Test - CONFLICT ONLY')
legend('Control','Test','Location','NorthWest')
axis([min(caxis) max(caxis) 0.4 1])