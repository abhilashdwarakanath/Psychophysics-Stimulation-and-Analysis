clear all 
close all
clc

% This program plots scatters of parameters across conditions between the
% two Paradigms for comparison

%% Load data

load ResPar1.mat
load ResPar3.mat

n = 10;

dd = [7 8 9 10 11 12 13 14 15 16] + 2; %Valid subjects
Params.C = [0,6,9.5,13,16.5,20,23.5,30];

%% Statistics

for i = 1:n
    
    stats_gain(i,1) = results_sound_Par1{1,i}.G;
    stats_gain(i,2) = results_sound_par3{1,i}.G;
    stats_gain(i,3) = results_no_sound_Par1{1,i}.G;
    stats_gain(i,4) = results_no_sound_par3{1,i}.G;
    
    stats_N(i,1) = results_sound_Par1{1,i}.N;
    stats_N(i,2) = results_sound_par3{1,i}.N;
    stats_N(i,3) = results_no_sound_Par1{1,i}.N;
    stats_N(i,4) = results_no_sound_par3{1,i}.N;
    
    stats_C50(i,1) = results_sound_Par1{1,i}.C50;
    stats_C50(i,2) = results_sound_par3{1,i}.C50;
    stats_C50(i,3) = results_no_sound_Par1{1,i}.C50;
    stats_C50(i,4) = results_no_sound_par3{1,i}.C50;
    
end

% Wilcoxon Sign-Rank Test

Significance.wilcox_gain.Par(1) = signrank(stats_gain(:,1),stats_gain(:,2));
Significance.wilcox_gain.Par(2) = signrank(stats_gain(:,3),stats_gain(:,4));
Significance.wilcox_N.Par(1) = signrank(stats_N(:,1),stats_N(:,2));
Significance.wilcox_N.Par(2) = signrank(stats_N(:,3),stats_N(:,4));
Significance.wilcox_C50.Par(1) = signrank(stats_C50(:,1),stats_C50(:,2));
Significance.wilcox_C50.Par(2) = signrank(stats_C50(:,3),stats_C50(:,4));

% Sign test

Significance.ST_gain.Par(1) = signtest(stats_gain(:,1),stats_gain(:,2));
Significance.ST_gain.Par(2) = signtest(stats_gain(:,3),stats_gain(:,4));
Significance.ST_N.Par(1) = signtest(stats_N(:,1),stats_N(:,2));
Significance.ST_N.Par(2) = signtest(stats_N(:,3),stats_N(:,4));
Significance.ST_C50.Par(1) = signtest(stats_C50(:,1),stats_C50(:,2));
Significance.ST_C50.Par(2) = signtest(stats_C50(:,3),stats_C50(:,4));

% t-test with Bonferroni correction
Significance.ttbonf_gain.Par(1) = ttest_bonf(stats_gain, [1 2], 0.05, 0);
Significance.ttbonf_gain.Par(2) = ttest_bonf(stats_gain, [3 4], 0.05, 0);
Significance.ttbonf_N.Par(1) = ttest_bonf(stats_N, [1 2], 0.05, 0);
Significance.ttbonf_N.Par(2) = ttest_bonf(stats_N, [3 4], 0.05, 0);
Significance.ttbonf_C50.Par(1) = ttest_bonf(stats_C50, [1 2], 0.05, 0);
Significance.ttbonf_C50.Par(2) = ttest_bonf(stats_C50, [3 4], 0.05, 0);

%% Plot Sound vs Noise

ss = get(0, 'ScreenSize');
figure('Position',[1 1 ss(3) ss(4)]);

for i = 1:n
    
    subplot(5,2,i)
    plot(results_sound_Par1{1,i}.full_axis,results_sound_Par1{1,i}.full_model,'-r','LineWidth',1)
    hold on
    plot(results_sound_par3{1,i}.full_axis,results_sound_par3{1,i}.full_model,'-k','LineWidth',1)
    legend('Brief Sound','Constant Noise','Location','SouthEast')
    plot(Params.C,results_sound_Par1{1,i}.data,'dr','MarkerSize',5,'MarkerFaceColor','r')
    plot(Params.C,results_sound_par3{1,i}.data,'ok','MarkerSize',7,'MarkerFaceColor','k')
    title(['HRF fit for subject ',' ', num2str(i) ' Sound vs Noise'],'FontSize',10)
    axis([0 max(results_sound_Par1{1,i}.full_axis) 0.4 1])
    xlabel('Contrast','FontSize',10)
    ylabel('Proportion detected','FontSize',10)
    grid on
    
end

