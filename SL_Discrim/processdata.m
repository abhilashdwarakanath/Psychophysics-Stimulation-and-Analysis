function [hits,trls,vec,ist,soll,ind_ist,ind_soll] = processdata(dirName,ExpParams,responses,trial_order,freq_order,jnd)

cd(dirName);
load association.mat

responses_afc = [responses(2,:)];% responses(4,:)];
trial_order_afc = [trial_order(2,:)];% trial_order(4,:)];
freq_order_afc = [freq_order(2,:)];% freq_order(4,:)];

responses_moa = [responses(1,:)];% responses(3,:)];
trial_order_moa = [trial_order(1,:)];% trial_order(3,:)];
freq_order_moa = [freq_order(1,:)];% freq_order(3,:)];

freq_order_afc(freq_order_afc==association(1,1)) = 2;
freq_order_afc(freq_order_afc==association(2,1)) = 2;
freq_order_afc(freq_order_afc>2) = 1;

freq_order_moa(freq_order_moa==association(1,1)) = 3;
freq_order_moa(freq_order_moa==association(2,1)) = 2;
freq_order_moa(freq_order_moa>3) = 1;

%% %% MoA scatter

ax = ([jnd*-7.5 jnd*-5 jnd*-2.5 0 jnd*2.5 jnd*5 jnd*7.5]);
soll.sound = zeros(7,1);
ist.sound = zeros(7,1);
itrls.sound = zeros(1,7);
    

for i = 1:length(responses_moa)
    for j = 1:7
        if freq_order_moa(i) == 3 && trial_order_moa(i) == j
            soll.sound(j) = soll.sound(j)+ax(j);
            r = ((responses_moa(i)-association(1,2)));
            if r >= 20 || r <= -20
                r = 0;
                t = 0;
            else
                r = r;
                t = 1;
            end
            ist.sound(j) = ist.sound(j)+r;
            itrls.sound(j) = itrls.sound(j)+t;
        elseif freq_order_moa(i) == 2 && trial_order_moa(i) == j
            soll.sound(j) = soll.sound(j)+ax(j);
            r = ((responses_moa(i)-association(2,2)));
            if r >= 20 || r <= -20
                r = 0;
                t = 0;
            else
                r = r;
                t = 1;
            end
            ist.sound(j) = ist.sound(j)+r;
            itrls.sound(j) = itrls.sound(j)+t;
        end
    end
end

for i = 1:7
    
    soll.sound(i) = soll.sound(i)/itrls.sound(i);
    ist.sound(i) = ist.sound(i)/itrls.sound(i);
    
end

for i = 1:7
ind_ist.(['sound' num2str(i)]) = [];
ind_soll.(['sound' num2str(i)]) = [];
end

for i = 1:length(responses_moa)
    for j = 1:7
            if freq_order_moa(i) == 3 && trial_order_moa(i) == j
                ind_soll.(['sound' num2str(j)]) = [ind_soll.(['sound' num2str(j)]) ax(j)];
                ind_ist.(['sound' num2str(j)]) = [ind_ist.(['sound' num2str(j)]) ((responses_moa(i)-association(1,2)))];
            elseif freq_order_moa(i) == 2 && trial_order_moa(i) == j
                ind_soll.(['sound' num2str(j)]) = [ind_soll.(['sound' num2str(j)]) ax(j)];
                ind_ist.(['sound' num2str(j)]) = [ind_ist.(['sound' num2str(j)]) ((responses_moa(i)-association(2,2)))];
            end
    end
end

for i = 1:7
    ind_ist.err(i) = std(ind_ist.(['sound' num2str(i)]))/sqrt(30);
end

% soll.nsound = zeros(7,1);
% ist.nsound = zeros(7,1);
% itrls.nsound = zeros(1,7);
% 
% for i = 1:length(responses_moa)
%     for j = 1:7
%         if freq_order_moa(i) == 0 && trial_order_moa(i) == j
%             soll.nsound(j) = soll.nsound(j)+ax(j);
%             ist.nsound(j) = ist.nsound(j)+(responses_moa(i)-association(1,2));
%             itrls.nsound(j) = itrls.nsound(j)+1;
%         end
%     end
% end
% 
% for i = 1:7
%     
%     soll.nsound(i) = soll.nsound(i)/itrls.nsound(i);
%     ist.nsound(i) = ist.nsound(i)/itrls.nsound(i);
%     
% end
% 
% soll.wsound = zeros(7,1);
% ist.wsound = zeros(7,1);
% itrls.wsound = zeros(1,7);
% 
% for i = 1:length(responses_moa)
%     for j = 1:7
%         if freq_order_moa(i) > 3 && trial_order_moa(i) == j
%             soll.wsound(j) = soll.wsound(j)+ax(j);
%             ist.wsound(j) = ist.wsound(j)+(responses_moa(i)-association(1,2));
%             itrls.wsound(j) = itrls.wsound(j)+1;
%         end
%     end
% end
% 
% for i = 1:7
%     
%     soll.wsound(i) = soll.wsound(i)/itrls.nsound(i);
%     ist.wsound(i) = ist.wsound(i)/itrls.nsound(i);
%     
% end
%% AFC

hits.sound =zeros(1,7);
hits.wsound =zeros(1,7);
hits.nosound =zeros(1,7);

for i = 1:length(responses_afc)
    
    for j = 1:7
        
        if trial_order_afc(i) == j && freq_order_afc(i)==2 && responses_afc(i)==ExpParams.rKey
            hits.sound(1,j) = hits.sound(1,j)+1;
            
        elseif trial_order_afc(i) == j && freq_order_afc(i)==1 && responses_afc(i)==ExpParams.rKey
            hits.wsound(1,j) = hits.wsound(1,j)+1;
            
        elseif trial_order_afc(i) == j && freq_order_afc(i)==0 && responses_afc(i)==ExpParams.rKey
            hits.nosound(1,j) = hits.nosound(1,j)+1;
            
        end
        
    end
    
end

%Trials

trls.sound =zeros(1,7);
trls.wsound =zeros(1,7);
trls.nosound =zeros(1,7);

for i = 1:length(responses_afc)
    
    for j = 1:7
        
        if trial_order_afc(i) == j && freq_order_afc(i)==2
            trls.sound(1,j) = trls.sound(1,j)+1;
            
        elseif trial_order_afc(i) == j && freq_order_afc(i)==1
            trls.wsound(1,j) = trls.wsound(1,j)+1;
            
        elseif trial_order_afc(i) == j && freq_order_afc(i)==0
            trls.nosound(1,j) = trls.nosound(1,j)+1;
            
        end
        
    end
    
end

%% Smooth responses

vec.sound = [];
vec.wsound = [];
vec.nosound = [];

for i = 1:length(responses_moa)
    
    for j = 1:7
        
        if trial_order_moa(i) == j && freq_order_moa(i)>=2
            vec.sound = [vec.sound responses_moa(i)];
            
        elseif trial_order_moa(i) == j && freq_order_moa(i)==1
            vec.wsound = [vec.wsound responses_moa(i)];
            
        elseif trial_order_moa(i) == j && freq_order_moa(i)==0
            vec.nosound = [vec.nosound responses_moa(i)];
            
        end
        
    end
    
end
