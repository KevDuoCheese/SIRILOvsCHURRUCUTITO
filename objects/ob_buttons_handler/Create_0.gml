/// @description 
depth = 17;
global.healthValue = 45;
global.pp = 35;
// adjust main values
buttonMainX = 8 * 0.5;
buttonMainY = 9 * 0.5;
buttonSeparationX = 160 * 0.5;
// here the option
cMenuCreate();

// Setup the battle music
musicChangeLayer(0, mus_battle0);


// Set a temporal array with all the names and icons
var _namesNicons;
_namesNicons = [
	"PUNCH",
	"PSY", 
	"ITEM",
	"DEF"
];
// Another one to save here the buttons ID
buttons = [];

// And do loop for each of them
for (var i = 0; i < 4; i++) {
	
	// Create the button instance
	var _buttonN = instance_create_depth(buttonMainX + (buttonSeparationX * i), buttonMainY, 0, ob_button);
	_buttonN.buttonIconIndex = i;
	_buttonN.buttonText = _namesNicons[i];
	
	array_push(buttons, _buttonN);
};