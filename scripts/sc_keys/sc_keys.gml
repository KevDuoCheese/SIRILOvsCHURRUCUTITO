
/// @description if some action key has been released
function keyboard_check_released_action(actionId) {

// Switch beetween posible actions
switch (actionId) {
	
	case "action": return keybindCheckReleased("action");
	
	case "back": return keybindCheckReleased("back");
	
	case "menu": return keybindCheckReleased("menu");
};

return false;

};

/// @description if some action key has been pressed
function keyboard_check_pressed_action(actionId) {

// Switch beetween posible actions
switch (actionId) {
	
	case "action": return keybindCheckPressed("action");
	
	case "back": return keybindCheckPressed("back");
	
	case "menu": return keybindCheckPressed("menu");
};

return false;

};

/// @description if some action key is pressed
function keyboard_check_action(actionId) {

// Switch beetween posible actions
switch (actionId) {
	
	case "action": return keybindCheck("action");
	
	case "back": return keybindCheck("back");
	
	case "menu": return keybindCheck("menu");
};

return false;

};