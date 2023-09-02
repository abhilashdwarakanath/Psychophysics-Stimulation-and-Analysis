function [hits,trials] = processdata(ExpParams,resplog,association,conds)

%% Analyse trials

% Hits

hits.sone = zeros(1,length(conds));
hits.stwo = zeros(1,length(conds));
hits.sns = zeros(1,length(conds));

for i = 1:size(resplog,1)
    
    for j = 1:length(conds)
        
        if resplog(i,3) == j && resplog(i,2)==association(1,1) && resplog(i,1)==ExpParams.lKey
            hits.sone(1,j) = hits.sone(1,j)+1;
        end
        
        if resplog(i,3) == j && resplog(i,2)==association(2,1) && resplog(i,1)==ExpParams.lKey
            hits.stwo(1,j) = hits.stwo(1,j)+1;
        end
        
        if resplog(i,3) == j && resplog(i,2)==0 && resplog(i,1)==ExpParams.lKey
            hits.sns(1,j) = hits.sns(1,j)+1;
        end
        
    end
    
end

% Trials

trials.sone = zeros(1,length(conds));
trials.stwo = zeros(1,length(conds));
trials.sns = zeros(1,length(conds));

for i = 1:size(resplog,1)
    
    for j = 1:length(conds)
        
        if resplog(i,3) == j && resplog(i,2)==association(1,1)
            trials.sone(1,j) = trials.sone(1,j)+1;
        end
        
        if resplog(i,3) == j && resplog(i,2)==association(2,1)
            trials.stwo(1,j) = trials.stwo(1,j)+1;
        end
        
        if resplog(i,3) == j && resplog(i,2)==0
            trials.sns(1,j) = trials.sns(1,j)+1;
        end
        
    end
    
end

end
