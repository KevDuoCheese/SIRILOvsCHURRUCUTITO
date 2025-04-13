/// @description set this up
switch (mousePhase) {
	
	case 0:
		// if mouse is in
		if (((mouseGetX() >= (x - 2)) && (mouseGetX() < (x + 2))) &&
			((mouseGetY() >= (y - 2)) && (mouseGetY() < (y + 2)))) {
			image_index = 1;
			// active it
			if (mouse_check_button_pressed(mb_left)) {
				// move it
				mousePhase = 1;
				mouseOffX = x - mouseGetX();
				mouseOffY = y - mouseGetY();
				
				image_index = 2;
				
				break;
			};
		} else { image_index = 0; };
	break;
	
	case 1:
		// set the x and y
		x = mouseGetX() + mouseOffX;
		y = mouseGetY() + mouseOffY;
		
		image_index = 2;
		// no longer
		if (!mouse_check_button(mb_left)) {
			mousePhase = 0;
			image_index = 1;
			break;
		};
	break;
};