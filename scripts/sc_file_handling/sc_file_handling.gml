// Script:

/// @param string
function saveString(_string, fileDirection) {

var buffer = buffer_create(string_byte_length(_string) + 1, buffer_fixed, 1);
buffer_write(buffer, buffer_string, _string);
buffer_save(buffer, fileDirection); 
buffer_delete(buffer);

};

// Load string with buffer
function loadString(fileDirection) {

// Set variables
var buffer = buffer_load(fileDirection);
var _string = buffer_read(buffer, buffer_string);

// Delete buffer
buffer_delete(buffer);

// Return JSON string
return _string;

};

// Load string from buffer, then converts it to struct
function jsonToStruct(fileDirection) {

// If JSON file exists
if (file_exists(fileDirection)) {
	// Return struct
	return json_parse(loadString(fileDirection));
};

return undefined;

};

// Save JSON with buffer
/// @param struct
function jsonSave(_struct, fileDirection) {

// Convert to string
var _JSONstring;
_JSONstring = json_stringify(_struct);
saveString(_JSONstring, fileDirection);

};


/// @description Read struct to find if exists index
function structExists(struct, indexString) {

// If exists struct
if (is_struct(struct)) {
	// Index exists in struct?
	if (variable_struct_exists(struct, indexString)) {
		return true;
	};
};

return false;

};

// Read struct, if not find value, returns default
/// @param {struct} struct
/// @param {string} name
/// @param deafultValue
function structRead(struct, indexString, defaultValue) {

// If exists struct
if (is_struct(struct)) {
	// Index exists in struct?
	if (variable_struct_exists(struct, indexString)) {
		// Found value, set it
		return variable_struct_get(struct, indexString);
	};
};

//log("Don't found " + string(indexString) + " in struct!");
// Return value
return defaultValue;

};

function arrayDuplicate(arrayId) {

// Create a new array with the exact same length
var returnArray = array_create(array_length(arrayId));
// Make a loop to copy content
for (var i = 0; i < array_length(arrayId); i++) {
	
	// Get this slot of the array
	var contentValue = arrayId[i];
	// It's a struct
	if (is_struct(contentValue)) {
		
		// Write in struct
		returnArray[i] = structDuplicate(contentValue);
		
	// It's an array
	} else if (is_array(contentValue)) {
		
		// Copy the array
		returnArray[i] = arrayDuplicate(contentValue);
	} else {
		
		// Just same content
		returnArray[i] = contentValue;
	};
};

return returnArray;

};

/// @description Search in array for index, if it doesn't exists just assign it a common value
function arrayRead(arrayId, arrIndex, defaultValue) {

// If it exists
if (array_length(arrayId) > arrIndex) { return arrayId[arrIndex]; };
// Doesn't exists, so create it
for (var i = array_length(arrayId); i <= arrIndex; i++) {
	// Set directly variable to array
	arrayId[@ i] = defaultValue;
};

return defaultValue;

};

/// @description Search in array for index, if it doesn't exists just assign it a common value
function arraySet(arrayId, arrIndex, newValue, defaultValue = 0) {

// If it exists
if (array_length(arrayId) > arrIndex) { arrayId[@ arrIndex] = newValue; };
// Doesn't exists, so create it
for (var i = array_length(arrayId); i <= arrIndex; i++) {
	// Set directly variable to array
	arrayId[@ i] = defaultValue;
	// Is the last
	if (i == arrIndex) { arrayId[@ i] = newValue; };
};

};

function arrayMerge(array1, array2) {

var returnArr = [ ];
var betArr2 = arrayDuplicate(array2);
var arr2Length = array_length(betArr2);

// Loop for array 1
for (var i = 0; i < array_length(array1); i++) {
	
	// Get this ID my man
	var arrElementId = array1[i];
	// Loop for array 2
	for (var n = 0; n < arr2Length; n++) {
		
		// Is in it??
		if (betArr2[n] == arrElementId) { array_delete(betArr2, n, 1); break; };
	};
	// If can add
	array_push(returnArr, arrElementId);
};
// Loop for array 1
for (var i = 0; i < array_length(betArr2); i++) { array_push(returnArr, betArr2[i]); };

return returnArr;

};

