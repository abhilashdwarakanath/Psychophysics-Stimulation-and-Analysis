clear all
clc
close all

% Analyse parametrised Visual Detection data

%% Load

%cd('/home/abhilash/Documents/MATLAB/Contrast Gain/Processed Data/Paradigm1');
cd('C:\Users\lab\Documents\MATLAB\Abhi\Psychophysics\For Ninni\Contrast Gain\Processed Data\Parametrized');

%dirName.P1 = '/home/abhilash/Documents/MATLAB/Contrast Gain/Processed Data/Paradigm1';
dirName.P1 = 'C:\Users\lab\Documents\MATLAB\Abhi\Psychophysics\For Ninni\Contrast Gain\Processed Data\Parametrized';

d = dir(dirName.P1);

%% Specify Parameters

%dd = [1 2 4 5 6 7 9 10]; %Valid subjects
Params.nIter = 20;
Params.C = [0,5,7,9.5,12,14.5,17.5,22.5];
Params.a = 0.75;
Params.b = [3 10];
Params.t = [0 30];
Params.l = [0 0.5];
Params.g = [0.4 0.6];
Params.nboot = 1499;
Params.cuts = [0.625 0.75 0.875];

%% Fit single subject

for i = 3:length(d)
    
    if i == 4
        
        Params.C = [0,9,11,13.5,16,18.5,24,29];
        
    end
    
    load(d(i,1).name);
    
    for j = 1:size(Performance,1)
        
        subind = num2str(j);
    
        results{1,i}.cond{1,j} = psychfit(Params,Performance(j,:));
        
    end
    
end

results(cellfun('isempty',results)) = [];

s = length(results);

%% Plotting individual fits

ss = get(0, 'ScreenSize');
figure('Position',[1 1 ss(3) ss(4)]);

for i = 1:s
    
    subplot(2,1,i)
    
    plot(results{1,i}.cond{1,1}.full_axis,results{1,i}.cond{1,1}.full_model,'-b','LineWidth',1)
    hold on
    plot(results{1,i}.cond{1,2}.full_axis,results{1,i}.cond{1,2}.full_model,'-g','LineWidth',1)
    plot(results{1,i}.cond{1,3}.full_axis,results{1,i}.cond{1,3}.full_model,'-r','LineWidth',1)
    plot(results{1,i}.cond{1,4}.full_axis,results{1,i}.cond{1,4}.full_model,'-k','LineWidth',1)
    legend('1','2','3','4','Location','SouthEast')
    plot(Params.C,results{1,i}.cond{1,1}.data,'+b','MarkerSize',5,'MarkerFaceColor','b')
    plot(Params.C,results{1,i}.cond{1,2}.data,'*g','MarkerSize',5,'MarkerFaceColor','g')
    plot(Params.C,results{1,i}.cond{1,3}.data,'dr','MarkerSize',5,'MarkerFaceColor','r')
    plot(Params.C,results{1,i}.cond{1,4}.data,'vk','MarkerSize',5,'MarkerFaceColor','k')
    title(['Weibull fit for subject ',' ', num2str(i) ': all 4 levels'],'FontSize',10)
    axis([0 max(results{1,i}.cond{1,1}.full_axis) 0.4 1])
    xlabel('Contrast','FontSize',10)
    ylabel('Proportion detected','FontSize',10)
    grid on
    
end
