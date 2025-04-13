
/// @description Returns if the game is running via the IDE or if it's compiled
function game_is_compiled() {

// Is the game being launched via runner.exe? (result inverted).
return 1-sign(string_pos("Runner.exe", parameter_string(0)));

};

/// @description Returns a value from -1 to 1
function sinBaseInverval(framesToLoop, constV = currentFrame()) {

// Adjust for looping and send back value
return sin((constV / framesToLoop) * pi);

};

/// @description Returns a value from -1 to 1
function cosBaseInverval(framesToLoop, constV = currentFrame()) {

// Adjust for looping and send back value
return cos((constV / framesToLoop) * pi);

};

/// @description Returns a value from 0 to 1, using sin for animations
function sinInverval(framesToLoop, constV = currentFrame()) {

// Adjust for looping and send back value
return 0.5 + (sinBaseInverval(framesToLoop, constV) * 0.5);

};

/// @description Returns a value from 0 to 1, using cos for animations
function cosInverval(framesToLoop, constV = currentFrame()) {

// Adjust for looping and send back value
return 1 + (cosBaseInverval(framesToLoop, constV) * 0.5);

};

/// @description Modifies a value to adapt to frame delay
function gameModValue(value = 1) { return value; };

/// @description A translation movement, combined with angle, returns X
function vector2XAngled(_xPos, _yPos, _angle) {

return lengthdir_x(_xPos, _angle) + lengthdir_x(_yPos, _angle - 90);

};

/// @description A translation movement, combined with angle, returns Y
function vector2YAngled(_xPos, _yPos, _angle) {

return lengthdir_y(_xPos, _angle) + lengthdir_y(_yPos, _angle - 90);

};

/// @description Maps a number from one range to another
/// @param {real} value
/// @param {real} cMin
/// @param {real} cMax
/// @param {real} newMin
/// @param {real} newMax
function remap(value, cMin, cMax, newMin, newMax) {

// Get total value
var total = cMax - cMin;
// Take out min value and divide by total
var percent = (value - cMin) / total;
// New value my man
var new_val = lerp(newMin, newMax, percent);

return new_val;

};

/// @description Create a more natural shaking effect
function randomShaking(value) {

return (1 - random(2)) * value;

};

/// @description Maps a number from one range to another, without bypassing limits
/// @param {real} value
/// @param {real} cMin
/// @param {real} cMax
/// @param {real} newMin
/// @param {real} newMax
function remapClamp(value, cMin, cMax, newMin, newMax) {

// Get the min and max
var _realMin = newMin, _realMax = newMax;
// Min is max
if (_realMin > _realMax) { _realMin = newMax; _realMax = newMin; };

return clamp(remap(value, cMin, cMax, newMin, newMax), _realMin, _realMax);

};

/// @description Moves object to a certain goal, does not modify internal speeds
/// @param {real} goalX
/// @param {real} goalY
/// @param {real} spdV
function moveToPoint(goalX, goalY, spdV, ins = id) {

// Get direction to it
var _dirTo = point_direction(ins.x, ins.y, goalX, goalY);
// And approach to it
ins.x = approachValue(ins.x, goalX, abs(lengthdir_x(spdV, _dirTo)));
ins.y = approachValue(ins.y, goalY, abs(lengthdir_y(spdV, _dirTo)));

// Reached that
return ((ins.x == goalX) && (ins.y == goalY));

};

/// @description Obtain a frame counter from seconds value
/// @param {real} seconds
function timerGet(seconds) {

// Multiply the game speed in frames by the seconds value
return game_get_speed(gamespeed_fps) * seconds;

};

/// @description Convert a bool to string keeping the meaning (instead of 1 or 0)
/// @param {bool} boolValue
function boolToString(boolValue) {

// If it's true or false
if (boolValue) { return "true" } else { return "false"; };

};

/// @description Convert a angle to a limit from 0 - 360
function angle_1to360(angle) {

var olAngle = angle;

// Converts angle to range -360 + 360
angle = (angle % 360) + (angle - (floor(abs(angle)) * sign(angle)));

// More than 0
if (angle > 0) {
	// Return the normal angle
	return angle;
} else {
	// Add 360 to this shit
	return angle + 360;
};

};

