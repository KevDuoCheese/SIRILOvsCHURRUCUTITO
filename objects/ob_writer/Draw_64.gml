/// @description Write in screen DA message

// Dude get placing text
var charX, charY;
charX = writingX;
charY = writingY;

// Change character scale
var charXScale = 1, charYScale = 1;
// If using special character
var charSpecial = -1, charGamepad = -1;

// Character colors
var charColor, charShake, rainbowColor = false, drawChar = true, linesCounting = 0, charCount = 0;
charColor = ocColor;
charShake = 0;

// Set font ID
draw_set_font(fontId);

// Get line from it
var _getLineX = function (lineId, textData, xPos) {
	// What horizontal align are we using?
	switch (writingHAlign) {
		
		case fa_left: default:	 return xPos;
		
		case fa_center:			 return xPos - (textData.linesWidth[lineId] / 2);
		
		case fa_right:			 return xPos - textData.linesWidth[lineId];
	};
};

// Adjust this shit bro
charX = _getLineX(0, messageData[stringMessageId], writingX);
// What vertical align are we using?
switch (writingVAlign) {
	
	case fa_top: default:	 charY = writingY; break;
	
	case fa_middle:			 charY = writingY - (messageData[stringMessageId].totalHeight / 2); break;
	
	case fa_bottom:			 charY = writingY - messageData[stringMessageId].totalHeight; break;
};

