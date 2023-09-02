function [hits,trls,vec,ist,soll] = processdata2(dirName,ExpParams,responses,trial_types,trial_order,freq_order,jnd)

responses = responses(:);
trial_order = trial_order(:);
freq_order = freq_order(:);
trial_types = trial_types(:);

cd(dirName);
load association.mat

%% %% MoA scatter

ax = ([jnd*-7.5 jnd*-5 jnd*-2.5 0 jnd*2.5 jnd*5 jnd*7.5]);
soll.sound = zeros(7,1);
ist.sound = zeros(7,1);

freq_order(freq_order==association(1,1)) = 3;
freq_order(freq_order==association(2,1)) = 2;
freq_order(freq_order>3) = 1;

for i = 1:length(responses)
    for j = 1:7
        if freq_order(i) == 3 && trial_order(i) == j && trial_types(i) == 1
            soll.sound(j) = soll.sound(j)+ax(j);
            ist.sound(j) = ist.sound(j)+(responses(i)-association(1,2));
        elseif freq_order(i) == 2 && trial_order(i) == j && trial_types(i) == 1
            soll.sound(j) = soll.sound(j)+ax(j);
            ist.sound(j) = ist.sound(j)+(responses(i)-association(2,2));
        end
    end
end

for i = 1:7
    
    soll.sound(i) = soll.sound(i)/40;
    ist.sound(i) = ist.sound(i)/40;
    
end
%% AFC

hits.sound =zeros(1,7);
hits.wsound =zeros(1,7);

for i = 1:length(responses)
    
    for j = 1:7
        
        if trial_order(i) == j && freq_order(i)>=2 && trial_types(i) == 0 && responses(i)==ExpParams.rKey
            hits.sound(1,j) = hits.sound(1,j)+1;
            
        elseif trial_order(i) == j && freq_order(i)==1 && trial_types(i) == 0 && responses(i)==ExpParams.rKey
            hits.wsound(1,j) = hits.wsound(1,j)+1;
            
        end
        
    end
    
end

%Trials

trls.sound =zeros(1,7);
trls.wsound =zeros(1,7);

for i = 1:length(responses)
    
    for j = 1:7
        
        if trial_order(i) == j && trial_types(i) == 0 && freq_order(i)>=2
            trls.sound(1,j) = trls.sound(1,j)+1;
            
        elseif trial_order(i) == j && trial_types(i) == 0 && freq_order(i)==1
            trls.wsound(1,j) = trls.wsound(1,j)+1;
            
        end
        
    end
    
end

%% Smooth responses

vec.sound = [];
vec.wsound = [];



for i = 1:length(responses)
    
    for j = 1:7
        
        if trial_order(i) == j && freq_order(i)>=2 && trial_types(i) == 1
            vec.sound = [vec.sound responses(i)];
            
        elseif trial_order(i) == j && freq_order(i)==1 && trial_types(i) == 1
            vec.wsound = [vec.wsound responses(i)];
            
        end
        
    end
    
end
