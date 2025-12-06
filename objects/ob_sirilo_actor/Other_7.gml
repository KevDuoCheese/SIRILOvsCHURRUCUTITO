/// @description Do to that and loop
if (playingAnimation) {
	// check anim type
	switch (playingType) {
		case 0:
			// set the flag
			playingFlag = true;
			// reset back to idle animation
			animStop();
		break;
		
		case 1:
			// stop this out
			image_index = image_number - 1;
			image_speed = 0;
			// play flag
			playingFlag = true;
		break;
		
		case 2:
			// invert speed
			image_speed *= -1;
			// and flag
			playingFlag = true;
		break;
	};
};