/// @description Verify if the angle is in a range
/// @param {real} rangeMin
/// @param {real} rangeMax
/// @param {real} angle
function angleInRange(rangeMin, rangeMax, angle) {

// Normalize angles to be 1-360 degrees
angle		 = angle_1to360(angle);
rangeMin	 = angle_1to360(rangeMin);
rangeMax	 = angle_1to360(rangeMax);

// It's a normal range
if (rangeMin < rangeMax) { return rangeMin <= angle && angle <= rangeMax; };

// It's inverted
return rangeMin <= angle || angle <= rangeMax;

};

/// @param {string} string String to compare
/// @description Verify if given string can be converted into real
function isReal(_string){

// Set variables
var _nozero_string, _return;

// First, delete all zeros
_nozero_string = string_replace(_string, ".", ""); // This replaces only the first "." and left the rest due to incompatibility
// Delete first "-"
if (string_char_at(_nozero_string, 1) == "-") { _nozero_string = string_copy(_nozero_string, 2, string_length(_nozero_string) - 1); };

// Then compare it with only numbers string
_return = (_nozero_string == string_digits(_nozero_string));

// If string is equal to "", return false
if (_nozero_string == "") _return = false;

// Return result
return _return;

};


function accPV() {

// Return accuracy pixel value
return 1;//G_ACC_V;//1 / G_ACC;

};

/// @param ins
/// @param x
/// @param y
/// @param obj
function instance_place_other(ins, xPos, yPos, obj) {

// Collision bool
var colBool = noone;

// If instance place meeting
with (ins) { colBool = instance_place(xPos, yPos, obj); };

return colBool;

};

function place_meeting_other(ins, xPos, yPos, obj) {

// Collision bool
var colBool = false;

// If instance place meeting
with (ins) { colBool = place_meeting(xPos, yPos, obj); };

return colBool;

};

/// @param x
/// @param y
/// @param collision_array
function place_meeting_multiple(xPos, yPos, colArray) {

// Collision bool
var colBool = false;

// With all collisions
for (var i = 0; i < array_length(colArray); i++) {
	
	// Find in this place
	colBool = place_meeting(xPos, yPos, colArray[i]);
	
	// If found collision
	if (colBool) break;
};

// Return if found or not
return colBool;

};

/// @description Returns the current frame since the game started
function currentFrame() {

// Calculate the current frame (current_time is on milliseconds, so multiply by 1000)
return floor((current_time / 1000) * game_get_speed(gamespeed_fps));

};

/// @description Returns the current frame since the game started without rounding it
function currentFrameAccurate() {

// Calculate the current frame (current_time is on milliseconds, so multiply by 1000) and avoid rounding it
return (current_time / 1000) * game_get_speed(gamespeed_fps);

};

/// @description Approach a real value to another with a shift
/// @param {real} value
/// @param {real} to
/// @param {real} shift
function approachValue(value, to, shift) {

// If we need to reduce value
	 if (value > to) { return max(value - shift, to); }
// Otherwise, we need to increase it
else if (value < to) { return min(value + shift, to); }
// Value is already the same
else				 { return to; };

};

/// @description Fill a string with a character
/// @param {string} _string			 Original string
/// @param {real} _fill_digits		 Max length to fill with
/// @param {string} _digit			 Digit to fill the string with
/// @param {bool} _left_to_right	 From what direction to fill
function stringFill(_string, _fill_digits, _digit, _left_to_right = true) {

// Get string
var returnString, filledString = "", digitIndex = 0;

// Case that string isn't a string
_string = string(_string);
_digit = string(_digit);

// Repeat to reach all
repeat (max(_fill_digits - string_length(_string), 0)) {
	
	// Add to filled string
	filledString += string_copy(_digit, digitIndex + 1, 1);
	
	// Add to digit index
	digitIndex++;
	digitIndex = digitIndex mod string_length(_digit);
};


// If left to right fill
if (_left_to_right) { returnString = filledString + _string; } else { returnString = _string + filledString; };

// Return end string
return returnString;

};

