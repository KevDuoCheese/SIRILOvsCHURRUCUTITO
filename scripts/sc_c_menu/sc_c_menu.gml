
global.cMenuHandler = noone;
global.cMenuSurfWindow = -1;

// if keeps pushing a pressing key
global.cMenuPushWaitTimerMax = timerGet(0.45);
global.cMenuPushWaitTimer = global.cMenuPushWaitTimerMax;
// to keep on
global.cMenuPushAddTimerMax = timerGet(0.2);
global.cMenuPushAddTimerMin = timerGet(0.05);
// how much it decays till reaching min timer
global.cMenuPushAddTimerDecay = 0.8;
// this is dyamic
global.cMenuPushAddTimer = global.cMenuPushAddTimerMax;
global.cMenuPushAddTimerLast = global.cMenuPushAddTimer;

// If its pushing something
global.cMenuPushActive = "";
global.cMenuPushActiveLast = "";


/// @description This should run in control object
function cMenuBeginStep() {

var _cMenuPushReset = false;

// its pushing?
if (global.cMenuPushActive != "") {
	// different to last
	if (global.cMenuPushActive != global.cMenuPushActiveLast) {
		// reset all of these
		_cMenuPushReset = true;
	};
	// set it to last
	global.cMenuPushActiveLast = global.cMenuPushActive;
	// resrt it
	global.cMenuPushActive = "";
} else {
	// reset all of these
	_cMenuPushReset = true;
};
// now if do
if (_cMenuPushReset) {
	// reset all of these
	global.cMenuPushWaitTimer = global.cMenuPushWaitTimerMax;
	global.cMenuPushAddTimer = global.cMenuPushAddTimerMax;
	// and reset this tho
	global.cMenuPushAddTimerLast = global.cMenuPushAddTimer;
};

};

/// @description If player keeps pushing then it goes on and on
function cMenuKeybindPush(keyId, plrId = 0) {

// Return value
var _rValue = 0;

// If pushes
_rValue = keybindCheckPressed(keyId, plrId);
// Keeps on 0?
if ((_rValue == 0) && (keybindCheck(keyId, plrId) != 0)) {
	// yep it is
	global.cMenuPushActive = keyId;
	// Wait for first timer
	if (global.cMenuPushWaitTimer > 0) { global.cMenuPushWaitTimer--; } else {
		// then loop for second
		if (global.cMenuPushAddTimer > 0) { global.cMenuPushAddTimer--; } else {
			// return what we wanted
			_rValue = keybindCheck(keyId, plrId);
			
			// reset timer
			global.cMenuPushAddTimer = max(global.cMenuPushAddTimerLast * global.cMenuPushAddTimerDecay, global.cMenuPushAddTimerMin);
			global.cMenuPushAddTimerLast = global.cMenuPushAddTimer;
		};
	};
};

// reutrn that
return _rValue;

};

/// @description Default Move H keys behaviour
function cMenuGlobalMoveH(rK = "right", lK = "left") {

return cMenuKeybindPush(rK) - cMenuKeybindPush(lK);

};

/// @description Default Move V keys behaviour
function cMenuGlobalMoveV(dK = "down", uK = "up") {

return cMenuKeybindPush(dK) - cMenuKeybindPush(uK);

};



function cMenuCreate(_customPreset = "general") {

// Set myself as the handler
global.cMenuHandler = id;

// Options will be saved in maps, instead of depths like game menu ones, and will be a 2D array, [ option, lerp ]
option = ds_map_create();
// Adjust option limits
optionMax = 0;
optionMin = 0;

// And save windows on maps too
windowsMap = ds_map_create();
// In order to draw windows correctly
windowsDepth = [ ];
// Start main
cMenuOptionNew("main", 0, 1);

// Start on title screen, works with depths
menuDepth = [ "main" ];
// "Real depth" or something like that
menuDepthReal = 0;

// Get height and this bullshit
drawPreset(_customPreset);
optionHeight = max(9, string_height("W._l")) + 2;


// For TP and shit
transitionIns = noone;
// To hold writer
writerIns = noone;

};

