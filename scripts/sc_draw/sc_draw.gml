
// Create a map to save in special characters
global._specialChar = ds_map_create();
// Add special characters to it
global._specialChar[? "UP"]				 = 0;
global._specialChar[? "DOWN"]			 = 1;
global._specialChar[? "RIGHT"]			 = 2;
global._specialChar[? "LEFT"]			 = 3;
global._specialChar[? "SPACE"]			 = 4;
global._specialChar[? "FN"]				 = 5;
global._specialChar[? "CONTROL"]		 = 6;
global._specialChar[? "LEFT CONTROL"]	 = 6;
global._specialChar[? "RIGHT CONTROL"]	 = 6;
global._specialChar[? "SHIFT"]			 = 7;
global._specialChar[? "LEFT SHIFT"]		 = 7;
global._specialChar[? "RIGHT SHIFT"]	 = 7;
global._specialChar[? "TAB"]			 = 8;
global._specialChar[? "ESCAPE"]			 = 9;
global._specialChar[? "MONEY"]			 = 10;
global._specialChar[? "EXP"]			 = 11;
global._specialChar[? "NONE"]			 = 12;
global._specialChar[? "ENTER"]			 = 13;
global._specialChar[? "BACKSPACE"]		 = 14;
global._specialChar[? "TAB"]			 = 15;
global._specialChar[? "ALT"]			 = 16;
global._specialChar[? "LEFT ALT"]		 = 16;
global._specialChar[? "RIGHT ALT"]		 = 16;

// Adjust character for gamepad
global._gamepadChar = ds_map_create();

// Gamepad directions
ds_map_add(global._gamepadChar, "L-Stick H", 24);
ds_map_add(global._gamepadChar, "L-Stick V", 25);
ds_map_add(global._gamepadChar, "R-Stick H", 17);
ds_map_add(global._gamepadChar, "R-Stick V", 18);
// Left stick directions
ds_map_add(global._gamepadChar, "L-Stick Right", 19);
ds_map_add(global._gamepadChar, "L-Stick Left", 20);
ds_map_add(global._gamepadChar, "L-Stick Down", 21);
ds_map_add(global._gamepadChar, "L-Stick Up", 22);
// Right stick directions
ds_map_add(global._gamepadChar, "R-Stick Right", 12);
ds_map_add(global._gamepadChar, "R-Stick Left", 13);
ds_map_add(global._gamepadChar, "R-Stick Down", 15);
ds_map_add(global._gamepadChar, "R-Stick Up", 14);
// Add direction buttons
ds_map_add(global._gamepadChar, "Pad Right", 5);
ds_map_add(global._gamepadChar, "Pad Left", 7);
ds_map_add(global._gamepadChar, "Pad Down", 6);
ds_map_add(global._gamepadChar, "Pad Up", 4);
// Add colors buttons
ds_map_add(global._gamepadChar, "A", 0);
ds_map_add(global._gamepadChar, "B", 1);
ds_map_add(global._gamepadChar, "X", 3);
ds_map_add(global._gamepadChar, "Y", 2);
// Add shoulders buttons
ds_map_add(global._gamepadChar, "L1", 10);
ds_map_add(global._gamepadChar, "L2", 11);
ds_map_add(global._gamepadChar, "R1", 8);
ds_map_add(global._gamepadChar, "R2", 9);
// Pressed sticks
ds_map_add(global._gamepadChar, "L3", 23);
ds_map_add(global._gamepadChar, "R3", 16);
// Start & select
ds_map_add(global._gamepadChar, "Start", 26);
ds_map_add(global._gamepadChar, "Select", 27);

// Adjust character for gamepad
global._gamepadSprite = ds_map_create();

