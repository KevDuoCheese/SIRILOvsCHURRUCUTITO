
#region Keymap names

// Get keybind names
global.keyMapName = ds_map_create();
// temporal function
/*var addKeyMap = function (keyId, nameOf, type) {
	// Add value
	ds_map_add(global.keyMapName, keyId, [  ]);
};//*/
// Gamepad last key


// Add basic keys
ds_map_add(global.keyMapName, -1,			 "none");
// Add basic keys
ds_map_add(global.keyMapName, vk_escape,	 "ESCAPE");
ds_map_add(global.keyMapName, vk_space,		 "SPACE");
ds_map_add(global.keyMapName, vk_enter,		 "ENTER");
ds_map_add(global.keyMapName, vk_backspace,	 "BACKSPACE");
ds_map_add(global.keyMapName, vk_tab,		 "TAB");
// Shift keys
ds_map_add(global.keyMapName, vk_lshift,	 "Left Shift");
ds_map_add(global.keyMapName, vk_rshift,	 "Right Shift");
ds_map_add(global.keyMapName, vk_shift,		 "Shift");
// Control keys
ds_map_add(global.keyMapName, vk_lcontrol,	 "Left Control");
ds_map_add(global.keyMapName, vk_rcontrol,	 "Right Control");
ds_map_add(global.keyMapName, vk_control,	 "Control");
// ALT keys
ds_map_add(global.keyMapName, vk_lalt,		 "Left ALT");
ds_map_add(global.keyMapName, vk_ralt,		 "Right ALT");
ds_map_add(global.keyMapName, vk_alt,		 "ALT");
// Add direction kesy
ds_map_add(global.keyMapName, vk_right,		 "Right");
ds_map_add(global.keyMapName, vk_left,		 "Left");
ds_map_add(global.keyMapName, vk_down,		 "Down");
ds_map_add(global.keyMapName, vk_up,		 "Up");

// Gamepad directions
ds_map_add(global.keyMapName, "axisl_horizontal",	 "L-Stick H");
ds_map_add(global.keyMapName, "axisl_vertical",		 "L-Stick V");
ds_map_add(global.keyMapName, "axisr_horizontal",	 "R-Stick H");
ds_map_add(global.keyMapName, "axisr_vertical",		 "R-Stick V");
// Left stick directions
ds_map_add(global.keyMapName, "axisl_right", "L-Stick Right");
ds_map_add(global.keyMapName, "axisl_left",	 "L-Stick Left");
ds_map_add(global.keyMapName, "axisl_down",	 "L-Stick Down");
ds_map_add(global.keyMapName, "axisl_up",	 "L-Stick Up");
// Right stick directions
ds_map_add(global.keyMapName, "axisr_right", "R-Stick Right");
ds_map_add(global.keyMapName, "axisr_left",	 "R-Stick Left");
ds_map_add(global.keyMapName, "axisr_down",	 "R-Stick Down");
ds_map_add(global.keyMapName, "axisr_up",	 "R-Stick Up");
// Add direction buttons
ds_map_add(global.keyMapName, gp_padr,		 "Pad Right");
ds_map_add(global.keyMapName, gp_padl,		 "Pad Left");
ds_map_add(global.keyMapName, gp_padd,		 "Pad Down");
ds_map_add(global.keyMapName, gp_padu,		 "Pad Up");
// Add colors buttons
ds_map_add(global.keyMapName, gp_face1,		 "A");
ds_map_add(global.keyMapName, gp_face2,		 "B");
ds_map_add(global.keyMapName, gp_face3,		 "X");
ds_map_add(global.keyMapName, gp_face4,		 "Y");
// Add shoulders buttons
ds_map_add(global.keyMapName, gp_shoulderl,	 "L1");
ds_map_add(global.keyMapName, gp_shoulderlb, "L2");
ds_map_add(global.keyMapName, gp_shoulderr,	 "R1");
ds_map_add(global.keyMapName, gp_shoulderrb, "R2");
// Pressed sticks
ds_map_add(global.keyMapName, gp_stickl,	 "L3");
ds_map_add(global.keyMapName, gp_stickr,	 "R3");
// Start & select
ds_map_add(global.keyMapName, gp_start,		 "Start");
ds_map_add(global.keyMapName, gp_select,	 "Select");
// Add the Ñ
ds_map_add(global.keyMapName, ord("Ñ"),		 "Ñ");
ds_map_add(global.keyMapName, ord("À"),		 "À");
// Add common characters
for (var i = ord("A"); i <= ord("Z"); i++) { ds_map_add(global.keyMapName, i, chr(i)); };
// Numbers
for (var i = ord("0"); i <= ord("9"); i++) { ds_map_add(global.keyMapName, i, chr(i)); };