/// @description Uses string format, only using necesary spaces
function stringFormatDecimal(_number, _decimalCount, _deleteZeros = true) {

// adjust for this
var _mainNumber = string_format(_number, string_length(string(floor(abs(_number)))), _decimalCount);
// delete zeros?
if (_deleteZeros) {
	// do a main check
	for (var i = string_length(_mainNumber); i >= 1; i--) {
		var _charIndex = string_char_at(_mainNumber, i);
		
		// point? delete and break
		if (_charIndex == ".") { _mainNumber = string_delete(_mainNumber, i, 1); break; }
		// is a zero? delete and continue
		else if (_charIndex == "0") { _mainNumber = string_delete(_mainNumber, i, 1); }
		// nope
		else { break; };
	};
};

return _mainNumber;

};


function spriteAnim(spriteIndex = sprite_index, imageSpeed = 1, fFactor = currentFrame()) {


var spriteSpeed = sprite_get_speed(spriteIndex);
var spriteDivisor = (room_speed / spriteSpeed) / imageSpeed;

return (((fFactor / spriteDivisor)) mod (sprite_get_number(spriteIndex)));

};

function spriteLength(spriteIndex = sprite_index) {

var spriteSpeed = sprite_get_speed(spriteIndex);
var spriteLengthInFrames = (room_speed / spriteSpeed) * (sprite_get_number(spriteIndex) - 1);

return spriteLengthInFrames;

};

/// @description Read an animation curve if channel exists, if doesn't returns a default value
function animcurveRead(curveId, channelId, value, defaultValue) {

// Temp variables
var aniID, aniChannel, returnValue;
aniID = animcurve_get(curveId);

// Get channel from asked animation curve
aniChannel = animcurve_get_channel(aniID, string(channelId));

// If channel exists
if (aniChannel != -1) {
	
	return animcurve_channel_evaluate(aniChannel, value);
};

return defaultValue;


// Return value
return returnValue;

};

/// @description Get middle point of the sprite in X of an object
function getMiddlePointX(middlePointIns = id) {

// Return middle point
return (middlePointIns.x - middlePointIns.sprite_xoffset) + (middlePointIns.sprite_width / 2);

};

/// @description Get middle point of the sprite in Y of an object
function getMiddlePointY(middlePointIns = id) {

// Return middle point
return (middlePointIns.y - middlePointIns.sprite_yoffset) + (middlePointIns.sprite_height / 2);

};

/// @description Get the last parent of given object
function commonParent(object) {

// Get first parent
var parentInstance = object, lastParent = object;

// While it exists
while (parentInstance != -100 && parentInstance != -1) {
	
	// last parent obtained
	lastParent = parentInstance;
	// Get parent
	parentInstance = object_get_parent(object);
	// Found the same
	if (parentInstance == -100/*lastParent == parentInstance*/) { break; } else { object = parentInstance; };
};
// Return to last parent
parentInstance = lastParent;

// Return parent
return parentInstance;

};

/// @description Rounds a decimal, so you can have 1.43252 to 1.4
function roundDecimal(number, roundLength) {

// Now adjust this shit off
var multiplyConst = power(10, roundLength);

// Return the final number
return round(number * multiplyConst) / multiplyConst;

};

/// @description Negative, floor; 0, round; positive, ceil
function roundSign(number, signNumber) {

// Now check
		 if (signNumber > 0) { return ceil(number); }
else	 if (signNumber == 0) { return round(number); };
else	 if (signNumber < 0) { return floor(number); };

};

function chooseProbability() {

// Generate the random number
randomize();
var _randomNum = random(100), _choosenOne = 0, _choosenOneNum = 101;
show_debug_message(_randomNum)

// Loop for it
for (var i = 0; i < argument_count; i++) {
	
	// We reached it
	if (argument[i][1] >= _randomNum && argument[i][1] <= _choosenOneNum) {
		
		// Last choosen num is the same
		if (_choosenOneNum == argument[i][1]) {
			
			// Choose between
			_choosenOne = choose(i, _choosenOne);
		} else {
			
			// We choosed it
			_choosenOneNum = argument[i][1];
			_choosenOne = i;
		};
	};
};

return argument[_choosenOne][0];

};