// Gamepad directions
ds_map_add(global._gamepadSprite, "L-Stick H", sp_kg_stickl_horizontal);
ds_map_add(global._gamepadSprite, "L-Stick V", sp_kg_stickl_vertical);
ds_map_add(global._gamepadSprite, "R-Stick H", sp_kg_stickr_horizontal);
ds_map_add(global._gamepadSprite, "R-Stick V", sp_kg_stickr_vertical);
// Left stick directions
ds_map_add(global._gamepadSprite, "L-Stick Right", sp_kg_stickl_r);
ds_map_add(global._gamepadSprite, "L-Stick Left", sp_kg_stickl_l);
ds_map_add(global._gamepadSprite, "L-Stick Down", sp_kg_stickl_d);
ds_map_add(global._gamepadSprite, "L-Stick Up", sp_kg_stickl_u);
// Right stick directions
ds_map_add(global._gamepadSprite, "R-Stick Right", sp_kg_stickr_r);
ds_map_add(global._gamepadSprite, "R-Stick Left", sp_kg_stickr_l);
ds_map_add(global._gamepadSprite, "R-Stick Down", sp_kg_stickr_d);
ds_map_add(global._gamepadSprite, "R-Stick Up", sp_kg_stickr_u);
// Add direction buttons
ds_map_add(global._gamepadSprite, "Pad Right", sp_kg_right);
ds_map_add(global._gamepadSprite, "Pad Left", sp_kg_left);
ds_map_add(global._gamepadSprite, "Pad Down", sp_kg_down);
ds_map_add(global._gamepadSprite, "Pad Up", sp_kg_up);
// Add colors buttons
ds_map_add(global._gamepadSprite, "A", sp_kg_key0);
ds_map_add(global._gamepadSprite, "B", sp_kg_key1);
ds_map_add(global._gamepadSprite, "X", sp_kg_key3);
ds_map_add(global._gamepadSprite, "Y", sp_kg_key2);
// Add shoulders buttons
ds_map_add(global._gamepadSprite, "L1", sp_kg_shoulderl);
ds_map_add(global._gamepadSprite, "L2", sp_kg_shoulderlb);
ds_map_add(global._gamepadSprite, "R1", sp_kg_shoulderr);
ds_map_add(global._gamepadSprite, "R2", sp_kg_shoulderrb);
// Pressed sticks
ds_map_add(global._gamepadSprite, "L3", sp_kg_stickl_press);
ds_map_add(global._gamepadSprite, "R3", sp_kg_stickr_press);
// Start & select
ds_map_add(global._gamepadSprite, "Start", sp_kg_start);
ds_map_add(global._gamepadSprite, "Select", sp_kg_select);

/// @description IF is required view
function drawCan(myView = viewId.draw) {

return (view_current == myView);

};

/// @description Reset main draw variables
function drawReset() {

// Back alpha
draw_set_alpha(1);

// Reset align
draw_set_halign(fa_left);
draw_set_valign(fa_top);

};

/// @description As the function name says, call a preset and set it
function drawPreset(presetName) {

// Choose a preset
switch (presetName) {
	
	case "general":
		
		// Set the font to it
		draw_set_font(global.fontMap[? "general"]);
		// And default color
		draw_set_color(c_white);
		
	break;
	
	case "ui-buttons":
		
		// Set the font to it
		draw_set_font(global.fontMap[? "ui-buttons"]);
		// And default color
		draw_set_color(c_white);
		
	break;
	
	case "stat":
		
		// Set the font to it
		draw_set_font(global.fontMap[? "small"]);
		// And default color
		draw_set_color(c_white);
		
	break;
	
	case "small":
		
		// Set the font to it
		draw_set_font(global.fontMap[? "small"]);
		// And default color
		draw_set_color(c_white);
		
	break;
	
	case "test-data":
		
		// Set the font to it
		draw_set_font(global.fontMap[? "test-data"]);
		// And default color
		draw_set_color(c_white);
		
	break;
	
	case "battle-blood":
		
		// Set the font to it
		draw_set_font(global.fontMap[? "battle-blood"]);
		// And default color
		draw_set_color(c_white);
		
	break;
};

};

/// @description If we are in a usable view
function drawCanDraw(usingView = viewId.draw) {

return view_current == usingView;

};

/// @description Draw a line from a position to another
function drawLine(x1, y1, x2, y2) {

// Get color
var lineColor = draw_get_color();
var lineAlpha = draw_get_alpha();
// Get angle
var lineAngle = point_direction(x1, y1, x2, y2);
// Get size
var lineSize = point_distance(x1, y1, x2, y2);

// Draw line
draw_sprite_ext(sp_11box, 0, x1, y1, lineSize, global.screenSizeInv, lineAngle, lineColor, lineAlpha);

};