#endregion
/* */
#region Gamepad sync

/// @description Clear gamepad ID for each player
function gamepadClear() {

// Clear map
ds_list_delete_all(global.gamepadConnected);
// Get every gamepad ID from players array
for (var i = 0; i < array_length(global.keybindArray); i++) {
	
	// Get gamepad ID and clear it
	global.keybindArray[i].gamepad_id = -1;
};

};

/// @description Sync gamepad to player
function gamepadConnect(gpId, plrId) {

// Set gamepad ID
global.keybindArray[plrId].gamepad_id = gpId;
// Add to gamepad list
ds_list_add(global.gamepadConnected, gpId);
// Adjust the gamepad deadzone
gamepad_set_axis_deadzone(gpId, global.keybindArray[plrId].gamepad_deadzone);
// Show debug message to inform new gamepad entrering
show_debug_message("Set gamepad " + string(gpId) + " for player " + string(plrId + 1));

};

/// @description Search for gamepad candidates for players
function gamepadUpdate() {

var gamepadCount = gamepad_get_device_count();
// This holds each gamepad ID
var gamepadCountArray = [ ];
for (var i = 0; i < gamepadCount; i++) { array_push(gamepadCountArray, i); };
// This holds each player ID
var playerCountArray = [ ];
for (var i = 0; i < min(array_length(global.keybindArray), global.playersNumber); i++) { array_push(playerCountArray, i); };
// Counting from
var gamepadSetting = 0;
//global.gamepadID = -1;
gamepadClear();

var totalPlrsFind = array_length(playerCountArray);
// Search for forced gamepad set for players
for (var i = 0; i < totalPlrsFind; i++) {
	
	// Get forced gamepad ID
	var forcedGamepadID = global.keybindArray[i].gamepad_id_forced;
	// If gamepad is conenected
	if ((forcedGamepadID != -1) && gamepad_is_connected(forcedGamepadID)) {
		
		// Show debug message to inform new gamepad entrering
		show_debug_message("Forced gamepad: " + string(forcedGamepadID));
		// And connect it to player
		gamepadConnect(forcedGamepadID, i);
		// Delete gamepad and player from array
		var searchedPlr = arrayFind(playerCountArray, i), searchedGamepad = arrayFind(gamepadCountArray, forcedGamepadID);
		// delete registered player from it
		array_delete(playerCountArray, searchedPlr, 1);
		// and game pad too
		if (searchedGamepad != -1) { array_delete(gamepadCountArray, searchedGamepad, 1); };
	};
};
// Player 0 is in there
if (arrayFind(playerCountArray, 0) != -1 && array_length(playerCountArray) > 1) { gamepadSetting = 1; };
// Get all in positions
for (var i = 0; i < array_length(gamepadCountArray); i++) {
	
	// If gamepad is conenected
	if (gamepad_is_connected(gamepadCountArray[i])) {
		
		// Show debug message to inform new gamepad entrering
		show_debug_message("Found new gamepad: " + string(gamepadCountArray[i]));
		// And connect it to player
		gamepadConnect(gamepadCountArray[i], playerCountArray[gamepadSetting]);
		// Break loop
		if (gamepadSetting >= array_length(playerCountArray)) { break; } else { gamepadSetting++; };
	};
};

return global.keybindArray;

};

