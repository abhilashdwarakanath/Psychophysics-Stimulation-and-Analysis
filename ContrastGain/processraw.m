function data = processraw(response,Params)

%% Generating the psychometric curve for the subject

for i = 1:Params.spkNum
    
    spk(1,i).hits = 0;
    spk(1,i).valTrials = 0;
    %#ok<*AGROW,*SAGROW>
    
end

meanRT = mean(response(:,4));
sdRT = std(response(:,4));
zsRT = round((response(:,4) - meanRT)./sdRT);

for i = 1:size(response,1)
    
    for j = 1:Params.spkNum
        
        if response(i,2) == 0 && response(i,1) == j &&  response(i,3) == 38;
            spk(1,j).hits = spk(1,j).hits+1;
            
        elseif response(i,2) == 1 && response(i,1) == j &&  response(i,3) == 40;
            spk(1,j).hits = spk(1,j).hits+1;
            
        end
        
    end
    
end

for i = 1:size(response,1)
    
    for j = 1:Params.spkNum
        
        if response(i,1) == j && zsRT(i,1) < 5 && zsRT(i,1) > -5;
            spk(1,j).valTrials = spk(1,j).valTrials+1;
        end
    end
end

data = zeros(1,Params.spkNum);

for k = 1:Params.spkNum
    
    data(1,k) = spk(1,k).hits/spk(1,k).valTrials;
    
end

data = data+0.0001;

end