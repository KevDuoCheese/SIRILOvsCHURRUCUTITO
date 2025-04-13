/// @description Adjust phase
switch (phase) {
	
	case 0:
		if (animOpen == -1) { phase = 1; break; };
		
		// Move animation curve bro
		wSetAnimCurve(animOpen);
		// OK it's finished
		if (value >= 1) {
			value = 0;
			phase = 1;
			break;
		};
	break;
	
	case 1:
		if (animIdle == -1) {
			value = 0;
			// Set visual scales
			visualXScale = 1;
			visualYScale = 1;
			// Set visual position offset
			visualX = 0;
			visualY = 0;
			// Image alpha
			visualAlpha = 1;
			break;
		};
		
		// Move animation curve bro
		wSetAnimCurve(animIdle);
		// Reset back to start
		value = value mod 1;
	break;
	
	case 2:
		if (animClose == -1) { instance_destroy(); exit; };
		
		// End animation
		wSetAnimCurve(animClose);
		// OK it's finished
		if (value >= 1) {
			instance_destroy();
			exit;
		};
	break;
};



