/// @description Get pressed gamepad key
/// @param axisDirect If true, it will check for direcions directly (right, down), else, will search for horizontal and vertical (-1, 1)
function gamepadKey(axisDirect, plrId = 0) {

// Slot of gamepad
var gpSlot = global.keybindArray[plrId].gamepad_id;
// No key pressed till now
var pressKey = 0;

// Any faces pressed?
	 if (gamepad_button_check(gpSlot, gp_face1)) { pressKey = gp_face1; }
else if (gamepad_button_check(gpSlot, gp_face2)) { pressKey = gp_face2; }
else if (gamepad_button_check(gpSlot, gp_face3)) { pressKey = gp_face3; }
else if (gamepad_button_check(gpSlot, gp_face4)) { pressKey = gp_face4; }
// Any shoulders?
else if (gamepad_button_check(gpSlot, gp_shoulderl))	 { pressKey = gp_shoulderl; }
else if (gamepad_button_check(gpSlot, gp_shoulderlb))	 { pressKey = gp_shoulderlb; }
else if (gamepad_button_check(gpSlot, gp_shoulderr))	 { pressKey = gp_shoulderr; }
else if (gamepad_button_check(gpSlot, gp_shoulderrb))	 { pressKey = gp_shoulderrb; }
// Any pad buttons
else if (gamepad_button_check(gpSlot, gp_padr))	 { pressKey = gp_padr; }
else if (gamepad_button_check(gpSlot, gp_padl))	 { pressKey = gp_padl; }
else if (gamepad_button_check(gpSlot, gp_padd))	 { pressKey = gp_padd; }
else if (gamepad_button_check(gpSlot, gp_padu))	 { pressKey = gp_padu; }
// Select or start
else if (gamepad_button_check(gpSlot, gp_select))	 { pressKey = gp_select; }
else if (gamepad_button_check(gpSlot, gp_start))	 { pressKey = gp_start; }
// Sticks
else if (axisDirect) {
	
	// Direct keys
		 if (gamepad_axis_value(gpSlot, gp_axislh) > 0) { pressKey = "axisl_right"; }
	else if (gamepad_axis_value(gpSlot, gp_axislh) < 0) { pressKey = "axisl_left"; }
	else if (gamepad_axis_value(gpSlot, gp_axislv) > 0) { pressKey = "axisl_down"; }
	else if (gamepad_axis_value(gpSlot, gp_axislv) < 0) { pressKey = "axisl_up"; }
	// Now for right stick
	else if (gamepad_axis_value(gpSlot, gp_axisrh) > 0) { pressKey = "axisr_right"; }
	else if (gamepad_axis_value(gpSlot, gp_axisrh) < 0) { pressKey = "axisr_left"; }
	else if (gamepad_axis_value(gpSlot, gp_axisrv) > 0) { pressKey = "axisr_down"; }
	else if (gamepad_axis_value(gpSlot, gp_axisrv) < 0) { pressKey = "axisr_up"; }
} else {
	// Serach for sticks value
		 if (gamepad_axis_value(gpSlot, gp_axislh) != 0) { pressKey = "axisl_horizontal"; }
	else if (gamepad_axis_value(gpSlot, gp_axislv) != 0) { pressKey = "axisl_vertical"; }
	else if (gamepad_axis_value(gpSlot, gp_axisrh) != 0) { pressKey = "axisr_horizontal"; }
	else if (gamepad_axis_value(gpSlot, gp_axisrv) != 0) { pressKey = "axisr_vertical"; };
};

return pressKey;

};

/// @description Get player who is using this gamepad
function gamepadGetPlayer(gpId) {

// Search for it my man
for (var i = 0; i < array_length(global.keybindArray); i++) {
	// It's player gamepad
	if (global.keybindArray[i].gamepad_id == gpId) { return i; };
};

return -1;

};

#endregion
/* */
#region Custom pressed

// Create a map for it
global._customGPPressed = ds_map_create();
// List for GP pressed
global._customGPPressedList = ds_list_create();
// Same with release keys
global._customGPReleased = ds_map_create();

// Left stick directions
ds_map_add(global._customGPPressed, "axisl_right",	 [ ]);
ds_map_add(global._customGPPressed, "axisl_left",	 [ ]);
ds_map_add(global._customGPPressed, "axisl_down",	 [ ]);
ds_map_add(global._customGPPressed, "axisl_up",		 [ ]);
// Right stick directions
ds_map_add(global._customGPPressed, "axisr_right",	 [ ]);
ds_map_add(global._customGPPressed, "axisr_left",	 [ ]);
ds_map_add(global._customGPPressed, "axisr_down",	 [ ]);
ds_map_add(global._customGPPressed, "axisr_up",		 [ ]);



// Left stick directions
ds_map_add(global._customGPReleased, "axisl_right",	 [ ]);
ds_map_add(global._customGPReleased, "axisl_left",	 [ ]);
ds_map_add(global._customGPReleased, "axisl_down",	 [ ]);
ds_map_add(global._customGPReleased, "axisl_up",	 [ ]);
// Right stick directions
ds_map_add(global._customGPReleased, "axisr_right",	 [ ]);
ds_map_add(global._customGPReleased, "axisr_left",	 [ ]);
ds_map_add(global._customGPReleased, "axisr_down",	 [ ]);
ds_map_add(global._customGPReleased, "axisr_up",	 [ ]);