// Draw thxt with outline shader bro
function drawTextOutlineTransformed(xPos, yPos, stringValue, xScale, yScale, angle, outlineLength, outlineColor) {

var outlineL = outlineLength;

var finalWidth, finalHeight;
finalWidth	 = string_width(stringValue) + (outlineL * 2);
finalHeight	 = string_height(stringValue) + (outlineL * 2);

// Surface isn't enough big to hold it
if (surface_get_width(global.surfMap[? "font"]) < finalWidth)

{ surface_resize(global.surfMap[? "font"], finalWidth, surface_get_height(global.surfMap[? "font"])); };


// And not enough in height too
if (surface_get_height(global.surfMap[? "font"]) < finalHeight)

{ surface_resize(global.surfMap[? "font"], surface_get_width(global.surfMap[? "font"]), finalHeight); };

// save ol bairbales
var oldSurf, oldBlendmode, oldShader;
// Get da shit out
oldSurf = surface_get_target();
// da blendmode
oldBlendmode = gpu_get_blendmode_ext();
// THE FUCKING ASS SHADER
oldShader = shader_current();


// Omaga my dearest friend
gpu_set_blendmode(bm_normal);
// Has a target
if (oldSurf >= 0) { surface_reset_target(); };
// Is using shader
if (oldShader != -1) { shader_reset(); };


// Clear the surface and draw the font
surface_set_target(global.surfMap[? "font"]);
draw_clear_alpha(c_black, 0);
// Activate the shit out of this
gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
shader_set(sh_alpha_surface);

// Draw it my man
draw_text(outlineL, outlineL, stringValue);

// Back to it
surface_reset_target();

// Surfaces surfaces i cant take this
if (oldSurf >= 0) { surface_set_target(oldSurf); };
// Is using shader
if (oldShader != -1) { shader_set(oldShader); };
// Start outline in surface
outline_start(outlineLength, outlineColor, surface_get_texture(global.surfMap[? "font"]));

// Draw the fucking surface
draw_surface_ext(global.surfMap[? "font"],
				 
				 xPos - lengthdir_x(outlineL, angle) * xScale - lengthdir_x(outlineL, angle - 90) * yScale,
				 yPos - lengthdir_y(outlineL, angle) * xScale - lengthdir_y(outlineL, angle - 90) * yScale,
				 
				 xScale,
				 yScale,
				 
				 angle,
				 c_white,
				 1);

// Reset this shit tho
gpu_set_blendmode_ext(oldBlendmode[0], oldBlendmode[1]);

};

function draw_text_shadow_transformed(xPos, yPos, stringValue, xScale, yScale, angle, shadowCol = COLOR_BLACK) {

// Get colro of text
var saveCol = draw_get_color();
// Shadow color
draw_set_color(shadowCol);
// Draw shadow
draw_text_transformed(xPos, yPos + 1, stringValue, xScale, yScale, angle);
//draw_text_transformed(xPos + 1, yPos, stringValue, xScale, yScale, angle);
// Set color again
draw_set_color(saveCol);
// Draw text
draw_text_transformed(xPos, yPos, stringValue, xScale, yScale, angle);

};

function draw_text_shadow(xPos, yPos, stringValue, shadowCol = COLOR_BLACK) {
// Draw the text dea
draw_text_shadow_transformed(xPos, yPos, stringValue, 1, 1, 0, shadowCol);

};



function draw_text_outline_transformed(xPos, yPos, stringValue, xScale, yScale, angle, outlineCol = COLOR_BLACK) {

// Get color of text
var saveCol = draw_get_color();
// Outline color
draw_set_color(outlineCol);
// Draw outline
draw_text_transformed(xPos, yPos + 1, stringValue, xScale, yScale, angle);
draw_text_transformed(xPos, yPos - 1, stringValue, xScale, yScale, angle);
draw_text_transformed(xPos + 1, yPos, stringValue, xScale, yScale, angle);
draw_text_transformed(xPos - 1, yPos, stringValue, xScale, yScale, angle);
// Set color again
draw_set_color(saveCol);
// Draw text
draw_text_transformed(xPos, yPos, stringValue, xScale, yScale, angle);

};

function draw_text_outline(xPos, yPos, stringValue, outlineCol = COLOR_BLACK) {
// Draw the text dea
draw_text_outline_transformed(xPos, yPos, stringValue, 1, 1, 0, outlineCol);

};


