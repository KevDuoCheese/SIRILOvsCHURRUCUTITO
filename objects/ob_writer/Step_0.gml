/// @description Wait for timer and add string to it

// There still time left
if (stringTime > 0) {
	
	// Counting down~
	stringTime--;
	
} else {
	
	// Fill timer
	while (stringTime < 1) {
		
		// Didn't reach max
		if (stringChar < string_length(stringMessage)) {
			
			// Add string to next
			nextCharacterF(true, true);
			
		} else { stringTime += 1; };
	};
};

// Has portrait or something
if (instance_exists(portraitId)) {
	
	// Didn't reach max yet
	if (stringChar < string_length(stringMessage)) {
		// Set animation
		portraitId.animId = "talk";
		
	} else {
		
		// Here too
		portraitId.animId = "idle";
	};
	// Timer is more than expected
	if (stringTime > charTimer) { portraitId.animId = "idle"; };
};

// Switch writer state
switch (writerState) {
	
	case "skipable":
		
		// yes it is
		skipable = true;
		
		// Pressed X or shift
		if (keyboard_check_pressed_action("back")) {
			
			// Not completed yet
			while (stringChar < string_length(stringMessage)) {
				// Till complete
				nextCharacterF(false, false);
			};
		};
		
	break;
	
	case "closeable":
		
		// Pressed action key
		if (keyboard_check_pressed_action("action")) {
			
			// There still messages
			if ((stringMessageId + 1) < array_length(messageId)) {
				
				// Get next message and set it
				stringMessageId++;
				stringMessage = messageId[stringMessageId];
				// String character again
				stringChar = 1;
				// Reset timer
				stringTime = charTimer;
				
			} else {
				
				// Has window
				if (instance_exists(windowId)) { instance_destroy(windowId); };
				// Has p
				if (instance_exists(portraitId)) { instance_destroy(portraitId); };
				// Destroy this shit
				instance_destroy();
			};
			
			// Change writer state
			writerState = "writing";
			if (skipable) { writerState = "skipable"; };
		};
		
	break;
	
	case "choose":
		
		// there is no more chooser
		if (!instance_exists(chooseIns)) {
			
			// Has window
			if (instance_exists(windowId)) { instance_destroy(windowId); };
			// Has p
			if (instance_exists(portraitId)) { instance_destroy(portraitId); };
			// Destroy this shit
			instance_destroy();
		};
	break;
};