/// @description Draw options without making so much disorder
function cMenuWindowOptionDepthDraw(optionArray, depthId, yPos = 8, xPos = 12, langSet = true, opSColor = COLOR_FUCHSIA, objHandler = global.cMenuHandler) {

// Adjust option draw menu
cMenuOptionDraw(xPos, yPos, optionArray,
				cMenuOptionGet(depthId, objHandler),
				cMenuOptionGetLerp(depthId, objHandler),
				objHandler.optionHeight,
				langSet, opSColor);

};

/// @description Draw options in this shit
function cMenuOptionDraw(xPos, yPos, optionArray, selectedOption, selectedOptionLerp, opHSep, langSet = true, opSColor = COLOR_FUCHSIA) {

// Adjust option position
var optionX, optionY, defCol = draw_get_color();
optionX = xPos;
optionY = yPos;
// Draw the weird index
draw_sprite(sp_index, spriteAnim(sp_index), optionX, (optionY + 1) + (selectedOptionLerp * opHSep))
// Loop to draw that shit off
for (var i = 0; i < array_length(optionArray); i++) {
	// Change color depending on option
	if (selectedOption == i) { draw_set_color(opSColor); }
	else { draw_set_color(defCol); };
	
	var toDrawText = langSet ? languageGet(optionArray[i]) : optionArray[i];
	
	// Draw da text
	draw_text_shadow(optionX + 10, optionY, toDrawText);
	
	// Next option
	optionY += opHSep;
};

};

/// @description I'm tired of this shit dude x2
function cMenuWindowGetHeight(optionsNumber, extraSep = 16) {

// Return this shit
return (global.cMenuHandler.optionHeight * optionsNumber) + extraSep;

};

/// @description This will get the max width of all the options
function cMenuWindowGetWidth(_optionArray, usesLang = false, extraSep = 32) {

var _minW = 0;

// loop for each
for (var i = 0; i < array_length(_optionArray); i++) {
	// get the thing
	_minW = max(_minW, string_width(usesLang ? languageGet(_optionArray[i]) : _optionArray[i]));
};

// Return this shit
return _minW + extraSep;

};

/// @description Add a new option value to list
function cMenuOptionNew(optionId, startValue, lerpValue = 0.25) {

// Yup, set this directly
global.cMenuHandler.option[? optionId] = [ startValue, startValue, lerpValue ];

};

/// @description Kill the option
function cMenuOptionDelete(optionId) {

// Does exists?
if (ds_map_exists(global.cMenuHandler.option, optionId)) {
	// Delete from existance
	ds_map_delete(global.cMenuHandler.option, optionId);
};

};

/// @description Get option main value
function cMenuOptionGet(optionId, ins = global.cMenuHandler) {

// Return the fucking value
return ins.option[? optionId][0];

};

/// @description Get option lerp value
function cMenuOptionGetLerp(optionId, ins = global.cMenuHandler) {

// Return the fucking value
return ins.option[? optionId][1];

};

/// @description Set to a new value
function cMenuOptionSet(optionId, newValue) {

// Adjust option
global.cMenuHandler.option[? optionId][0] = newValue;

};

/// @description Set to a new value, and set lerp value too
function cMenuOptionSetForced(optionId, newValue) {

// Adjust option
global.cMenuHandler.option[? optionId][0] = newValue;
// And lerp
global.cMenuHandler.option[? optionId][1] = newValue;

};

/// @description Set option lerp move
function cMenuOptionSetLerpMove(optionId, newLerp, ins = global.cMenuHandler) {

// Return the fucking value
ins.option[? optionId][2] = newLerp;

};

/// @description Control all options lerp values
function cMenuOptionLerpControl() {

// Get first values
var _keyId = ds_map_find_first(global.cMenuHandler.option);
// Visit everyone
repeat (ds_map_size(global.cMenuHandler.option)) {
	
	// Set lerp values
	global.cMenuHandler.option[? _keyId][1] = lerp(global.cMenuHandler.option[? _keyId][1], global.cMenuHandler.option[? _keyId][0], global.cMenuHandler.option[? _keyId][2]);
	
	// Find next key
	_keyId = ds_map_find_next(global.cMenuHandler.option, _keyId);
};

};