%% Plot No Sound vs No Noise

ss = get(0, 'ScreenSize');
figure('Position',[1 1 ss(3) ss(4)]);

for i = 1:n
    
    subplot(5,2,i)
    plot(results_no_sound_Par1{1,i}.full_axis,results_no_sound_Par1{1,i}.full_model,'-r','LineWidth',1)
    hold on
    plot(results_no_sound_par3{1,i}.full_axis,results_no_sound_par3{1,i}.full_model,'-k','LineWidth',1)
    legend('No Sound','No Noise','Location','SouthEast')
    plot(Params.C,results_no_sound_Par1{1,i}.data,'dr','MarkerSize',5,'MarkerFaceColor','r')
    plot(Params.C,results_no_sound_par3{1,i}.data,'ok','MarkerSize',7,'MarkerFaceColor','k')
    title(['HRF fit for subject ',' ', num2str(i) ' No Sound vs No Noise'],'FontSize',10)
    axis([0 max(results_no_sound_Par1{1,i}.full_axis) 0.4 1])
    xlabel('Contrast','FontSize',10)
    ylabel('Proportion detected','FontSize',10)
    grid on
    
end

%% Scatter plot of gains, slopes and c50

ss = get(0, 'ScreenSize');
figure('Position',[1 1 ss(3) ss(4)]);

% Gains

subplot(3,2,1)

for i = 1:n

    plot(results_sound_Par1{1,i}.G,results_sound_par3{1,i}.G,'or','MarkerSize',5,'MarkerFaceColor','r');
    hold on
    plot([0.2 1.1],[0.2 1.1], '-k')
    title('Contrast gains per subject, Sound vs Noise','FontSize',15)
    axis([0.2 1.1 0.2 1.1])
    xlabel('Contrast gain - Sound','FontSize',15)
    ylabel('Contrast gain - Noise','FontSize',15)
    grid on
    
end

subplot(3,2,2)

for i = 1:n

    plot(results_no_sound_Par1{1,i}.G,results_no_sound_par3{1,i}.G,'ok','MarkerSize',5,'MarkerFaceColor','k');
    hold on
    plot([0.2 1.1],[0.2 1.1], '-k')
    title('Contrast gains per subject, No Sound vs No Noise','FontSize',15)
    axis([0.2 1.1 0.2 1.1])
    xlabel('Contrast gain - No Sound','FontSize',15)
    ylabel('Contrast gain - No Noise','FontSize',15)
    grid on
    
end

% Slopes

subplot(3,2,3)

for i = 1:n

    plot(results_sound_Par1{1,i}.N,results_sound_par3{1,i}.N,'or','MarkerSize',5,'MarkerFaceColor','r');
    hold on
    plot([0 7.5],[0 7.5], '-k')
    title('Slopes per subject, Sound vs Noise','FontSize',15)
    axis([0 7.5 0 7.5])
    xlabel('Slopes - Sound','FontSize',15)
    ylabel('Slopes - Noise','FontSize',15)
    grid on
    
end

subplot(3,2,4)

for i = 1:n

    plot(results_no_sound_Par1{1,i}.N,results_no_sound_par3{1,i}.N,'ok','MarkerSize',5,'MarkerFaceColor','k');
    hold on
    plot([0 7.5],[0 7.5], '-k')
    title('Slopes per subject, No Sound vs No Noise','FontSize',15)
    axis([0 7.5 0 7.5])
    xlabel('Slopes - No Sound','FontSize',15)
    ylabel('Slopes - No Noise','FontSize',15)
    grid on
    
end

% C50s

subplot(3,2,5)

for i = 1:n

    plot(results_sound_Par1{1,i}.C50,results_sound_par3{1,i}.C50,'or','MarkerSize',5,'MarkerFaceColor','r');
    hold on
    plot([10 35],[10 35], '-k')
    title('C50 per subject, Sound vs Noise','FontSize',15)
    axis([10 35 10 35])
    xlabel('C50 - Sound','FontSize',15)
    ylabel('C50 - Noise','FontSize',15)
    grid on
    
end

subplot(3,2,6)

for i = 1:n

    plot(results_no_sound_Par1{1,i}.C50,results_no_sound_par3{1,i}.C50,'ok','MarkerSize',5,'MarkerFaceColor','k');
    hold on
    plot([10 35],[10 35], '-k')
    title('C50 per subject, No Sound vs No Noise','FontSize',15)
    axis([10 35 10 35])
    xlabel('C50 - Sound','FontSize',15)
    ylabel('C50 - No Sound','FontSize',15)
    grid on
    
end