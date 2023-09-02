clear all
close all
clc

% This script generates HRF fits for data obtained from the contrast
% detection experiments. 
%
% Abhilash Dwarakanath. MPI für Biologische Kybernetik. 2012.

%% Load

%cd('/home/abhilash/Documents/MATLAB/Contrast Gain/Processed Data/Paradigm1');
cd('C:\MATLAB\Abhi\Psychophysics\For Ninni\Contrast Gain\Processed Data\Paradigm3');

%dirName.P1 = '/home/abhilash/Documents/MATLAB/Contrast Gain/Processed Data/Paradigm1';
dirName.P1 = 'C:\MATLAB\Abhi\Psychophysics\For Ninni\Contrast Gain\Processed Data\Paradigm3';

d = dir(dirName.P1);

%% Specify Parameters

%dd = [1 2 4 5 6 7 9 10]; %Valid subjects
Params.nIter = 20;
Params.C = [0,6,9.5,13,16.5,20,23.5,30];
Params.b = [0 5];
Params.t = [0 30];
Params.a = (0.5)^(1/3);
Params.nboot = 1499;
Params.cuts = [0.625 0.75 0.875];

%% Analyse single subjects

% With sound

for i = 3:length(d)
    
    h = waitbar(0,sprintf('Step 1: Fitting %d HRFs',length(d)-2));
    
    load(d(i,1).name);
    
    results_sound{1,i} = psychfit(Params,Performance(1,:));
    
    waitbar(i/length(d)-2,h)
    
end

delete(h);

% Without sound

for i = 3:length(d)
    
    h = waitbar(0,sprintf('Step 1: Fitting %d HRFs',length(d)-2));
    
    load(d(i,1).name);
    
    results_no_sound{1,i} = psychfit(Params,Performance(2,:));
    
    waitbar(i/length(d)-2,h)
    
end

delete(h);

results_sound(cellfun('isempty',results_sound)) = [];
results_no_sound(cellfun('isempty',results_no_sound)) = [];

s = length(results_sound);

%% Analyse super subject

for i = 1:s
    
    sound(i,:) = results_sound{1,i}.data;
    
    no_sound(i,:) = results_no_sound{1,i}.data;
    
end

sound_ss = mean(sound,1);

no_sound_ss = mean(no_sound,1);

results_sound_ss = psychfit(Params,sound_ss);

results_no_sound_ss = psychfit(Params,no_sound_ss);


%% Statistics

for i = 1:s
    
    stats_gain(i,1) = results_sound{1,i}.b;
    stats_gain(i,2) = results_no_sound{1,i}.b;
    
    stats_N(i,1) = results_sound{1,i}.t;
    stats_N(i,2) = results_no_sound{1,i}.t;
    
end

% Wilcoxon Sign-Rank Test

Significance.wilcox_gain = signrank(stats_gain(:,1),stats_gain(:,2));
Significance.wilcox_N = signrank(stats_N(:,1),stats_N(:,2));

% Sign test

Significance.ST_gain = signtest(stats_gain(:,1),stats_gain(:,2));
Significance.ST_N = signtest(stats_N(:,1),stats_N(:,2));

% t-test with Bonferroni correction
Significance.bonf_gain = ttest_bonf(stats_gain,[1 2],0.05,0);
Significance.bonf_N = ttest_bonf(stats_N,[1 2],0.05,0);

%% Plotting individual fits

ss = get(0, 'ScreenSize');
figure('Position',[1 1 ss(3) ss(4)]);

for i = 1:s
    
    subplot(3,4,i)
    plot(results_sound{1,i}.full_axis,results_sound{1,i}.full_model,'-r','LineWidth',1)
    hold on
    plot(results_no_sound{1,i}.full_axis,results_no_sound{1,i}.full_model,'-g','LineWidth',1)
    legend('High Noise','Low Noise','Location','SouthEast')
    plot(Params.C,results_sound{1,i}.data,'dr','MarkerSize',5,'MarkerFaceColor','r')
    plot(Params.C,results_no_sound{1,i}.data,'og','MarkerSize',7,'MarkerFaceColor','g')
    title(['HRF fit for subject ',' ', num2str(i-2)],'FontSize',10)
    axis([0 max(results_sound{1,i}.full_axis) 0.4 1])
    xlabel('Contrast','FontSize',10)
    ylabel('Proportion detected','FontSize',10)
    grid on
    
end

%% Plotting super subject data

figure('Position',[1 1 ss(3) ss(4)]);

subplot(3,1,1)
plot(results_sound_ss.full_axis,results_sound_ss.full_model,'-r','LineWidth',1)
hold on
plot(results_no_sound_ss.full_axis,results_no_sound_ss.full_model,'-g','LineWidth',1)
legend('High Noise','Low Noise','Location','SouthEast')
plot(Params.C,results_sound_ss.data,'dr','MarkerSize',5,'MarkerFaceColor','r')
plot(Params.C,results_no_sound_ss.data,'og','MarkerSize',7,'MarkerFaceColor','g')
title('Super subject fit','FontSize',15)
axis([0 max(results_sound{1,i}.full_axis) 0.4 1])
xlabel('Contrast','FontSize',15)
ylabel('Proportion detected','FontSize',15)
grid on

% Plotting Gain scatter

subplot(3,1,2)

for i = 1:s

    plot(results_sound{1,i}.G,results_no_sound{1,i}.G,'ob','MarkerSize',5,'MarkerFaceColor','b');
    hold on
    plot([0 5],[0 5], '-k')
    title('Slopes per subject, High Noise vs Low Noise','FontSize',15)
    axis([0 5 0 5])
    xlabel('Slopes - High Noise','FontSize',15)
    ylabel('Slopes - Low Noise','FontSize',15)
    grid on
    
end

% Plotting N scatter

subplot(3,1,3)

for i = 1:s

    plot(results_sound{1,i}.N,results_no_sound{1,i}.N,'og','MarkerSize',5,'MarkerFaceColor','g');
    hold on
    plot([10 26],[10 26], '-k')
    title('Thresholds at 50% per subject, High Noise vs Low Noise','FontSize',15)
    axis([10 26 10 26])
    xlabel('Gain order - High Noise','FontSize',15)
    ylabel('Gain order - Low Noise','FontSize',15)
    grid on
    
end