function cMenuWindowDrawItems(wId, _x = TILE_SIZE, _y = TILE_SIZE * 0.75) {

// Adjust selecting option
var _selectedOption, _selectedOptionLerp, _opHSep;
_selectedOption = cMenuOptionGet(wId);
_selectedOptionLerp = cMenuOptionGetLerp(wId);
_opHSep = global.cMenuHandler.optionHeight;
// Welp, you know
var _optionArray = global.cMenuHandler.itemArray;
// Adjust option position
var _optionX, _optionY, _defCol = c_white, _opSColor = c_white;
_optionX = TILE_SIZE;
_optionY = TILE_SIZE * 0.75;
// Draw the weird index
draw_sprite(sp_index, spriteAnim(sp_index), _optionX, (_optionY + 1) + (_selectedOptionLerp * _opHSep));
// Loop to draw that shit off
for (var i = 0; i < global.cMenuHandler.itemMaxOption; i++) {
	// Change color depending on option
	if (_selectedOption == i) { draw_set_color(_opSColor); }
	else { draw_set_color(_defCol); };
	
	// Reach this
	if (i < array_length(_optionArray)) {
		
		var _toDrawText = languageGet(_optionArray[i][0]);
		
		// Draw da text
		draw_text_shadow(_optionX + 10, _optionY, _toDrawText);
		// Draw the icon on place
		draw_sprite(sp_item_type, _optionArray[i][1], _optionX + (TILE_SIZE * 9), _optionY);
	} else {
		
		// Draw line
		draw_sprite_stretched_ext(sp_ui_item, 0, _optionX + 10, _optionY, image_xscale - 10 - (_optionX + 10), sprite_get_height(sp_ui_item), c_white, 0.5);
	};
	
	// Next option
	_optionY += _opHSep;
};

};

/// @description Draw the designed character portrait on the full window
function cMenuWindowDrawCharSavePortrait(_charId) {

// Get the save file thing
var _characterSaveData = structRead(global.saveBackup, "characterData", -1);
// Get character ID data
var _statData = structRead(_characterSaveData, _charId, -1);


var _inSizeW, _inSizeH;
_inSizeW = image_xscale - 6;
_inSizeH = image_yscale - 6;
// Draw the portrait backgrounf
draw_sprite_stretched(sp_rounded_box_1, 0, 3, 3, _inSizeW, _inSizeH);
// And draw on it
gpu_set_colorwriteenable(true, true, true, false);
draw_sprite_stretched(structRead(_statData, "portrait", sp_mainpo_noone), 0, 3, 3, _inSizeW, _inSizeH);
gpu_set_colorwriteenable(true, true, true, true);

};

/// @description Draw a basic stat data of character (This function takes on count the portrait)
function cMenuWindowDrawCharSaveStat(_charId, _sepX = 5, _sepY = 5) {

// Get the save file thing
var _characterSaveData = structRead(global.saveBackup, "characterData", -1);
// Get character ID data
var _statData = structRead(_characterSaveData, _charId, -1);

// Obtain the data
var _charName = structExists(_statData, "name") ? ("\"/cY/s5" + _statData.name + "/cD/s0\"") : languageGet("save_name_empty");
// THe level
var _levelThingy = structExists(_statData, "level") ? string(structRead(_statData, "level" , 0) + 1) : "--";
var _bloodLevelThingy = structExists(_statData, "blood_level") ? string(structRead(_statData, "blood_level" , 0)) : "--";


var _optionX = TILE_SIZE;
var _optionY = TILE_SIZE * 0.75;
var _optionHeight = global.cMenuHandler.optionHeight;

// Draw the name
drawTextSpecial(70, _optionY, _charName);
// Draw the level
drawTextSpecial(70, _optionY + (_optionHeight * 2), "/cV" + languageGet("level") + "/cD " + _levelThingy);
drawTextSpecial(70, _optionY + (_optionHeight * 3), "/cF" + languageGet("blood_level") + "/cD " + _bloodLevelThingy);

_optionY = 65;

// And the EXP
drawTextSpecial(_optionX, _optionY, languageGet("exp") + ": /cV" + string(structRead(_statData, "expValue" , 0)));
drawTextSpecial(_optionX, _optionY + (_optionHeight * 1), languageGet("blood") + ": /cF" + string(structRead(_statData, "blood" , 0)));

// Get weapon and armor name
var _weaponName, _headName, _torsoName, _feetName, _otherName,
	_weaponExtra = 0, _headExtra = 0, _torsoExtra = 0, _feetExtra = 0, _otherExtra = 0;

_weaponName = structRead(_statData, "weapon", "");
// Load all armor
_headName	 = structRead(_statData, "head", "");
_torsoName	 = structRead(_statData, "torso", "");
_feetName	 = structRead(_statData, "feet", "");
_otherName	 = structRead(_statData, "other", "");


// Now get name
if (_weaponName == "") { _weaponName = languageGet("stat_empty"); } else { _weaponName = itemGetName(_weaponName); };
// Same with armor name
if (_headName == "")	 { _headName = languageGet("stat_empty"); }		 else { _headName = itemGetName(_headName); };
if (_torsoName == "")	 { _torsoName = languageGet("stat_empty"); }	 else { _torsoName = itemGetName(_torsoName); };
if (_feetName == "")	 { _feetName = languageGet("stat_empty"); }		 else { _feetName = itemGetName(_feetName); };
if (_otherName == "")	 { _otherName = languageGet("stat_empty"); }	 else { _otherName = itemGetName(_otherName); };

// Set weapon in it
draw_text_shadow(_optionX, _optionY + (_optionHeight * 3), languageGet("weapon") + ": " + _weaponName);
// Same with armor
draw_text_shadow(_optionX, _optionY + (_optionHeight * 4), languageGet("a_head")	 + ": " + _headName);
draw_text_shadow(_optionX, _optionY + (_optionHeight * 5), languageGet("a_torso")	 + ": " + _torsoName);
draw_text_shadow(_optionX, _optionY + (_optionHeight * 6), languageGet("a_feet")	 + ": " + _feetName);
draw_text_shadow(_optionX, _optionY + (_optionHeight * 7), languageGet("a_other")	 + ": " + _otherName);

};

