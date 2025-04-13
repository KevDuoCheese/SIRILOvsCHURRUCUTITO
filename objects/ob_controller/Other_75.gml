/// @description Update gamepad

// What type of?
switch (async_load[? "event_type"]) {
	
	case "gamepad lost":
		
		// Update gamepad
		gamepadUpdate();
		
	break;
	
	case "gamepad discovered":
		
		// Update gamepad
		gamepadUpdate();
		
	break;
};
