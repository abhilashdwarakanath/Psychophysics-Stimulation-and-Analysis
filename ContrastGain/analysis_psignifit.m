clear all
close all
clc

% This program is the first analysis program for the AMP ezperiments. It plots the psychometric curve for the responses and fits a Weibull function to it.
% Abhilash Dwarakanath. GSN-LMU München & Uni-Bielefeld. 19.12.2011.

% -------------------------------------------------------------------PROGRAM START-----------------------------------------------------------------------------%

%% Loading subject data

% find folder
folder = uigetdir;

% get the names of all files. dirListing is a struct array.
dirListing = dir(folder);

% loop through the files and open. Note that dir also lists the directories, so you have to check for them.
for d = 1:length(dirListing)
    if ~dirListing(d).isdir
        
        fileName = fullfile(folder,dirListing(d).name); % use full path because the folder may not be the active path
        
        % open your file here
        load(fileName);
        
    end
    
end

%% Define parameters

spkPos = ([4 9 16 25 37 56 87 145]+44)./100;
z = (spkPos - spkPos(4));
z = z./spkPos(4);
%Params.T = z(4);
z = [z(1:3) z(5:end)];

Params.spkNum = 7;
Params.cond = 2;
Params.nIter = 1999;
Params.cuts = [0.16 0.5 0.84];


%% Start analysis

dataT = processraw(responseT,Params);
dataC = processraw(responseC,Params);

%%

inputmatT = [z' dataT' 20.*ones(7,1)];
inputmatC = [z' dataC' 20.*ones(7,1)];

figure(1)
resultsC = pfit(inputmatC,'plot without stats','shape', 'cumulative Gaussian', 'n_intervals', 1, 'runs', Params.nIter, 'verbose',0, 'sens', 0, 'cuts',Params.cuts);
axis([0 max(z) 0 1])

figure(2)
resultsT = pfit(inputmatT,'plot without stats','shape', 'cumulative Gaussian', 'n_intervals', 1, 'runs', Params.nIter, 'verbose',0, 'sens', 0, 'cuts',Params.cuts);
axis([0 max(z) 0 1])

% -------------------------------------------------------------------PROGRA
% M   END-----------------------------------------------------------------------------%