/// @description Add window to the map
function cMenuWindowAdd(wId, _x, _y, width, height, wSpr = sp_window_basic, animS = -1, animE = -1, animM = -1, depthLevel = menuDepthReal) {

// Just create it
var windowIns = instance_create_depth(_x, _y, 2, ob_window_ext, {
	sprite_index : wSpr
});
// Adjust it
windowIns.image_xscale = width;
windowIns.image_yscale = height;
windowIns.visible = false;
// And set the animations
windowIns.animOpen	 = animS;
windowIns.animIdle	 = animM;
windowIns.animClose	 = animE;
// For depth shit
windowIns.depthLevel = depthLevel;
windowIns.depthOwner = id;
windowIns.depthId	 = wId;

// Does NOT exists?
if (array_length(global.cMenuHandler.windowsDepth) <= depthLevel) {
	
	// Loop till it
	for (var i = array_length(global.cMenuHandler.windowsDepth); i <= depthLevel; i++) {
		// Set an empty space
		global.cMenuHandler.windowsDepth[i] = [];
	};
};
// Add to position
array_push(global.cMenuHandler.windowsDepth[depthLevel], wId);


// Assign it
global.cMenuHandler.windowsMap[? wId] = windowIns;

// Return it anyways
return windowIns;

};

/// @description Check if window exists
function cMenuWindowExists(wId) {

// And so
return ds_map_exists(global.cMenuHandler.windowsMap, wId) && instance_exists(global.cMenuHandler.windowsMap[? wId]);

};

/// @description Gookbye bye useless window
function cMenuWindowKill(wId) {

// Key exists or not
if (ds_map_exists(global.cMenuHandler.windowsMap, wId) && instance_exists(global.cMenuHandler.windowsMap[? wId])) {
	
	// Kill it
	global.cMenuHandler.windowsMap[? wId].closeTrigger();
};

};

/// @description Execute his fucking draw event
function cMenuWindowDrawGUI(wId) {

// Key exists or not
if (ds_map_exists(global.cMenuHandler.windowsMap, wId) && instance_exists(global.cMenuHandler.windowsMap[? wId])) {
	
	// Execute draw GUI event
	with (global.cMenuHandler.windowsMap[? wId]) { event_perform(ev_draw, ev_gui); };
};

};