// Loop to write in screen
for (var i = 1; i <= stringChar; i++) {
	
	// Get actual character
	var charId = string_char_at(stringMessage, i);
	
	
	var _forceBreakLoop = false;
	// Found da character
	while (charId == cmdChar) {
		
		// Get next character and add one
		var charNext = string_char_at(stringMessage, i + 1);
		// We could put this before but meh
		i++;
		
		// Switch next character
		switch (charNext) {
			
			case "e":
				
				// Add one again
				i++;
				// Next line dude
				//charX = writingX;
				linesCounting++;
				charX = _getLineX(linesCounting, messageData[stringMessageId], writingX);
				charY += charHeight * charYScale;
			break;
			
			case "t":
				
				// Should add two, due has 2 characters, but to avoid ghostchar add one and don't draw next
				//i += 2;
				i++;
				drawChar = false;
			break;
			
			case "*":
				
				// Now we can close it
				writerState = "closeable";
				// Add one again, this executes in step event (fake it executes here)
				i++;
			break;
			
			case "o":
				
				// Not on choose state
				if (writerState != "choose") {
					
					// Create choose thing
					chooseIns = instance_create_depth(0, 0, 0, ob_choose, {
						drawOnTop : (y < (screen.height / 2))
					});
					
					// Change writer state
					writerState = "choose";
				};
				// Same as previous
				i++;
			break;
			
			case "s":
				
				// The reason of this code is in next line
				var shakeValue = string_char_at(stringMessage, i + 1);
				// Mext 2 characters due shake set
				i += 2;
				
				// ShAkInG
				charShake = real(shakeValue);
				
			break;
			
			case "w": // change width multiplier
				
				var changeM = "";
				
				// We assume that next character is "|" (i + 1)
				i += 2;
				while (string_char_at(stringMessage, i) != "|") {
					// Add to string array
					changeM += string_char_at(stringMessage, i);
					i++;
				};
				// Mext character
				i += 1;
				
				// WIIDDTTHH
				try { charXScale = real(changeM); } catch (_errShit) { charXScale = 1; };
				
			break;
			
			case "h": // change height multiplier
				
				var changeM = "";
				
				// We assume that next character is "|" (i + 1)
				i += 2;
				while (string_char_at(stringMessage, i) != "|") {
					// Add to string array
					changeM += string_char_at(stringMessage, i);
					i++;
				};
				// Mext character
				i += 1;
				
				// HEIGHT bro 1.80
				try { charYScale = real(changeM); } catch (_errShit) { charYScale = 1; };
				
			break;
			
			case "p": // special character
				
				var sCharId = "";
				
				// We assume that next character is "|" (i + 1)
				i += 2;
				while (string_char_at(stringMessage, i) != "|") {
					// Add to string array
					sCharId += string_char_at(stringMessage, i);
					i++;
				};
				// Mext character
				//i += 1;
				
				// Adjust special character shit
				charSpecial = global._specialChar[? sCharId];
				
			break;
			
			case "g": // gamepad character
				
				var sCharId = "";
				
				// We assume that next character is "|" (i + 1)
				i += 2;
				while (string_char_at(stringMessage, i) != "|") {
					// Add to string array
					sCharId += string_char_at(stringMessage, i);
					i++;
				};
				
				// Adjust special character shit
				charGamepad = global._gamepadChar[? sCharId];
				
			break;
			
			case "c":
				
				// The reason of this code is in next line
				var colorCharId = string_char_at(stringMessage, i + 1);
				// Add one and check next for color char
				i += 2;
				
				// Deactive this
				rainbowColor = false;
				// Switch between
				switch (colorCharId) {
					// Set to default color
					case "D": charColor = ocColor; break;
					
					case "W": charColor = COLOR_WHITE; break;
					
					case "B": charColor = COLOR_BLACK; break;
					// Aqua
					case "C": charColor = COLOR_AQUA; break;
					// Fucshia
					case "F": charColor = COLOR_FUCHSIA; break;
					// Purple
					case "M": charColor = COLOR_PURPLE; break;
					// Blue
					case "A": charColor = COLOR_BLUE; break;
					// Red
					case "R": charColor = COLOR_RED; break;
					// Light green
					case "V": charColor = COLOR_LIME; break;
					// Yellow
					case "Y": charColor = COLOR_YELLOW; break;
					// Grey
					case "G": charColor = COLOR_GRAY; break;
					// Orange
					case "N": charColor = COLOR_ORANGE; break;
					// Maroon
					case "O": charColor = COLOR_MAROON; break;
					
					case "H": rainbowColor = true; break;
				};
			break;
			
			case cmdChar: _forceBreakLoop = true; break;
		};
		
		// Get character again
		charId = string_char_at(stringMessage, i);
		// Break it?
		if (_forceBreakLoop) { break; };
	};
	
	// Rainbow color or not?
	if (rainbowColor) {
		// Set character color in rainbow thing
		charColor = make_color_hsv(((charCount * 25) + (currentFrame() * 2)) mod 256, 255, 255);
	};
	
	
	// If can draw that shit
	if (drawChar) {
		
		// Set draw position
		var finalX = charX, finalY = charY;
		finalX = charX + ((0.5 - random(1)) * charShake);
		finalY = charY + ((0.5 - random(1)) * charShake);
		// Special shake thing
		switch (charShake) {
			
			case 5:
				// Adjust new final X and Y
				finalX = charX;
				finalY = charY + (1.5 * sin((currentFrame() / 6) + (charCount * 5)));
				
			break;
			
			case 6:
				
				var constPi = (currentFrame() / 7) + (charCount * 5);
				
				// Adjust new final X and Y
				finalX = charX + (1.5 * cos(constPi));
				finalY = charY + (1.5 * sin(constPi));
				
			break;
			
			case 7:
				// Adjust new final X and Y
				finalX = charX + (1.5 * cos((currentFrame() / 6) + (charCount * 5)));
				finalY = charY;
				
			break;
			
			case 8:
				// Adjust new final X and Y
				finalX = charX;
				finalY = charY + (1.25 * sin((currentFrame() / 10) + (charCount * 5)));
				
			break;
		};
		
		// Set an gamepad character
		if (charGamepad > -1) {
			
			// Draw gamepad character in position
			draw_sprite_ext(sp_gamepad_characters, charGamepad, finalX, finalY, charXScale, charYScale, 0, charColor, 1);
			
			// Reset this
			charGamepad = -1;
			
		}
		// Set an special character
		else if (charSpecial > -1) {
			
			// Draw shadow on bottom
			draw_sprite_ext(sp_special_characters, charSpecial, finalX, finalY + 1, charXScale, charYScale, 0, COLOR_BLACK, 1);
			// Draw special character in position
			draw_sprite_ext(sp_special_characters, charSpecial, finalX, finalY, charXScale, charYScale, 0, charColor, 1);
			
			// Reset this
			charSpecial = -1;
			
		} else {
			
			// Set black color
			draw_set_color(COLOR_BLACK);
			// Dude set this
			draw_text_transformed(finalX, finalY + 1, charId, charXScale, charYScale, 0);
			// Set color of this shit
			draw_set_color(charColor);
			// Draw character on position
			draw_text_transformed(finalX, finalY, charId, charXScale, charYScale, 0);
		};
		
		// Add character X
		charX += charWidth * charXScale;
		// Add counter
		charCount++;
	};
	// Yes you can.
	drawChar = true;
};