/// @description We take out one element of the array and reduce its size while retaining other items
function arrayTakeOut(array, elementId) {

// Is the last element
if (elementId == (array_length(array) - 1)) { return array_pop(array); };

// Copy the parts of the array after the element ID
var _arrCopy = [];
array_copy(_arrCopy, 0, array, elementId + 1, array_length(array) - (elementId + 1));
// Original element backup
var _backup = array[elementId];
// And resize the array
array_resize(array, array_length(array) - 1);
// Copy old elements
array_copy(array, elementId, _arrCopy, 0, array_length(_arrCopy));

return _backup;

};

function structDuplicate(structId) {

// Create a empty struct
var returnStruct = { };
// Get all the content of the struct
var structContents = variable_struct_get_names(structId);
// Make a loop to copy content
for (var i = 0; i < array_length(structContents); i++) {
	
	// Get this struct variable ID
	var structVariable = variable_struct_get(structId, structContents[i]);
	// It's a struct
	if (is_struct(structVariable)) {
		
		// Write in struct
		variable_struct_set(returnStruct, structContents[i], structDuplicate(structVariable));
		
	// It's an array
	} else if (is_array(structVariable)) {
		
		// Copy the array
		variable_struct_set(returnStruct, structContents[i], arrayDuplicate(structVariable));
	} else {
		
		// Just same content
		variable_struct_set(returnStruct, structContents[i], structVariable);
	};
};

return returnStruct;

};

/// @description Searches in array for a variable and returns ID (nothing = -1)
function arrayFind(arrayId, searchingFor) {

// Search for it
for (var i = 0; i < array_length(arrayId); i++) { if (arrayId[i] == searchingFor) { return i; break; }; };
// Nothing
return -1;

};

function arrayFill(arrayId, toFillWith) {

// Loop in array
for (var i = 0; i < array_length(arrayId); i++) {
	
	// Write in the shit
	arrayId[@ i] = toFillWith;
};

return arrayId;

};

/// @description Scroll array one amount bitch
function arrayScroll(arrayId, scrollV) {

var _aLength = array_length(arrayId);


// No
if (scrollV <= 0) { return arrayId; };
// Limit
scrollV = floor(scrollV mod _aLength);


// Get the last part of it
var _arrayReturn = [];
array_copy(_arrayReturn, 0, arrayId, _aLength - 1 - scrollV, scrollV);
// And the first part of it
array_copy(_arrayReturn, array_length(_arrayReturn), arrayId, 0, _aLength - scrollV);

return _arrayReturn;

};

function arrayScrollChunk(arrayId, scrollV, chunkSize) {

// Divide array in chunk parts
var _chunkTotal = floor(array_length(arrayId) / chunkSize);

// Loop for each chunk
for (var i = 0; i < _chunkTotal; i++) {
	
	// Grab the start of chunky
	var _chunkStart = chunkSize * i;
	// My chunk size
	var _chunkNewSize = min(_chunkStart + chunkSize, array_length(arrayId)) - _chunkStart;
	// Get the chunk new
	var _chunkNew = [];
	array_copy(_chunkNew, 0, arrayId, _chunkStart, _chunkNewSize);
	// And copy in there
	array_copy(arrayId, _chunkStart, _chunkNew, 0, array_length(_chunkNew));
};

return arrayId;

};

function arrayScrollByChunk(arrayId, scrollV, chunkSize) {

var _aLength = array_length(arrayId);


// No
if (scrollV <= 0) { return arrayId; };
// Limit
scrollV = floor(scrollV mod floor(_aLength / chunkSize)) * chunkSize;
//show_debug_message(scrollV);

// Get the last part of it
var _arrayReturn = [];
array_copy(_arrayReturn, 0, arrayId, _aLength - 0 - scrollV, scrollV);
// And the first part of it
array_copy(_arrayReturn, array_length(_arrayReturn), arrayId, 0, _aLength - scrollV);

return _arrayReturn;

};


function filenameCheckExtension(_filename, _extension) {

// if found
var _foundExtension = false;
var _returnString = _filename;

// search backwards
for (var i = string_length(_filename); i >= 2; i--) {
	
	// found point
	if (string_char_at(_filename, i) == ".") {
		
		// search up next\
		var _guessedEx = string_copy(_filename, i + 1, string_length(_filename) - i);
		// is that
		if (_guessedEx == _extension) { _foundExtension = true; };
		
		break;
	};
};

// add to it
if (!_foundExtension) { _returnString = _filename + "." + _extension; };

return _returnString;

};