/// @description Execute his fucking draw event normally
function cMenuWindowDraw(wId) {

// Key exists or not
if (ds_map_exists(global.cMenuHandler.windowsMap, wId) && instance_exists(global.cMenuHandler.windowsMap[? wId])) {
	
	// Execute draw GUI event
	with (global.cMenuHandler.windowsMap[? wId]) { event_perform(ev_draw, ev_draw_normal); };
};

};

/// @description Change inside window draw function
function cMenuWindowDrawFunction(wId, newFunction) {

// Set function
global.cMenuHandler.windowsMap[? wId].windowInsideDrawFunction = method(global.cMenuHandler.windowsMap[? wId], newFunction);

};

/// @description draw all the windows
function cMenuWindowDrawAll() {

// Da preset
drawPreset("general");

// Visit all depths
for (var i = 0; i < max(array_length(menuDepth), array_length(windowsDepth)); i++) {
	
	// Has enough
	if (array_length(windowsDepth) > i) {
		// Search for windows on this level
		for (var n = 0; n < array_length(windowsDepth[i]); n++) {
			
			// And draw that window
			cMenuWindowDraw(windowsDepth[i][n]);
		};
	};
};

};

/// @description draw all the windows
function cMenuWindowDrawAllGUI() {

// Da preset
drawPreset("general");

// Visit all depths
for (var i = 0; i < max(array_length(menuDepth), array_length(windowsDepth)); i++) {
	
	// Has enough
	if (array_length(windowsDepth) > i) {
		// Search for windows on this level
		for (var n = 0; n < array_length(windowsDepth[i]); n++) {
			
			// And draw that window
			cMenuWindowDrawGUI(windowsDepth[i][n]);
		};
	};
	// Has enough
	if (array_length(menuDepth) > i) {
		// Get this depth ID
		var _depthId = menuDepth[i];
		
	};
};

};

/// @description Get menu window ID 
function cMenuWindowId(wId) {

return global.cMenuHandler.windowsMap[? wId];

};

/// @description Get menu window ID X
function cMenuWindowX(wId) {

return global.cMenuHandler.windowsMap[? wId].x;

};

/// @description Get menu window ID Y
function cMenuWindowY(wId) {

return global.cMenuHandler.windowsMap[? wId].y;

};

/// @description Get menu window ID width
function cMenuWindowWidth(wId) {

return global.cMenuHandler.windowsMap[? wId].image_xscale;

};

/// @description Get menu window ID height
function cMenuWindowHeight(wId) {

return global.cMenuHandler.windowsMap[? wId].image_yscale;

};

/// @description Move a certain depth option
function cMenuOptionMoveDepth(depthValue, moveConst, clampV = false, useSound = so_option) {

// Get last value of this
var lastValue;
lastValue = cMenuOptionGet(depthValue);
// Change the value dude
cMenuOptionSet(depthValue, lastValue + moveConst);
// Does clamp?
if (clampV) {
	// Set it
	cMenuOptionSet(depthValue, clamp(cMenuOptionGet(depthValue), global.cMenuHandler.optionMin, global.cMenuHandler.optionMax));
} else {
	// Limit on borders
	if (cMenuOptionGet(depthValue) > global.cMenuHandler.optionMax) { cMenuOptionSet(depthValue, global.cMenuHandler.optionMin); };
	if (cMenuOptionGet(depthValue) < global.cMenuHandler.optionMin) { cMenuOptionSet(depthValue, global.cMenuHandler.optionMax); };
};

// Changed shit
if (lastValue != cMenuOptionGet(depthValue)) {
	
	// Play change sound
	audio_replay_sound(useSound, 1, false);
	
	return true;
};

return false;

};

/// @description Move this depth shit
function cMenuOptionMove(moveConst, clampV = false, useSound = so_option) {

// Move it
return cMenuOptionMoveDepth(global.cMenuHandler.menuDepth[menuDepthReal], moveConst, clampV, useSound);

};

/// @description Just to not copy 2 lines of code
function cMenuOptionLimit(minL, maxL) {

// Adjust this
global.cMenuHandler.optionMin = minL;
global.cMenuHandler.optionMax = maxL;

};

/// @description Get da depth my man
function cMenuDepthGet(depthValue = global.cMenuHandler.menuDepthReal) {

// Is enough
if (global.cMenuHandler.menuDepthReal >= depthValue) {
	
	// Return this
	return global.cMenuHandler.menuDepth[depthValue];
};

return -1;

};