/// @description Get if gamepad key was pressed
function customGamepadPressed(gpId, plrId) {

// Slot of gamepad
var gpSlot = global.keybindArray[plrId].gamepad_id;
if (gpSlot < 0) { return false; };
// Find it in map
return arrayRead(global._customGPPressed[? gpId], gpSlot, false);

};

/// @description Get if gamepad key was released
function customGamepadReleased(gpId, plrId) {

// Slot of gamepad
var gpSlot = global.keybindArray[plrId].gamepad_id;
if (gpSlot < 0) { return false; };
// Find it in map
return arrayRead(global._customGPReleased[? gpId], gpSlot, false);

};

#endregion
/* */
#region Keybind

// Adjust last type of keybind pressed
global.keybindLastType = "keyboard";

/// @description Search for pressed key, if not return 0
function keybindKey() {

// Get normal keybind
var _keyReturn = keyboard_key;
// Check Ñ key
//if (keyboard_check(ord("Ñ"))) { _keyReturn = ord("Ñ"); };

return _keyReturn;

};

/// @description Search for a specified key name
function keybindGetName(keyId) {
// Search the key in value
var n = ds_map_find_value(global.keyMapName, keyId);
// It was one of the vk_ keys in that map
if (!is_undefined(n)) { return n; };
// There wasn't key pressed
if (keyId <= 0) { return undefined; };

// Get last key in keyboard string
keyId = string_copy(keyboard_string, string_length(keyboard_string), 1);
// Search types
switch (keyId) {
	
    case ";":  return ";";  break;
    case "=":  return "=";  break;
    case ",":  return ",";  break;
    case "-":  return "-";  break;
    case ".":  return ".";  break;
    case "/":  return "/";  break;
    case "`":  return "~";  break;
    case "[":  return "[";  break;
    case "\\": return "\\"; break;
    case "]":  return "]";  break;
    case "'":  return "'";  break;
};

return undefined;

};

/// @description Direct keys for gamepad
function directGamepadCheck(keyId, plrId) {

// Slot of gamepad
var gpSlot = global.keybindArray[plrId].gamepad_id;

// Key id
switch (keyId) {
	// Searching for left stick constants
	case "axisl_horizontal":	 return gamepad_axis_value(gpSlot, gp_axislh); break;
	case "axisl_vertical":		 return gamepad_axis_value(gpSlot, gp_axislv); break;
	// Right axis constants
	case "axisr_horizontal":	 return gamepad_axis_value(gpSlot, gp_axisrh); break;
	case "axisr_vertical":		 return gamepad_axis_value(gpSlot, gp_axisrv); break;
	
	// Direct check
	case "axisl_right":		 return gamepad_axis_value(gpSlot, gp_axislh) > 0; break;
	case "axisl_left":		 return gamepad_axis_value(gpSlot, gp_axislh) < 0; break;
	case "axisl_down":		 return gamepad_axis_value(gpSlot, gp_axislv) > 0; break;
	case "axisl_up":		 return gamepad_axis_value(gpSlot, gp_axislv) < 0; break;
	// Direct check on right stick
	case "axisr_right":		 return gamepad_axis_value(gpSlot, gp_axisrh) > 0; break;
	case "axisr_left":		 return gamepad_axis_value(gpSlot, gp_axisrh) < 0; break;
	case "axisr_down":		 return gamepad_axis_value(gpSlot, gp_axisrv) > 0; break;
	case "axisr_up":		 return gamepad_axis_value(gpSlot, gp_axisrv) < 0; break;
};

return -1;

};

