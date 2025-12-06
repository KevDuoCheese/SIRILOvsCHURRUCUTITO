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
			// calculate plin power
			plinPower = 1 - abs(indexPos - 1);
			// create the plin
			var _plinHandler = instance_create_depth(0, 0, 0, ob_plin_handler);
			_plinHandler.plinPower = plinPower;
			// adjust it
			destroyTimer = timerGet(0.75 + (plinPower * 0.75));
			// hide buttons
			ob_buttons_handler.buttonHide = true;
			// play the sound
			chargingSound = audio_replay_sound(so_punch_charge, 10, false, 0.7);
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
            { animValue = 0; audio_stop_sound(chargingSound); instance_destroy(); exit; };
    
    break;
};