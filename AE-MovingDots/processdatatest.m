function [hits,trials] = processdatatest(ExpParams,resplog,conds)

    
%% Analyse trials

% Hits

hits = zeros(1,length(conds));

for i = 1:size(resplog,1)
    
    for j = 1:length(conds)
        
        if resplog(i,3) == j && resplog(i,1)==ExpParams.lKey
            hits(1,j) = hits(1,j)+1;
        end
        
    end
    
end


% Trials

trials = zeros(1,length(conds));

for i = 1:size(resplog,1)
    
    for j = 1:length(conds)
        
        if resplog(i,3) == j 
            trials(1,j) = trials(1,j)+1;
        end
        
    end
    
end

end