function specialTextGetData(stringValue) {

var _returnData = { linesWidth : [], totalWidth : 0, totalHeight : 0, clearText : "" };
var _obtainedW, _obtainedH, _thisLineW = 0, _onlyText = "";
_obtainedW = 0;
_obtainedH = 0;

// Get this shit out my man
var _charCode, _charId, _charXScale = 1, _charYScale = 1;
_charId = "";
_charCode = "/";

// If using special character
var _charSpecial = -1, _charGamepad = -1;

// Loop all text in it
for (var i = 1; i <= string_length(stringValue); i++) {
	
	// Update char ID
	_charId = string_char_at(stringValue, i);
	// While it's a char code
	while (_charId == _charCode) {
		
		// get next char
		var _charNext = string_char_at(stringValue, i + 1);
		i++;
		
		// What code is it??
		switch (_charNext) {
			
			case "e":
				
				// Add one again
				i++;
				// Next line dude
				_obtainedW = max(_obtainedW, _thisLineW);
				array_push(_returnData.linesWidth, _thisLineW);
				_thisLineW = 0;
				_obtainedH += string_height(stringValue) * _charYScale;
			break;
			
			case "s":
				// Mext 2 characters due shake set
				i += 2;
				
			break;
			
			case "w": // change width multiplier
				
				var _changeM = "";
				
				// We assume that next character is "|" (i + 1)
				i += 2;
				while (string_char_at(stringValue, i) != "|") {
					// Add to string array
					_changeM += string_char_at(stringValue, i);
					i++;
				};
				// Mext character
				i += 1;
				
				// WIIDDTTHH
				try { _charXScale = real(_changeM); } catch (_errShit) { _charXScale = 1; };
				
			break;
			
			case "h": // change height multiplier
				
				var _changeM = "";
				
				// We assume that next character is "|" (i + 1)
				i += 2;
				while (string_char_at(stringValue, i) != "|") {
					// Add to string array
					_changeM += string_char_at(stringValue, i);
					i++;
				};
				// Mext character
				i += 1;
				
				// HEIGHT bro 1.80
				try { _charYScale = real(_changeM); } catch (_errShit) { _charYScale = 1; };
				
			break;
			
			case "p": // special character
				
				var _sCharId = "";
				
				// We assume that next character is "|" (i + 1)
				i += 2;
				while (string_char_at(stringValue, i) != "|") {
					// Add to string array
					_sCharId += string_char_at(stringValue, i);
					i++;
				};
				// Mext character
				//i += 1;
				
				// Adjust special character shit
				_charSpecial = global._specialChar[? _sCharId];
				
			break;
			
			case "g": // special character
				
				var _sCharId = "";
				
				// We assume that next character is "|" (i + 1)
				i += 2;
				while (string_char_at(stringValue, i) != "|") {
					// Add to string array
					_sCharId += string_char_at(stringValue, i);
					i++;
				};
				
				// Adjust special character shit
				_charGamepad = global._gamepadChar[? _sCharId];
				
			break;
			
			case "c":
				
				// Add two characters skip
				i += 2;
			break;
		};
		// Get character again
		_charId = string_char_at(stringValue, i);
	};
	
	// Set an gamepad character
	if (_charGamepad > -1) {
		
		// Go next text position
		_thisLineW += sprite_get_width(sp_gamepad_characters) * _charXScale;
		_onlyText += " ";
		// Reset this
		_charGamepad = -1;
	}
	// Set an special character
	else if (_charSpecial > -1) {
		
		// Go next text position
		_thisLineW += sprite_get_width(sp_special_characters) * _charXScale;
		_onlyText += " ";
		// Reset this
		_charSpecial = -1;
		
	} else {
		// Go next text position
		_thisLineW += string_width(_charId) * _charXScale;
		_onlyText += _charId;
	};
};

// Add the last line to the array and get the total width of string
_obtainedW = max(_obtainedW, _thisLineW);
array_push(_returnData.linesWidth, _thisLineW);
// And total height too
_obtainedH += string_height(stringValue) * _charYScale;

// So lets set it on the struct
_returnData.totalWidth = _obtainedW;
_returnData.totalHeight = _obtainedH;
_returnData.clearText = _onlyText;

// Send it
return _returnData;

};

function specialTextGetWidth(stringValue)	 { return specialTextGetData(stringValue).totalWidth; };
function specialTextGetHeight(stringValue)	 { return specialTextGetData(stringValue).totalHeight; };