/// @description Check if key is active
function keybindTypeCheck(typeId, keyId, plrId = 0) {
// What kind of input are we searching for?
switch (typeId) {
	
	case "gamepad":
		// Slot of gamepad
		var gpSlot = global.keybindArray[plrId].gamepad_id;
		
		// Key id
		switch (keyId) {
			// Searching for left stick constants
			case "axisl_horizontal":	 return gamepad_axis_value(gpSlot, gp_axislh); break;
			case "axisl_vertical":		 return gamepad_axis_value(gpSlot, gp_axislv); break;
			// Right axis constants
			case "axisr_horizontal":	 return gamepad_axis_value(gpSlot, gp_axisrh); break;
			case "axisr_vertical":		 return gamepad_axis_value(gpSlot, gp_axisrv); break;
			
			// Direct check
			case "axisl_right":		 return gamepad_axis_value(gpSlot, gp_axislh) > 0; break;
			case "axisl_left":		 return gamepad_axis_value(gpSlot, gp_axislh) < 0; break;
			case "axisl_down":		 return gamepad_axis_value(gpSlot, gp_axislv) > 0; break;
			case "axisl_up":		 return gamepad_axis_value(gpSlot, gp_axislv) < 0; break;
			// Direct check on right stick
			case "axisr_right":		 return gamepad_axis_value(gpSlot, gp_axisrh) > 0; break;
			case "axisr_left":		 return gamepad_axis_value(gpSlot, gp_axisrh) < 0; break;
			case "axisr_down":		 return gamepad_axis_value(gpSlot, gp_axisrv) > 0; break;
			case "axisr_up":		 return gamepad_axis_value(gpSlot, gp_axisrv) < 0; break;
			// No key for this
			case -1: return false; break;
			// Just check for an button
			default: return gamepad_button_check(gpSlot, keyId); break;
		};
	break;
	
	default:
		
		// Switch key Id
		switch (keyId) {
			// Left and right mouse buttons
			case "mouse_lb": return mouse_check_button(mb_left); break;
			case "mouse_rb": return mouse_check_button(mb_right); break;
			// Middle button (Why you would use that?)
			case "mouse_mb": return mouse_check_button(mb_middle); break;
			// Direct set keys
			case vk_lcontrol:	 case vk_rcontrol:
			case vk_lshift:		 case vk_rshift:
			case vk_lalt:		 case vk_ralt: return keyboard_check_direct(keyId); break;
			// No key assigned
			case -1: return false; break;
			// Check for normal keybind
			default: return keyboard_check(keyId); break;
		};
		
	break;
};
// Was a failure
return -1;

};

/// @description Check if key was pressed
function keybindTypeCheckPressed(typeId, keyId, plrId = 0) {
// What kind of input are we searching for?
switch (typeId) {
	
	case "gamepad":
		// Slot of gamepad
		var gpSlot = global.keybindArray[plrId].gamepad_id;
		
		// Key id
		switch (keyId) {
			// Searching for left stick constants
			case "axisl_horizontal":	 return gamepad_axis_value(gpSlot, gp_axislh); break;
			case "axisl_vertical":		 return gamepad_axis_value(gpSlot, gp_axislv); break;
			// Right axis constants
			case "axisr_horizontal":	 return gamepad_axis_value(gpSlot, gp_axisrh); break;
			case "axisr_vertical":		 return gamepad_axis_value(gpSlot, gp_axisrv); break;
			
			// Direct check
			case "axisl_right":		 return customGamepadPressed(keyId, plrId); break;
			case "axisl_left":		 return customGamepadPressed(keyId, plrId); break;
			case "axisl_down":		 return customGamepadPressed(keyId, plrId); break;
			case "axisl_up":		 return customGamepadPressed(keyId, plrId); break;
			// Direct check on right stick
			case "axisr_right":		 return customGamepadPressed(keyId, plrId); break;
			case "axisr_left":		 return customGamepadPressed(keyId, plrId); break;
			case "axisr_down":		 return customGamepadPressed(keyId, plrId); break;
			case "axisr_up":		 return customGamepadPressed(keyId, plrId); break;
			// No key for this
			case -1: return false; break;
			// Just check for an button
			default: return gamepad_button_check_pressed(gpSlot, keyId); break;
		};
	break;
	
	default:
		
		// Switch key Id
		switch (keyId) {
			// Left and right mouse buttons
			case "mouse_lb": return mouse_check_button_pressed(mb_left); break;
			case "mouse_rb": return mouse_check_button_pressed(mb_right); break;
			// Middle button (Why you would use that?)
			case "mouse_mb": return mouse_check_button_pressed(mb_middle); break;
			// No key assigned
			case -1: return false; break;
			// Check for normal keybind
			default: return keyboard_check_pressed(keyId); break;
		};
		
	break;
};
// Was a failure
return -1;

};