/// @description Return depth level
function cMenuDepthLevel() {

return global.cMenuHandler.menuDepthReal;

};

/// @description Asked depth exists dude
function cMenuDepthExists(depthValue) {

// Asked depth exists
return global.cMenuHandler.menuDepthReal >= depthValue;

};

/// @description Add a new depth
function cMenuDepthAdd(newDepthId, newOptionValue, lerpValue = 0.25) {

// Increase depth thing
global.cMenuHandler.menuDepthReal++;
// Add menu option
cMenuOptionNew(newDepthId, newOptionValue, lerpValue);
// And depth ID
global.cMenuHandler.menuDepth[global.cMenuHandler.menuDepthReal] = newDepthId;

};

/// @description Take out the new depth if there is one
function cMenuDepthDecrease() {

// There still more depth
if (global.cMenuHandler.menuDepthReal > 0) {
	
	// Decrease most recent of both
	//cMenuOptionDelete(menuDepth[menuDepthReal]);
	array_delete(global.cMenuHandler.menuDepth, array_length(global.cMenuHandler.menuDepth) - 1, 1);
	
	// Goodbye shit
	global.cMenuHandler.menuDepthReal--;
};

};

#region Keybinds adjustments

/// @description Sets a local array to some value containing all configurable keybinds and ajustments
function menuKeybindsConfigArray() {

configKeybinds = [
	
	{
		section_name : "general",
		keys : [
			
			[ "right",	 "direct", false ],
			[ "left",	 "direct", false ],
			[ "down",	 "direct", false ],
			[ "up",		 "direct", false ],
			
			[ "hmove",	 "stick", false ],
			[ "vmove",	 "stick", false ],
			
			[ "action",	 "direct", false ],
			[ "back",	 "direct", false ],
			[ "menu",	 "direct", true ],
			[ "escape",	 "direct", false ]
		]
	},
	
	{
		section_name : "battle",
		keys : [
			
			[ "battle_inventory_action",	 "direct", true ],
			[ "battle_inventory_back",		 "direct", true ],
			
			[ "battle_jump",	 "direct", true ],
			[ "battle_action",	 "direct", true ],
			[ "battle_dash",	 "direct", true ],
			[ "battle_super",	 "direct", true ]
		]
	},
	
	{
		section_name : "arcade",
		keys : [
			
			[ "gm_key_0",	 "direct", true ],
			[ "gm_key_1",	 "direct", true ],
			[ "gm_key_2",	 "direct", true ],
			[ "gm_key_3",	 "direct", true ],
			[ "gm_key_4",	 "direct", true ],
			
			[ "arcade_retry",	 "direct", true ],
		]
	}
];

};

/// @description Functions for search for a key (like A, ESC, Right Key) and 
function menuKeybindsLoadFunctions() {

/// @description To search an used key in keybind array
cKeybindSearchFor = function (searchKey) {

// Search on it
var _keybindStructNames = struct_get_names(global.keybindArray[0]);
// Search for it
for (var i = 0; i < array_length(configKeybinds); i++) {
	// And get index
	var _keybindIndex = configKeybinds[i].keys;
	// And check for eech one
	for (var n = 0; n < array_length(_keybindIndex); n++) {
		// Get keybind data itself
		var _keyData = keybindGetVariable(0, _keybindIndex[n][0]);
		
		// Search on data
		for (var w = 0; w < array_length(_keyData); w++) {
			
			// Is there?
			if (_keyData[w] == searchKey) { return [ i, n, w ]; };
		};
	};
};

return -1;

};

/// @description Get keyboard, alt, gamepad or g. alt keybind of asked key (Like, action key and keyboard, "Keyboard (Z)")
cKeybindLoadKeyData = function (searchKey, sectionId) {

// get keybind data
var _keybindData = keybindGetVariable(0, searchKey);
// get section data
var _keybindSectionNames = languageGet("cf_keybind_type");
// About section
return _keybindSectionNames[sectionId] + " (/cW" + specialTextGetKeyChar(_keybindData[sectionId]) + "/cD)";

};

};

