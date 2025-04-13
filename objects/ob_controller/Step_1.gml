/// @description Make sure of everything is going right.
//show_debug_message("keyboard_key: " + string(keyboard_key))
//show_debug_message(chr(keyboard_key))
// Adjust volume value
audio_master_gain(power(global.volumeValue, 2));
/*if (keyboard_check_pressed(ord("W"))) {
	game_set_speed((game_get_speed(gamespeed_fps) != 60) ? 60 : 1, gamespeed_fps);
};//*/
// Fullscreen mode
if (keyboard_check_pressed(vk_f4)) {
	window_set_fullscreen(!window_get_fullscreen());
};

// Exit with ESC
if (keybindCheck("escape")) { escapeKeyTimer++; } else { escapeKeyTimer = max(escapeKeyTimer - 4, 0); };
// Reached max timer
if (escapeKeyTimer >= escapeKeyTimerMax) { game_end(); exit; };

// To puse pushing menu buttons
cMenuBeginStep();

// Active debug mode
if (keyboard_check_pressed(vk_f9) && !game_is_compiled()) {
	// change debug mode state
	global.debugMode = !global.debugMode;
};

// Adjust text surface
if (!surface_exists(global.surfaceMap[? "text"])) {
	// Create a surface for font
	global.surfaceMap[? "text"] = surface_create(1, 1);
};

// Only for debug mode
if (global.debugMode) {
	
	// Game log
	if (keyboard_check(ord("G")) && keyboard_check_pressed(vk_f1)) {
		// Invert log
		debugLog = !debugLog;
		// Active log
		show_debug_log(debugLog);
	};
	// Clear config file
	if (keyboard_check(ord("T")) && keyboard_check_pressed(vk_f1)) {
		// Exists file?
		if (file_exists(configFile())) { file_delete(configFile()); show_debug_message("successfully deleted config file"); };
	};
	// Game full reset
	if (keyboard_check(ord("T")) && keyboard_check_pressed(vk_f2)) {
		// Reset game
		game_restart();
	};
	// Screen size modify
	if (keyboard_check(vk_f3)) {
		// Get the change parameter
		var _change = keyboard_check_pressed(ord("W")) - keyboard_check_pressed(ord("S"));
		if ((_change != 0) && ((global.screenSize + _change) >= 1)) {
			// Set screen size and update
			global.screenSize += _change;
			resizeScreenSize();
		};
	};
};
// Active debug mode
//if ((!game_is_compiled()) && keyboard_check_pressed(vk_f1)) { global.debugMode = !global.debugMode; };

#region Custom gamepad pressed functions

// Search for released gamepad
var gpReleasedKey = ds_map_find_first(global._customGPReleased);
// Now search for pressed keys
repeat (ds_map_size(global._customGPReleased)) {
	
	// Loop for players
	for (var n = 0; n < ds_list_size(global.gamepadConnected); n++) {
		var gpId = global.gamepadConnected[| n];
		
		// It's active? Deactive it
		if (arrayRead(global._customGPReleased[? gpReleasedKey], gpId, false)) { global._customGPReleased[? gpReleasedKey][gpId] = false; };
	};
	
	// Search next key
	gpReleasedKey = ds_map_find_next(global._customGPReleased, gpReleasedKey);
};

// Search in list for it
for (var i = 0; i < ds_list_size(global._customGPPressedList); i++) {
	
	var strId = global._customGPPressedList[| i];
	// Get original key ID and plr ID
	var ocKeyId = string_copy(strId, 1, string_length(strId) - 2);
	var ocGpId = real(string_copy(strId, string_length(strId), 1));
	
	// Check if not active
	if (!directGamepadCheck(ocKeyId, gamepadGetPlayer(ocGpId))) { ds_list_delete(global._customGPPressedList, i); i--; arraySet(global._customGPReleased[? ocKeyId], ocGpId, true, false); };
};

// Search for pressed gamepad
var gpPressedKey = ds_map_find_first(global._customGPPressed);
// Now search for pressed keys
repeat (ds_map_size(global._customGPPressed)) {
	
	// Loop for players
	for (var n = 0; n < ds_list_size(global.gamepadConnected); n++) {
		var gpId = global.gamepadConnected[| n];
		
		// It's active? Deactive it
		if (arrayRead(global._customGPPressed[? gpPressedKey], gpId, false)) { global._customGPPressed[? gpPressedKey][gpId] = false; };
		// Check if active
		if (directGamepadCheck(gpPressedKey, gamepadGetPlayer(gpId)) && ds_list_find_index(global._customGPPressedList, gpPressedKey + "_" + string(gpId)) == -1) {
			// Now it's registered as pressed
			global._customGPPressed[? gpPressedKey][gpId] = true;
			// Add to list
			ds_list_add(global._customGPPressedList, gpPressedKey + "_" + string(gpId));
		};
	};
	
	// Search next key
	gpPressedKey = ds_map_find_next(global._customGPPressed, gpPressedKey);
};

#endregion
//for (var i = 0; i <= 7; i++) { show_debug_message("viewport " + string(i) + ": " + boolToString(view_get_visible(i))); };