/// @description Check if key was released
function keybindTypeCheckReleased(typeId, keyId, plrId = 0) {
// What kind of input are we searching for?
switch (typeId) {
	
	case "gamepad":
		// Slot of gamepad
		var gpSlot = global.keybindArray[plrId].gamepad_id;
		
		// Key id
		switch (keyId) {
			// Searching for left stick constants
			case "axisl_horizontal":	 return gamepad_axis_value(gpSlot, gp_axislh); break;
			case "axisl_vertical":		 return gamepad_axis_value(gpSlot, gp_axislv); break;
			// Right axis constants
			case "axisr_horizontal":	 return gamepad_axis_value(gpSlot, gp_axisrh); break;
			case "axisr_vertical":		 return gamepad_axis_value(gpSlot, gp_axisrv); break;
			
			// Direct check
			case "axisl_right":		 return customGamepadReleased(keyId, plrId); break;
			case "axisl_left":		 return customGamepadReleased(keyId, plrId); break;
			case "axisl_down":		 return customGamepadReleased(keyId, plrId); break;
			case "axisl_up":		 return customGamepadReleased(keyId, plrId); break;
			// Direct check on right stick
			case "axisr_right":		 return customGamepadReleased(keyId, plrId); break;
			case "axisr_left":		 return customGamepadReleased(keyId, plrId); break;
			case "axisr_down":		 return customGamepadReleased(keyId, plrId); break;
			case "axisr_up":		 return customGamepadReleased(keyId, plrId); break;
			// No key for this
			case -1: return false; break;
			// Just check for an button
			default: return gamepad_button_check_released(gpSlot, keyId); break;
		};
	break;
	
	default:
		
		// Switch key Id
		switch (keyId) {
			// Left and right mouse buttons
			case "mouse_lb": return mouse_check_button_released(mb_left); break;
			case "mouse_rb": return mouse_check_button_released(mb_right); break;
			// Middle button (Why you would use that?)
			case "mouse_mb": return mouse_check_button_released(mb_middle); break;
			// No key assigned
			case -1: return false; break;
			// Check for normal keybind
			default: return keyboard_check_released(keyId); break;
		};
		
	break;
};
// Was a failure
return -1;

};

/// @description Get keybind full variable access
function keybindGetVariable(plrId, keyId, def = []) {

// return obtained data
return structRead(global.keybindArray[plrId], keyId, def);

};

/// @description Given an set of variables, first of them whom it's different from compare num
/// @param compare_num
/// @param [num0]
/// @param [num1]
/// @param [num2]
function differentOf(compare_num){

// All numbers
for (var i = 1; i < argument_count; i++) {
	// If number it's different 
	if (argument[i] != compare_num) {
		// return that number
		return argument[i];
	};
};

return compare_num;

};

/// @description Given an set of variables, first of them whom it's different from compare num, and returns the ID of variable
/// @param compare_num
/// @param [num0]
/// @param [num1]
/// @param [num2]
function differentOfEXT(compare_num){

// All numbers
for (var i = 1; i < argument_count; i++) {
	// If number it's different 
	if (argument[i] != compare_num) {
		// return that number
		return [ argument[i], i ];
	};
};

return [ compare_num, -1 ];

};

/// @description Set last type based or number (n) returned by differentOfEXT; n = -1, nothing, 0 <= n <= 1, keyboard, 2 <= n <= 3, gamepad
function keybindSetLastType(typeCheck) {

// Set last type of keybind pressed, like if it was from keyboard or gamepad
if (typeCheck > 0) {
	if (typeCheck <= 2) { global.keybindLastType = "keyboard"; }
	else { global.keybindLastType = "gamepad"; };
};

};

/// @description Get type of keybind, if it's keyboard of gamepad
function keybindGetType(keyId) {

// Let's check the given id
switch (keyId) {
	
	case "axisl_horizontal":	 return "gamepad";
	case "axisl_vertical":		 return "gamepad";
	case "axisr_horizontal":	 return "gamepad";
	case "axisr_vertical":		 return "gamepad";
	// Left stick directions
	case "axisl_right":	 return "gamepad";
	case "axisl_left":	 return "gamepad";
	case "axisl_down":	 return "gamepad";
	case "axisl_up":	 return "gamepad";
	// Right stick directions
	case "axisr_right":	 return "gamepad";
	case "axisr_left":	 return "gamepad";
	case "axisr_down":	 return "gamepad";
	case "axisr_up":	 return "gamepad";
	// Add direction buttons
	case gp_padr:	 return "gamepad";
	case gp_padl:	 return "gamepad";
	case gp_padd:	 return "gamepad";
	case gp_padu:	 return "gamepad";
	// Add colors buttons
	case gp_face1:	 return "gamepad";
	case gp_face2:	 return "gamepad";
	case gp_face3:	 return "gamepad";
	case gp_face4:	 return "gamepad";
	// Add shoulders buttons
	case gp_shoulderl:	 return "gamepad";
	case gp_shoulderlb:	 return "gamepad";
	case gp_shoulderr:	 return "gamepad";
	case gp_shoulderrb:	 return "gamepad";
	// Pressed sticks
	case gp_stickl:	 return "gamepad";
	case gp_stickr:	 return "gamepad";
	// Start & select
	case gp_start:	 return "gamepad";
	case gp_select:	 return "gamepad";
	
	// Must be a keyboard shit
	default: return "keyboard";
};

};

