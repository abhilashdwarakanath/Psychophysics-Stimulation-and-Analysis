clear;

Paradigm = 3;
%Subj = {'1','Tobi','3','4','5','6','7','8','9','10','11','12','13','14','15','16'};
Subj = {'11'}
figure(2);clf;
cd('C:\Users\lab\Documents\MATLAB\Abhi\Psychophysics\For Ninni\Contrast Gain\Daten Nini');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
if Paradigm ==1
    for s1=1:length(Subj)
        d = dir(sprintf('Paradigm1_%s_*.mat',Subj{s1}));
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
        
        subplot(4,3,s1)
        plot([1:8],Performance(1,:),'ro-');
        hold on;
        plot([1:8],Performance(2,:),'bo-');
        title(sprintf('Par 1, Subj: %s Red:sound',Subj{s1}));
        xlabel('Contrast');
        
    end
    
elseif Paradigm ==2
    
    for s1=1:length(Subj)
        d = dir(sprintf('Paradigm2_%s_*.mat',Subj{s1}));
        response =[];
        for f=1:2% length(d)
            A = load(d(f).name);
            fprintf('loading %s\n',d(f).name);
            response = cat(2,response,A.ARG.response);
        end
        for s=1:8
            J = find(response(2,:)==s);
            Performance(s) = nanmean(response(4,J));
        end
        
        subplot(4,3,s1)
        plot([1:8],Performance,'ko-');
        title(sprintf('Par 2, Subj: %s',Subj{s1}));
        xlabel('Noise');
    end
    
elseif Paradigm ==3
    for s1=1:length(Subj)
        d = dir(sprintf('Paradigm3_%s_*.mat',Subj{s1}));
        response =[];
        for f=1:length(d)
            A = load(d(f).name);
            fprintf('loading %s\n',d(f).name);
            response = cat(2,response,A.ARG.response);
        end
        
        
        if isfield(A.ARG,'scale_high')==0
            Scales = [0,A.ARG.scale];
        else
            Scales = [A.ARG.scale_high,A.ARG.scale_low];
        end
        
        
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
        
        %cd('C:\Users\lab\Documents\MATLAB\Abhi\Psychophysics\For Ninni\Contrast Gain\Processed Data\Paradigm3');
        %filename = [Subj(s1) '.mat'];
        %var = 'Performance';
        %save(filename,var);
        %cd('C:\Users\lab\Documents\MATLAB\Abhi\Psychophysics\For Ninni\Contrast Gain\Daten Nini');
        
        subplot(4,3,s1)
        plot([1:8],Performance(1,:),'ro-');
        hold on;
        plot([1:8],Performance(2,:),'bo-');
        title(sprintf('Par 1, Subj: %s, Red: Sound',Subj{s1}));
        xlabel('Contrast');
        
        
    end
end


