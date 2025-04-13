/// @description 

depth = -20;

// Writing position my man
writingX = x;
writingY = y;
// Acoording to align
writingHAlign = fa_left;
writingVAlign = fa_top;

// Save my type
writerType = global.writerPreType;
// Load this on
writerAdjustType(writerType);


// If can skip the message or not
skipable = false;

// Command character
cmdChar = "/";


// Set some basic messages
messageId = [ "???/*"];
messageData = [ specialTextGetData(messageId[0]) ];
// Load messages
for (var i = 0; i < array_length(global.gMessages); i++) {
	
	// Change message ID my man
	messageId[i] = global.gMessages[i];
	// Get all data from messages
	messageData[i] = specialTextGetData(messageId[i]);
};

// String message my man
stringMessageId = 0;
stringMessage = messageId[stringMessageId];


// In what part of the string we are??
stringChar = 0;

// Adjust time dude
stringTime = 0;
// Writing my boy
writerState = "writing";

// da window thingy
windowId = noone;
// and p too
portraitId = noone;



nextCharacterF = function (playSound, addTime) {
	
	// Add string to next
	stringChar++;
	// Reset timer
	if (addTime) { stringTime += charTimer; };
	
	// Get this char ID
	var charId = string_char_at(stringMessage, stringChar);
	
	// Can play sound??
	if (playSound &&
		(charId != "") &&
		(charId != " ") && 
		(charId != cmdChar)) {
		// Play da fucking sound
		audio_replay_sound(soundId, 1, false, 1, 0, random_range(charPitchBase - charPitchChange, charPitchBase + charPitchChange));
	};
	
	var _forceBreakLoop = false;
	// Is command character
	while (charId == cmdChar) {
		// Omg boy we reach this so fast
		var charNext = string_char_at(stringMessage, stringChar + 1);
		// Add comand char
		stringChar++;
		
		// Get next character and check it out
		switch (charNext) {
				
			case "*":
				
				// Next character my man
				stringChar++;
				
			break;
			
			case "s":
				// Two characters
				stringChar += 2;
				
			break;
			
			case "w": // change width multiplier
					
				// We assume that next character is "|" (i + 1)
				stringChar += 2;
				while (string_char_at(stringMessage, stringChar) != "|") {
					stringChar++;
				};
				// Mext character
				stringChar += 1;
				
			break;
			
			case "h": // change height multiplier
				
				// We assume that next character is "|" (i + 1)
				stringChar += 2;
				while (string_char_at(stringMessage, stringChar) != "|") {
					stringChar++;
				};
				// Mext character
				stringChar += 1;
				
			break;
			
			case "p": case "g": // special character
				
				// We assume that next character is "|" (i + 1)
				stringChar += 2;
				while (string_char_at(stringMessage, stringChar) != "|") {
					stringChar++;
				};
				// Mext character
				stringChar += 1;
				
			break;
			
			case "e":
				// Next character my man
				stringChar++;
				
			break;
			
			case "o":
				// This is choose creation
				stringChar++;
				
			break;
			
			case "c":
				// Mext 2 characters due color change
				stringChar += 2;
				
			break;
			
			case "t":
				
				// The reason of this code is in next line
				var timeToWait = string_char_at(stringMessage, stringChar + 1);
				// Mext 2 characters due time set
				//stringChar += 2;
				// One, explanation in draw GUI event
				stringChar++;
				
				// Set time :)
				if (addTime) { stringTime += -charTimer + (10 * real(timeToWait)); };
				
			break;
			
			case cmdChar:
				// Play da sound
				audio_replay_sound(soundId, 1, false);
				_forceBreakLoop = true;
				
			break;
		};
		
		// Reload this
		charId = string_char_at(stringMessage, stringChar);
		// Break loop?
		if (_forceBreakLoop) { break; };
	};
};