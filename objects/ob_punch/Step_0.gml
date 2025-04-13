/// @description 


    
switch (phase) {
    
    case 0:
        
        // Approach value to 1
        animValue = lerp(animValue, 1, 0.2);
        // If it's near enough set it
        if (roundDecimal(animValue, 2) >= 1)
            { animValue = 1; phase = 1; break; };
        
    break;
    
    case 1:
        
        // Set this up
        indexAlpha = approachValue(indexAlpha, 1, indexAlphaShift);
        // Needs to reach 2 to pass next one
        indexPos += indexShift;
        
        // Presses Z
        if (keybindCheckPressed("action")) {
            
            // Set up
            phase = 3;
            indexActive = true;
            indexAlpha = 1;
            break;
        };
        // Max position
        if (indexPos >= 2) {
            // Directly to death
            phase = 2;
            break;
        };
        
    break;
    
    case 3:
        
        // Timer up
        if (destroyTimer > 0) { destroyTimer--; } else {
            
            phase = 2;
            break;
        };
        
    break;
    
    case 2:
        
        // Hide it
        indexAlpha = approachValue(indexAlpha, 0, indexAlphaShift);
        // Approach value to 1
        animValue = approachValue(animValue, 0, max(0, animValue * 0.25 + 0.01)); 
        // If it's near enough set it
        if (roundDecimal(animValue, 2) <= 0)
            { animValue = 0; instance_destroy(); exit; };
    
    break;
};