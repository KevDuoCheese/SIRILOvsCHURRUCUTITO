
// Language ID in JSON
global.languageId = "es";
// There isn't language thing
global.languageStruct = -1;

/// @description Load language JSON
function languageLoad() {

// Get file ID
var fileName = "lang/" + global.languageId + ".json";

// Try to load it
try {
	// Load it
	global.languageStruct = jsonToStruct(fileName);
};

};

/// @description Get a struct variable by its name
function languageGet(stringId) {

// Return it
return structRead(global.languageStruct, stringId, stringId);

};