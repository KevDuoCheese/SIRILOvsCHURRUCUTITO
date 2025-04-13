/// @description 
if (keyboard_check_pressed(ord("I"))) { room_goto(rm_testroom2); exit; };
switch (cMenuDepthGet()) {
	
	case "main":
		
		// move the options shit
		cMenuOptionLimit(0, 3);
		cMenuOptionMove(cMenuGlobalMoveH(), false);
		
		var _buttonSelected = buttons[cMenuOptionGet("main")];
		// set button as the option selected
		_buttonSelected.buttonActive = true;
		// and srt soul position
		ob_soul.x = _buttonSelected.x + 12;
		ob_soul.y = _buttonSelected.y + 12.5;
        
        // Entering option
        if (keybindCheckPressed("action")) {
            switch (cMenuOptionGet(cMenuDepthGet())) {
                
                case 0:
                    
                    instance_create_depth(0, 0, 0, ob_punch);
                    cMenuDepthAdd("fight_button", 0);
                    // Play sound
                    audio_replay_sound(so_punch_option, 2, false);
                    // Hide heart
                    ob_soul.visible = false;
                break;
            }
        };
	break;
    
    case "fight_button":
        // Doesn't exists anymore
        if (!instance_exists(ob_punch)) {
            // Go back
            cMenuDepthDecrease();
            ob_soul.visible = true;
            break;
        };
    break;
};