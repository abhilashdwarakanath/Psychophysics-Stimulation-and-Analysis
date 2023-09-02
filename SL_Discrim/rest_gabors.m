function gOr_rest = rest_gabors(gOr_target)

if gOr_target == deg2rad(30)
        
        gOr_rest = deg2rad([45 60 -30 -45 -60]);
        
    elseif gOr_target == deg2rad(45)
        
        gOr_rest = deg2rad([30 60 -30 -45 -60]);
        
    elseif gOr_target == deg2rad(60)
        
        gOr_rest = deg2rad([30 45 -30 -45 -60]);
        
    elseif gOr_target == deg2rad(-30)
        
        gOr_rest = deg2rad([30 45 60 -45 -60]);
        
    elseif gOr_target == deg2rad(-45)
        
        gOr_rest = deg2rad([30 45 60 -30 -60]);
        
    elseif gOr_target == deg2rad(-60)
        
        gOr_rest = deg2rad([30 45 60 -30 -45]);
        
end
    
end
