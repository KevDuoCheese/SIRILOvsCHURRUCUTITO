
function resizeScreenSize() {

// Inverse scaling
global.screenSizeInv = 1 / global.screenSize;
// Adjust surface size to main size
//surface_resize(application_surface, screen.width * global.screenSize, screen.height * global.screenSize);
surface_resize(application_surface, screen.width * 2, screen.height * 2);

// Do the same with window
window_set_size(screen.width * global.screenSize, screen.height * global.screenSize);
window_center();

// And change this
display_set_gui_size(screen.width, screen.height);

};

/// @description Get config file
function configFile() { return working_directory + "config.json"; };

/// @description Save configuration of player
function configSave() {

var _configStruct = { };

var _keybinds = global.keybindArray[0];
// Get all dudes
var _keybindStructs = variable_struct_get_names(_keybinds);
// Save struct
var _keybindSaveStruct = { };

// Read everything
for (var i = 0; i < array_length(_keybindStructs); i++) {
	// Is not
	if ((_keybindStructs[i] == "gamepad_id") || (_keybindStructs[i] == "gamepad_id_forced")) { continue; };
	
	// save inside
	variable_struct_set(_keybindSaveStruct, _keybindStructs[i], global.keybindArray[0][$ _keybindStructs[i]]);
};
// Save inside
_configStruct.keybinds = _keybindSaveStruct;
// Set volume
_configStruct.volume = global.volumeValue;
// Set language
_configStruct.language = global.languageId;
// Save FPS config
_configStruct.showFPS = global.showFPS;
// Save screen size
_configStruct.screenSize = global.screenSize;

// Save it
jsonSave(_configStruct, configFile());


show_debug_message("Saved config file!");

};

/// @description Load configuration of player
function configLoad() {

// File exists?
if (!file_exists(configFile())) { return; };

var _configStruct;
try {
	// Try to load, try to avoid false modifications
	_configStruct = jsonToStruct(configFile());
} catch (_lolError) {
	// Couldn't load anything
	_configStruct = { };
};
// Save struct
var _keybindSaveStruct = structRead(_configStruct, "keybinds", { });
// Get all dudes
var _keybindStructs = variable_struct_get_names(_keybindSaveStruct);

// Read everything
for (var i = 0; i < array_length(_keybindStructs); i++) {
	
	// save inside
	global.keybindArray[0][$ _keybindStructs[i]] = structRead(_keybindSaveStruct, _keybindStructs[i], global.keybindArray[0][$ _keybindStructs[i]]);
};

// Load volume
global.volumeValue = structRead(_configStruct, "volume", global.volumeValue);
// Set language
global.languageId = structRead(_configStruct, "language", global.languageId);
// Set show FPS
global.showFPS = structRead(_configStruct, "showFPS", global.showFPS);
// Load screen size
global.screenSize = structRead(_configStruct, "screenSize", global.screenSize);
resizeScreenSize();


// Save it
global.loadedConfigStruct = _configStruct;

show_debug_message("Loaded config file!");

};