/// @description Check if a keybind is being pushed down
function keybindCheck(keyId, plrId = 0) {

// Get keybind ID set
var keyArray = keybindGetVariable(plrId, keyId);

// get different of
var _difOfEx = differentOfEXT(	0,
								keybindTypeCheck("keyboard",	 keyArray[keybindType.keyboard], plrId),
								keybindTypeCheck("keyboard",	 keyArray[keybindType.keyboard_alt], plrId),
								keybindTypeCheck("gamepad",		 keyArray[keybindType.gamepad], plrId),
								keybindTypeCheck("gamepad",		 keyArray[keybindType.gamepad_alt], plrId));
// Set last type of keybind pressed, like if it was from keyboard or gamepad
keybindSetLastType(_difOfEx[1]);

return _difOfEx[0];

};

/// @description Check if a keybind is being just pressed
function keybindCheckPressed(keyId, plrId = 0) {

// Get keybind ID set
var keyArray = keybindGetVariable(plrId, keyId);

// get different of
var _difOfEx = differentOfEXT(	0,
								keybindTypeCheckPressed("keyboard",		 keyArray[keybindType.keyboard], plrId),
								keybindTypeCheckPressed("keyboard",		 keyArray[keybindType.keyboard_alt], plrId),
								keybindTypeCheckPressed("gamepad",		 keyArray[keybindType.gamepad], plrId),
								keybindTypeCheckPressed("gamepad",		 keyArray[keybindType.gamepad_alt], plrId));
// Set last type of keybind pressed, like if it was from keyboard or gamepad
keybindSetLastType(_difOfEx[1]);

return _difOfEx[0];

};

/// @description Check if a keybind is being released
function keybindCheckReleased(keyId, plrId = 0) {

// Get keybind ID set
var keyArray = keybindGetVariable(plrId, keyId);

// get different of
var _difOfEx = differentOfEXT(	0,
								keybindTypeCheckReleased("keyboard",	 keyArray[keybindType.keyboard], plrId),
								keybindTypeCheckReleased("keyboard",	 keyArray[keybindType.keyboard_alt], plrId),
								keybindTypeCheckReleased("gamepad",		 keyArray[keybindType.gamepad], plrId),
								keybindTypeCheckReleased("gamepad",		 keyArray[keybindType.gamepad_alt], plrId));
// Set last type of keybind pressed, like if it was from keyboard or gamepad
keybindSetLastType(_difOfEx[1]);

return _difOfEx[0];

};

#endregion

#region Extra functions for writer and stuff

function specialTextGetKeyChar(keyId) {

// Get basic keyname
var _basicKey = keybindGetName(keyId);
// It''s undefined
if (is_undefined(_basicKey)) { return ""; };

// QUE
if (_basicKey == "none") { return "/p|NONE|"; };

// keyboard check
if (keybindGetType(keyId) == "keyboard") {
	// More than spacing
	if (string_length(_basicKey) > 1) {
		// Return modified character
		return "/p|" + string_upper(_basicKey) + "|";
	};
	
	return _basicKey;
// it's from gamepad
} else {
	
	return "/cW/g|" + _basicKey + "|/cD";
};

};

function specialTextGetKeybindChar(keyId, plrId = 0) {

// Get keybind ID set
var keyArray = keybindGetVariable(plrId, keyId);

// What was last used type? keyboard or gamepad?
if (global.keybindLastType == "keyboard") {
	
	return specialTextGetKeyChar(keyArray[keybindType.keyboard]);
} else {
	
	return specialTextGetKeyChar(keyArray[keybindType.gamepad]);
};

return "";

};

#endregion