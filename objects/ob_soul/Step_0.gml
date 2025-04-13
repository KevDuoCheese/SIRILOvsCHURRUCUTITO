/// @description Movement speed
if (keyboard_check_pressed(ord("R"))) { x = xstart; y = ystart; };
// Get the pushed keybinds
var _keyRight, _keyLeft, _keyUp, _keyDown;
_keyRight		 = keybindCheck("right");
_keyLeft		 = keybindCheck("left");
_keyDown		 = keybindCheck("down");
_keyUp			 = keybindCheck("up");

switch (mode) {
	
	case "menu":
		
		
	break;
	
	case "move":
		
		// And adjust the move variables here
		moveH = _keyRight - _keyLeft;
		moveV = _keyDown - _keyUp;
		
		
		// Adjust speed
		xSpeed = moveH * moveSpeed;
		ySpeed = moveV * moveSpeed;
		// Save for use later
		preXSpeed = xSpeed;
		preYSpeed = ySpeed;
		
		
		// Move X
		xSpeed = npcMoveX(xSpeed);
		// Move Y
		ySpeed = npcMoveY(ySpeed);
	break;
};