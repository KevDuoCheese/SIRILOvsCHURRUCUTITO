/// @description broo

// add the accelaretaion
y += ySpeed;
// avoid going under
if (y > ystart) { y = ystart; ySpeed = 0; };

// to go down after
ySpeed += gravityValue;

// switch phase
switch (phase) {
	case 0:
		if (destroyTimer > 0) { destroyTimer--; } else {
			phase = 1;
		};
	break;
	
	case 1:
		// reudce alpha
		textAlpha = approachValue(textAlpha, 0, 0.1);
		// reached?
		if (textAlpha <= 0) { instance_destroy(); exit; };
	break;
};