/// @description Get bounds A and B from a set of values
/// @param {array} lerpValues Set of values to lerp from
/// @param {real} lerpValue Shift of combination, from 0 to 1
function multiLerpGetBounds(lerpValues, lerpValue) {

// Adjust coordinates
var vLBound, vRBound, vSlice = 1 / max(array_length(lerpValues) - 1, 1);
// Now set other things
var vId = min(floor(lerpValue / vSlice), array_length(lerpValues) - 1);
// Get bounds of lerp
vLBound = lerpValues[vId];
vRBound = lerpValues[(vId + 1) mod array_length(lerpValues)];
// Return this shit
return [vLBound, vRBound];

};

/// @description Get lerp of various values
/// @param {array} lerpValues Set of values to lerp from
/// @param {real} lerpValue Shift of combination, from 0 to 1
function multiLerp(lerpValues, lerpValue) {

// Adjust coordinates
var vBounds, vSlice = 1 / max(array_length(lerpValues) - 1, 1);
// Get bounds of this shit
vBounds = multiLerpGetBounds(lerpValues, lerpValue);
// Now set other things
var vV = (lerpValue mod vSlice) / vSlice;
// And set color blend
return lerp(vBounds[0], vBounds[1], vV);

};

/// @description Let just clear the list my man
/// @param {Id.DsList} listId DsList to clear data
function ds_list_delete_all(listId) {

// Delete all list content inside
repeat (ds_list_size(listId)) {
	// Just delete first item, anyways it will always be the first
	ds_list_delete(listId, 0);
};
// Now clear list to ensure
ds_list_clear(listId);

};

/// @description Get instance variable and if it doesn't exists, return a default value
function insGetVar(insId, varName, defaultValue) {

// Only if the variable exists
if (variable_instance_exists(insId, varName)) { return variable_instance_get(insId, varName); };
return defaultValue;

};


/// @description Convert an color to an 1d array containing color data from 0 to 1
function colorToFloatArray(color) {

// Return the color reducted to an array of 0 from 1
return [
	color_get_red(color) / 255,
	color_get_green(color) / 255,
	color_get_blue(color) / 255
];

};

/// @description Convert an 1d array containing color data from 0 to 1 to an color
function floatArrayToColor(colorArray) {

// Create the new color
return make_color_rgb(colorArray[0] * 255, colorArray[1] * 255, colorArray[2] * 255);

};

/// @description Avoids a value from overpasssing min and max values by return to the opposite
function scrollLimit(scrollValue, minV, maxV) {

var _rV = scrollValue;

// In case of top, reduce it
while (_rV > maxV) { _rV -= (maxV - minV); };
// And bottom case
while (_rV < minV) { _rV += (maxV - minV); };

return _rV;

};

/// @description Avoids a value from overpassing min and max values by setting back to the opposite
function scrollBack(scrollValue, minV, maxV) {

var _rV = scrollValue;

// In case of top, go back on it
if (_rV > maxV) { _rV = minV; };
// And bottom case
if (_rV < minV) { _rV = maxV; };

return _rV;

};

/// @description Get if the value, normaly a position, is snapped in a imaginary grid
function snapCheck(snapValue, gridS = TILE_SIZE, gridOff = 0) {

// Get the position modified
var _snapMod;
_snapMod = (snapValue - gridOff) / gridS;

// Check if it's snapped
return (_snapMod == floor(_snapMod));

};

/// @description Get the snap check in 2D value
function snap2DCheck(snapX, snapY, gridSX = TILE_SIZE, gridSY = TILE_SIZE, gridOffX = 0, gridOffY = 0) {

// Check if the 2D position is correctly snapped into the grid
return snapCheck(snapX, gridSX, gridOffX) && snapCheck(snapY, gridSY, gridOffY);

};