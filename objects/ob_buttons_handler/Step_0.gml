/// @description 
if (keyboard_check_pressed(ord("I"))) { room_goto(rm_testroom2); exit; };

// approach to the values
if (buttonHide) {
	
	// approach to it
	buttonHideValue += 0.02 + ((buttonHideValue * 0.2));
	// reached
	if (buttonHideValue > 1) { buttonHideValue = 1; };
	
} else {
	
	// approach to it
	buttonHideValue = lerp(buttonHideValue, 0, 0.1);
};

// set each button position
for (var i = 0; i < array_length(buttons); i++) {
	// set the position
	var _buttonIns = buttons[i];
	// adjust it up
	_buttonIns.y = buttonMainY - (buttonHideYDistance * buttonHideValue);
};

// for buttons here
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
				
				case 1:
					// add menu depth
					cMenuDepthAdd("psy_main", 0);
					
					// for getting it
					drawPreset("general");
					// add window
					cMenuWindowAdd("psy_main", 12, 12, cMenuWindowGetWidth(buttonsPSI, true), cMenuWindowGetHeight(array_length(buttonsPSI)), sp_window_ui_button_small, ac_w_open_fade, ac_w_close_fade).selectedOption = 0;
					// set it
					cMenuWindowDrawFunction("psy_main", function () {
						
						// set the preset
						drawPreset("pixel");
						
						// Adjust option position
						var optionX, optionY, defCol = c_white;
						optionX = 12;
						optionY = 9;
						// draw in loop
						for (var i = 0; i < array_length(global.cMenuHandler.buttonsPSI); i++) {
							// Change color depending on option
							if (selectedOption == i) { draw_set_color(c_yellow); }
							else { 
								// draw the color here
								draw_set_color(defCol);
								// draw it
								draw_sprite(sp_psi_icons, i, optionX, optionY + 4);
							};
							
							//var toDrawText = langSet ? languageGet(optionArray[i]) : optionArray[i];
							
							// Draw da text
							draw_text(optionX + 10, optionY, languageGet(global.cMenuHandler.buttonsPSI[i]));
							
							// go to next option bro
							optionY += global.cMenuHandler.optionHeight;
						};
					});
				break;
            }
        };
	break;
    
	case "psy_main":
		
		// move the options shit
		cMenuOptionLimit(0, array_length(buttonsPSI) - 1);
		cMenuOptionMove(cMenuGlobalMoveV(), false);
		// and srt soul position
		ob_soul.x = cMenuWindowX("psy_main") + 12;
		ob_soul.y = cMenuWindowY("psy_main") + 13 + (cMenuOptionGet(cMenuDepthGet()) * optionHeight);
		
		// set up this
		cMenuWindowId("psy_main").selectedOption = cMenuOptionGet(cMenuDepthGet());
		
		// go abck
		if (keybindCheckPressed("back")) {
			// close the window
			cMenuWindowKill("psy_main");
			// reduce depth
			cMenuDepthDecrease();
			break;
		};
	break;
	
    case "fight_button":
        // Doesn't exists anymore
        if ((!instance_exists(ob_punch)) && (!instance_exists(ob_plin_handler))) {
            // Go back
            cMenuDepthDecrease();
			// set pos
			ob_soul.x = -90;
            ob_soul.visible = true;
			// revert hide
			buttonHide = false;
            break;
        };
    break;
	
	case "battle":
		
	break;
};