function drawTextSpecial(xPos, yPos, stringValue, hasShadow = true) {

// Position of this
var textX, textY;
textX = xPos;
textY = yPos;

// Lets get some shit of this
var textData = specialTextGetData(stringValue);
//show_debug_message(textData);

// Get old color
var oldCol, _linesCount = 0;
oldCol = draw_get_color();

// Get this shit out my man
var charShake, charColor, charCode, charId, charXScale = 1, charYScale = 1, charCount = 0;
charId = "";
charCode = "/";

charShake = 0;
charColor = oldCol;
// If using special character
var charSpecial = -1, charGamepad = -1, rainbowColor = false;
var _oldHAlign = draw_get_halign(), _oldVAlign = draw_get_valign();


var _getLineX = function (lineId, textData, xPos) {
	// What horizontal align are we using?
	switch (draw_get_halign()) {
		
		case fa_left: default:	 return xPos;
		
		case fa_center:			 return xPos - (textData.linesWidth[lineId] / 2);
		
		case fa_right:			 return xPos - textData.linesWidth[lineId];
	};
};

// Adjust this shit bro
textX = _getLineX(0, textData, xPos);
// What vertical align are we using?
switch (draw_get_valign()) {
	
	case fa_top: default:	 textY = yPos; break;
	
	case fa_middle:			 textY = yPos - (textData.totalHeight / 2); break;
	
	case fa_bottom:			 textY = yPos - textData.totalHeight; break;
};

// Loop all text in it
for (var i = 1; i <= string_length(stringValue); i++) {
	
	// Update char ID
	charId = string_char_at(stringValue, i);
	
	// If need to break loop
	var _forceBreakLoop = false;
	// While it's a char code
	while (charId == charCode) {
		
		// get next char
		var charNext = string_char_at(stringValue, i + 1);
		i++;
		
		// What code is it??
		switch (charNext) {
			
			case "e": case "\n":
				
				// Add one again
				i++;
				// Next line dude
				_linesCount++;
				textX = _getLineX(_linesCount, textData, xPos);
				textY += string_height(stringValue) * charYScale;
			break;
			
			case "s":
				
				// The reason of this code is in next line
				var shakeValue = string_char_at(stringValue, i + 1);
				// Mext 2 characters due shake set
				i += 2;
				
				// ShAkInG
				charShake = real(shakeValue);
				
			break;
			
			case "w": // change width multiplier
				
				var changeM = "";
				
				// We assume that next character is "|" (i + 1)
				i += 2;
				while (string_char_at(stringValue, i) != "|") {
					// Add to string array
					changeM += string_char_at(stringValue, i);
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
				while (string_char_at(stringValue, i) != "|") {
					// Add to string array
					changeM += string_char_at(stringValue, i);
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
				while (string_char_at(stringValue, i) != "|") {
					// Add to string array
					sCharId += string_char_at(stringValue, i);
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
				while (string_char_at(stringValue, i) != "|") {
					// Add to string array
					sCharId += string_char_at(stringValue, i);
					i++;
				};
				
				// Adjust gamepad character shit
				charGamepad = global._gamepadChar[? sCharId];
				
			break;
			
			case "c":
				
				// The reason of this code is in next line
				var colorCharId = string_char_at(stringValue, i + 1);
				rainbowColor = false;
				// Add one and check next for color char
				i += 2;
				
				// Switch between
				switch (colorCharId) {
					
					case "D": charColor = oldCol; break;
					
					case "W": charColor = c_white; break;
					
					case "B": charColor = COLOR_BLACK; break;
					// Aqua
					case "C": charColor = #4AFFF7; break;
					// Fucshia
					case "F": charColor = #E200FF; break;
					// Purple
					case "M": charColor = #9600FA; break;
					// Blue
					case "A": charColor = #523AFF; break;
					// Red
					case "R": charColor = #F8005D; break;
					// Light green
					case "V": charColor = #00FF90; break;
					// Yellow
					case "Y": charColor = #FFEC2B; break;
					// Grey
					case "G": charColor = #9595B9; break;
					// Orange
					case "N": charColor = #F89448; break;
					// Maroon
					case "O": charColor = #A0415A; break;
					
					case "H": rainbowColor = true; break;
				};
			break;
			
			case charCode: _forceBreakLoop = true; break;
		};
		// Get character again
		charId = string_char_at(stringValue, i);
		
		// Break it?
		if (_forceBreakLoop) { break; };
	};
	
	// Rainbow color or not?
	if (rainbowColor) {
		// Set character color in rainbow thing
		charColor = make_color_hsv(((charCount * 25) + (currentFrame() * 2)) mod 256, 255, 255);
	};
	
	
	// Draw position of this shit
	var drawX, drawY;
	drawX = textX + ((0.5 - random(1)) * charShake);
	drawY = textY + ((0.5 - random(1)) * charShake);
	// Special shake thing
	switch (charShake) {
		
		case 5:
			// Adjust new final X and Y
			drawX = textX;
			drawY = textY + (1.5 * sin((currentFrame() / 6) + (i * 5)));
			
		break;
		
		case 6:
			
			var constPi = (currentFrame() / 7) + (i * 5);
			
			// Adjust new final X and Y
			drawX = textX + (1.5 * cos(constPi));
			drawY = textY + (1.5 * sin(constPi));
			
		break;
		
		case 7:
			// Adjust new final X and Y
			drawX = textX + (1.5 * cos((currentFrame() / 6) + (i * 5)));
			drawY = textY;
			
		break;
	};
	
	// Set an gamepad character
	if (charGamepad > -1) {
		
		// Draw gamepad character in position
		draw_sprite_ext(sp_gamepad_characters, charGamepad, drawX, drawY, charXScale, charYScale, 0, charColor, draw_get_alpha());
		
		// Go next text position
		textX += sprite_get_width(sp_gamepad_characters) * charXScale;
		// Reset this
		charGamepad = -1;
		charCount++;
		
	}
	// Set an special character
	else if (charSpecial > -1) {
		
		// Draw shadow on bottom
		if (hasShadow) { draw_sprite_ext(sp_special_characters, charSpecial, drawX, drawY + 1, charXScale, charYScale, 0, COLOR_BLACK, draw_get_alpha()); };
		// Draw special character in position
		draw_sprite_ext(sp_special_characters, charSpecial, drawX, drawY, charXScale, charYScale, 0, charColor, draw_get_alpha());
		
		// Go next text position
		textX += sprite_get_width(sp_special_characters) * charXScale;
		// Reset this
		charSpecial = -1;
		charCount++;
		
	} else {
		
		// Reset temporaly aligns
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
		
		// if has shadow
		if (hasShadow) {
			// Set black color
			draw_set_color(COLOR_BLACK);
			// Dude set this
			draw_text_transformed(drawX, drawY + 1, charId, charXScale, charYScale, 0);
		};
		// Set color of this shit
		draw_set_color(charColor);
		// Draw character on position
		draw_text_transformed(drawX, drawY, charId, charXScale, charYScale, 0);
		
		// Set it again
		draw_set_halign(_oldHAlign);
		draw_set_valign(_oldVAlign);
		
		// Go next text position
		textX += string_width(charId) * charXScale;
		charCount++;
	};
};
// Set color again
draw_set_color(oldCol);

};

function keyDirectDraw(xPos, yPos, keyId, xScale, yScale, imageAngle, imageBlend, imageAlpha) {

// Get basic keyname
var _basicKey = keybindGetName(keyId);
// It''s undefined
if (is_undefined(_basicKey)) { exit; };

// QUE
if (_basicKey == "none") {  };

var _keyAnim = floor(currentFrame() / 15);

// Draw gthe fucking preset
drawPreset("general");

// keyboard check
if (keybindGetType(keyId) == "keyboard") {
	
	// Draw the key
	draw_sprite_ext(sp_k_keyboard, _keyAnim mod 2, xPos, yPos, xScale, yScale, imageAngle, imageBlend, imageAlpha);
	
	// Adjust halign and valign
	draw_set_halign(fa_middle);
	draw_set_valign(fa_center);
	draw_set_color(imageBlend);
	draw_set_alpha(imageAlpha);
	
	// Has in it?
	var _mapValue = global._specialChar[? string_upper(_basicKey)];
	if (!is_undefined(_mapValue)) {
		var _scWidth, _scHeight;
		_scWidth	 = sprite_get_width(sp_special_characters) * xScale * 0.5;
		_scHeight	 = sprite_get_height(sp_special_characters) * yScale * 0.5;
		
		// Draw the fucking shit
		draw_sprite_ext(sp_special_characters, _mapValue,
					xPos - (lengthdir_x(_scWidth, imageAngle) + lengthdir_x(_scHeight, imageAngle - 90)),
					yPos - (lengthdir_y(_scWidth, imageAngle) + lengthdir_y(_scHeight, imageAngle - 90)),
					xScale, yScale, imageAngle, imageBlend, imageAlpha);
		
	} else {
		
		var _scWidth, _scHeight;
		_scWidth	 = 0;
		_scHeight	 = (_keyAnim mod 2) - 1;
		
		// Draw sprite shit
		draw_text_transformed(	xPos + (lengthdir_x(_scWidth, imageAngle) + lengthdir_x(_scHeight, imageAngle - 90)),
								yPos + (lengthdir_y(_scWidth, imageAngle) + lengthdir_y(_scHeight, imageAngle - 90)),
								string_upper(_basicKey), xScale, yScale, imageAngle);
	};
	// Bye bye
	drawReset();
	
// it's from gamepad
} else {
	show_debug_message(_basicKey);
	// Draw the gamepad key
	draw_sprite_ext(global._gamepadSprite[? _basicKey], _keyAnim, xPos, yPos, xScale, yScale, imageAngle, imageBlend, imageAlpha);
};

};

function keybindDraw(xPos, yPos, plrId, keyId, xScale, yScale, imageAngle, imageBlend, imageAlpha) {

// Get keybind ID set
var keyArray = keybindGetVariable(plrId, keyId);

// What was last used type? keyboard or gamepad?
if (global.keybindLastType == "keyboard") {
	
	return keyDirectDraw(xPos, yPos, keyArray[keybindType.keyboard], xScale, yScale, imageAngle, imageBlend, imageAlpha);
} else {
	
	return keyDirectDraw(xPos, yPos, keyArray[keybindType.gamepad], xScale, yScale, imageAngle, imageBlend, imageAlpha);
};

};

function platformDraw(xPos, yPos, platformWidth) {

// Red color for debug mode
draw_set_color(c_red);
// Get platform sprite
var plrWidth = sprite_get_width(sprite_index);
var plrHeight = sprite_get_height(sprite_index);

var middleTotal = platformWidth - (plrWidth * 2);

// Left part width to draw
var leftPartW = min(floor(platformWidth / 2), plrWidth);
// Right part width
var rightPartW = min(ceil(platformWidth / 2), plrWidth);

// Draw first
draw_sprite_part(sprite_index, 0, 0, 0, leftPartW, plrHeight, xPos, yPos);
//draw_rectangle(xPos, yPos, (xPos + leftPartW) - 1, (yPos + plrHeight) - 1, true);
// Sprite width is more than 2 times tile size
if (middleTotal > 0) {
	
	var middleUnit = floor(middleTotal / TILE_SIZE);
	var middleExtra = middleTotal - (middleUnit * TILE_SIZE);
	// Draw middle
	for (var i = 0; i < middleUnit; i++) {
		
		// Draw middle part in position
		draw_sprite(sprite_index, 1, (xPos + TILE_SIZE) + (TILE_SIZE * i), yPos);
	};
	
	// Draw middle last part in position
	if (middleExtra > 0) {
		draw_sprite_part(sprite_index, 1, 0, 0, middleExtra, sprite_height,
					(xPos + TILE_SIZE) + (TILE_SIZE * middleUnit),
					yPos); };
};
// Right part X position
var rightPartX = (xPos + platformWidth) - rightPartW;
// Draw first
draw_sprite_part(sprite_index, 2, plrWidth - rightPartW, 0, rightPartW, plrHeight, rightPartX, yPos);
//draw_rectangle(rightPartX, yPos, (rightPartX + rightPartW) - 1, (yPos + plrHeight) - 1, true);

};

/// @description Set custom blend
function blendShSet(colorTo, doAlphaBlend = false) {

// Activate this shit please
shader_set(sh_blend);
shader_set_uniform_f(shader_get_uniform(sh_blend, "color"),
					color_get_red(colorTo) / 255,
					color_get_green(colorTo) / 255,
					color_get_blue(colorTo) / 255);

shader_set_uniform_f(shader_get_uniform(sh_blend, "alphaBlend"), real(doAlphaBlend));

};

/// @description Set custom blend
function hurtShSet(fadeValue, colorTo, doAlphaBlend = false) {

// Activate this shit please
shader_set(sh_hurt);
	// Do the pop effect
	shader_set_uniform_f(shader_get_uniform(sh_hurt, "fadeValue"), fadeValue);
	// Color too
	shader_set_uniform_f(shader_get_uniform(sh_hurt, "color"),
						color_get_red(colorTo) / 255,
						color_get_green(colorTo) / 255,
						color_get_blue(colorTo) / 255);

shader_set_uniform_f(shader_get_uniform(sh_hurt, "alphaBlend"), real(doAlphaBlend));

};

/// @description Looks good.
function blendShReset() { shader_reset(); };