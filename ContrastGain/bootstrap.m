clear all
close all
clc

%% Load data

load dataSet.mat

%% Assign parameters

Params.nIter = 20;
Params.C = [0 4 6.5 9 13.5 18 23.5 30];
Params.G = [0 5];
Params.N = [0 7];
Params.C50 = [0 35];
Params.nboot = 2000;

%% Run bootstrap

fitbs = @hlf_for_bootstrap;

s = RandStream('mlfg6331_64','Seed',1);

options = statset('Streams',s,'UseSubstreams','always','UseParallel','always');

parfor j = 1:size(dataSet,1)
    
    data = (dataSet(j,:))';
    
    [ci{j},bootstat{j}] = bootci(Params.nboot,{fitbs,data,Params},'Options',options,'type','bca');

end