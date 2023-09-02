clear;

Paradigm = 3;
Subj = '11'

%cd('C:\Documents and Settings\lab\My Documents\Visual Detection\log');
 %cd('L:\projects\Nini\Visual Detection\log');
 %cd('/home/abhilash/Documents/MATLAB/Contrast Gain/Daten Nini');
 cd('C:\Users\lab\Documents\MATLAB\Abhi\Psychophysics\For Ninni\Contrast Gain\Daten Nini');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
if Paradigm ==1
    d = dir(sprintf('Paradigm1_%s*.mat',Subj));
    response =[];
    for f=1:length(d)
        A = load(d(f).name);
        fprintf('loading %s\n',d(f).name);
        response = cat(2,response,A.ARG.response);
    end
    J = find(response(2,:)==1); % sound
    tmp = response([3,4],J);
    for l=1:8
        J = find(tmp(1,:)==l);
        Ntrials(1,l) = length(J);
        Performance(1,l) = nanmean(tmp(2,J));
    end
    J = find(response(2,:)==2); % NO sound
    tmp = response([3,4],J);
    for l=1:8
        J = find(tmp(1,:)==l);
        Ntrials(2,l) = length(J);
        Performance(2,l) = nanmean(tmp(2,J));
    end

%     figure(1);clf;
%     plot([1:8],Performance(1,:),'ro-');
%     hold on;
%     plot([1:8],Performance(2,:),'bo-');
%     legend({'Sound','NoSound'})
%     title(sprintf('Paradigm 1, Subj: %s',Subj));
%     xlabel('Contrast');
    
elseif Paradigm ==2
    
    d = dir(sprintf('Paradigm2_%s*.mat',Subj));
    response =[];
    for f=1:length(d)
        A = load(d(f).name);
        fprintf('loading %s\n',d(f).name);
        response = cat(2,response,A.ARG.response);
    end
    for s=1:8
        J = find(response(2,:)==s);
        Performance(s) = nanmean(response(4,J));
    end
    figure(1);clf;
    plot([1:8],Performance,'ko-');
    title(sprintf('Paradigm 2, Subj: %s',Subj));
    xlabel('Noise');

elseif Paradigm ==3
    d = dir(sprintf('Paradigm3_%s*.mat',Subj));
    response =[];
    for f=1:length(d)
        A = load(d(f).name);
        fprintf('loading %s\n',d(f).name);
        response = cat(2,response,A.ARG.response);
    end
    
    Scales = [A.ARG.scale_high,A.ARG.scale_low];
    J = find(response(2,:)==Scales(1)); % sound 1
    tmp = response([3,4],J);
    for l=1:8
        J = find(tmp(1,:)==l);
        Ntrials(1,l) = length(J);
        Performance(1,l) = nanmean(tmp(2,J));
    end
    J = find(response(2,:)==Scales(2)); %  sound 2
    tmp = response([3,4],J);
    for l=1:8
        J = find(tmp(1,:)==l);
        Ntrials(2,l) = length(J);
        Performance(2,l) = nanmean(tmp(2,J));
    end

    figure(1);clf;
    plot([1:8],Performance(1,:),'ro-');
    hold on;
    plot([1:8],Performance(2,:),'bo-');
    legend({'Sound high','Sound low'})
    title(sprintf('Paradigm 1, Subj: %s',Subj));
    xlabel('Contrast');
    
end


