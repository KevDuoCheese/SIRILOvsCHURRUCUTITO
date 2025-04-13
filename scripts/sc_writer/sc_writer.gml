
// Wrtier init variables
global.writerPreType = "general";
// Message empty thing
global.gMessages[0] = "???/*";
// Options of the choose thing
global.chooseOption = 0;
global.chooseString = [ "no", "yes" ];

/// @description Set options for choose
function chooseSetOptions(chooseO0 = "no", chooseO1 = "yes") {

// Clear choose string
array_delete(global.chooseString, 0, array_length(global.chooseString));

// For argument count
for (var i = 0; i < argument_count; i++) {
	// And fill it
	array_push(global.chooseString, argument[i]);
};

};

/// @description Set type and message shit at once
function writerSetPreVar(typeId, daArgument, type) {

// Adjust pre type of this bullshit im tired u know? shut up bitch get out off my way fuuuuck
global.writerPreType = typeId;
// And the messsages too
global.gMessages = messageGet(daArgument, type);

};

/// @description To add a writer type for textboxes and dialogs
/// @param {string}			 typeId	 		How it will be referenced to call the type itself
/// @param {Asset.GMSound}	 soId		 	Sound when writing text
/// @param {real}			 pitchM			Sound pitch base
/// @param {real}			 pitchMod	  	How much sound pitch it can variate when texting
/// @param {real}			 chTimer		Time in frames between each character when writing
/// @param {Constant.Color}	 chColor		Default color when writing (Can be called with /cD)
/// @param {Asset.GMFont}	 foId			Using font
/// @param {real}			 foCWidth		Character width separation
/// @param {real}			 foCHeight		Character height separation
function writerAddType(typeId, soId = so_textbox_0,
						pitchM = 1., pitchMod = 0.1,
						chTimer = 1.5,
						chColor = COLOR_WHITE,
						foId = global.fontMap[? "general"],
						foCWidth = 7,
						foCHeight = 12
						) {

// Set type here
global.writerTypes[$ typeId] = {
	
	fontId : foId,
	
	charWidth : foCWidth,
	charHeight : foCHeight,
	
	charTimer : chTimer,
	ocColor : chColor,
	
	soundId : soId,
	
	pitchBase	: pitchM,
	pitchChange : pitchMod
};

};

/// @description Load writer types (THIS GOES AFTER DECLARING FONTS)
function writerLoadTypes() {

// Open a new struct with writer types
global.writerTypes = {
	
	"general" : {
		
		fontId : global.fontMap[? "general"],
		
		charWidth : 7,
		charHeight : 12,
		
		charTimer : 1.5,
		
		soundId : so_textbox_0,
		
		pitchBase : 1,
		pitchChange : 0.1
	}
};

};

/// @description Adjust writer types
function writerAdjustType(typeId) {

// Load this in
var typeStruct = structRead(global.writerTypes, typeId, -1);

// Now set each variable
fontId = structRead(typeStruct, "fontId", global.fontMap[? "general"]);

charWidth = structRead(typeStruct, "charWidth", 7);
charHeight = structRead(typeStruct, "charHeight", 12);

soundId = structRead(typeStruct, "soundId", so_silence);

charTimer = structRead(typeStruct, "charTimer", 1.5);

ocColor = structRead(typeStruct, "ocColor", c_white);

charPitchChange = structRead(typeStruct, "pitchChange", 0.1);
charPitchBase = structRead(typeStruct, "pitchBase", 1);

};

/// @description Returns a 1D array with the wanted messages
function messageGet(daArgument, type) {

// Message return
var returnMessage = [ ];

// According to type
switch (type) {
	
	case "msg":
		
		// Set this shit
		returnMessage[0] = string(daArgument);
		
	break;
	
	case "array":
		
		// Read all the array and add
		for (var i = 0; i < array_length(daArgument); i++) {
			// Add to it
			array_push(returnMessage, string(daArgument[i]));
		};
		
	break;
	
	case "choose":
		
		// Is an array??
		if (is_array(daArgument)) {
			// Load this
			returnMessage = messageGet(daArgument, "array");
			
		} else {
			
			// Same dude
			returnMessage = messageGet(daArgument, "msg");
		};
		
	break;
	
	case "lang":
		
		// Get from language thing
		var langData = languageGet(daArgument);
		
		// Choose from it
		returnMessage = messageGet(langData, "choose");
		
	break;
};

// Hellooo
return returnMessage;

};