/// @description Init some variables for item correct function
function cMenuItemInit() {

backpackMenu = [
	
	"item",
	"equip",
	"misc"
];
itemMaxOption = 8;

itemArray = [ ];
// Create a function to update it
itemUpdate = function (backpackId) {
	
	// Clear item array
	array_delete(itemArray, 0, array_length(itemArray));
	// Get thingy
	var _itemList = itemGetList(backpackId);
	// Read it
	for (var i = 0; i < ds_list_size(_itemList); i++) {
		
		var _itemT = itemGetData(_itemList[| i], "item_type", "");
		// Add to it
		array_push(itemArray, [ itemGetName(_itemList[| i]), itemTypeIconFrame((_itemT == "armor") ? itemGetData(_itemList[| i], "armor_type", "") : _itemT) ]);
	};
};
// And execute it
itemUpdate("item");

};

/// @description Creates a window to choose backpack (item, armor, other)
function cMenuItemAddWindowBackpack(_x, _y, lerpValue = 0.25, wSpr = sp_window_basic, animS = -1, animE = -1, animM = -1) {

// Add window
cMenuDepthAdd("backpack", 0, lerpValue);
cMenuWindowAdd("backpack", _x, _y, 90, cMenuWindowGetHeight(array_length(backpackMenu), 24), wSpr, animS, animE);
// Make it draw the entiere backpack menu
cMenuWindowDrawFunction("backpack", function () {
	cMenuWindowOptionDepthDraw(global.cMenuHandler.backpackMenu, "backpack", TILE_SIZE * 0.75, TILE_SIZE, true, c_white);
});

};

/// @description Basic backpack step
function cMenuItemBackpackStep(moveConst, postX, postY, lerpValue = 0.25, wSpr = sp_window_basic, animS = -1, animE = -1, animM = -1) {

// Move the option around
cMenuOptionLimit(0, array_length(backpackMenu) - 1);
cMenuOptionMove(moveConst, false);

// Select backpack
if (keyboard_check_pressed_action("action")) {
	// Play sound
	audio_replay_sound(so_confirm, 1, false);
	// Adjust option
	switch (cMenuOptionGet("backpack")) {
		case 0:
			itemUpdate("item");
			// Next level
			cMenuDepthAdd("item", 0, lerpValue);
			cMenuWindowAdd("item", postX, postY, 180, cMenuWindowGetHeight(itemMaxOption, 24), wSpr, animS, animE, animM);
			cMenuWindowDrawFunction("item", function () { cMenuWindowDrawItems("item"); });
			
			return true;
		break;
				
		case 1:
			itemUpdate("equip");
			// Next level
			cMenuDepthAdd("equip", 0, lerpValue);
			cMenuWindowAdd("equip", postX, postY, 180, cMenuWindowGetHeight(itemMaxOption, 24), wSpr, animS, animE, animM);
			cMenuWindowDrawFunction("equip", function () { cMenuWindowDrawItems("equip"); });
			
			return true;
		break;
				
		case 2:
			itemUpdate("misc");
			// Next level
			cMenuDepthAdd("misc", 0, lerpValue);
			cMenuWindowAdd("misc", postX, postY, 180, cMenuWindowGetHeight(itemMaxOption, 24), wSpr, animS, animE, animM);
			cMenuWindowDrawFunction("misc", function () { cMenuWindowDrawItems("misc"); });
			
			return true;
		break;
	};
};
// Wants to quit
if (keyboard_check_pressed_action("back")) {
	// Get back
	cMenuWindowKill("backpack");
	cMenuDepthDecrease();
	
	return true;
};

return false;

};

#endregion

/// @description Get shop data
function shopGetData(shopId) {

return structRead(global.shopData, shopId, -1);

};

/// @description Get dialog handler
function shopGetDialogHandler(shopId) {

return structRead(shopGetData(shopId), "dialogHandler", "test");

};

/// @description Get a dislog from it
function shopGetLangData(shopId, dataId, def = "") {

return languageGet("shop_" + shopGetDialogHandler(shopId) + "_" + dataId);

};

/// @description Get dialog when shop tells you how did he fucking get the item u're asking for
function shopGetBuyDialog(shopId, itemId) {

// get the main data from here
var _buyDialogs = languageGet("shop_" + shopGetDialogHandler(shopId) + "_buy_items");
// And return the dialog itself
return structRead(_buyDialogs, itemId, "");

};