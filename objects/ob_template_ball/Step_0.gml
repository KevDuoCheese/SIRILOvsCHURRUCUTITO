/// @description TEST MOVEMENT

// Adjust this
var _keyRight, _keyLeft, _keyUp, _keyDown;
_keyRight		 = keybindCheck("right");
_keyLeft		 = keybindCheck("left");
_keyDown		 = keybindCheck("down");
_keyUp			 = keybindCheck("up");

// Add positions
x += (_keyRight - _keyLeft) * 3;
y += (_keyDown - _keyUp) * 3;
