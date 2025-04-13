/// @description Main screen ajustments and surface too

// Random seed
randomize();

// Add region adjustments
#macro TILE_SIZE 16
// Directions in angle
#macro DIR_BOTTOM	 -90
#macro DIR_TOP		 90
#macro DIR_RIGHT	 0
#macro DIR_LEFT		 180
// Set global colors
#macro COLOR_AQUA		 #4AFFF7
#macro COLOR_BLACK		 #0C001F
#macro COLOR_BLUE		 #523AFF
#macro COLOR_DK_GRAY	 #362C50
#macro COLOR_FUCHSIA	 #E200FF
#macro COLOR_GRAY		 #9595B9
#macro COLOR_GREEN		 #00A665
#macro COLOR_LIME		 #00FF90
#macro COLOR_LT_GRAY	 #B7B7B7
#macro COLOR_MAROON		 #A0415A
#macro COLOR_NAVY		 #202270
#macro COLOR_OLIVE		 #89863D
#macro COLOR_ORANGE		 #F89448
#macro COLOR_PURPLE		 #9600FA
#macro COLOR_RED		 #F8005D
#macro COLOR_SILVER		 #C8D7D7
#macro COLOR_TEAL		 #3E93D4
#macro COLOR_WHITE		 #FFFFFF
#macro COLOR_YELLOW		 #FFEC2B

// Back depth to max
depth = -2000;


// Enumerate screen adjustments
enum screen {
	// Screen size
	width	 = 320,
	height	 = 192,
};

// Enumerate view ID's
enum viewId {
	
	draw = 0,
	background = 1,
	gui = 2,
	arcade = 3,
	world_map = 4
};

// get a format perspective
vertex_format_begin();
vertex_format_add_colour();
vertex_format_add_position();
vertex_format_add_normal();
global.formatPerspective = vertex_format_end();

var _compareDisplay, _compareView;
if (display_get_width() < display_get_height()) { _compareDisplay = display_get_width(); _compareView = screen.width; }
else  { _compareDisplay = display_get_height(); _compareView = screen.height; };

// Screen multiplier
global.screenSize = max(floor((_compareDisplay * 0.92) / _compareView), 1);
// Save the max scale
global.screenSizeMax = global.screenSize;
// Inverse scaling
global.screenSizeInv = 1 / global.screenSize;
// Adjust surface size to main size
//surface_resize(application_surface, screen.width * global.screenSize, screen.height * global.screenSize);
surface_resize(application_surface, screen.width * 2, screen.height * 2);
application_surface_draw_enable(false);

// Do the same with window
window_set_size(screen.width * global.screenSize, screen.height * global.screenSize);
window_center();
// Adjust window caption
window_set_caption("Template Game " + string(GM_version));
// Adjust GUI and create the controller
//display_set_gui_maximize(1, 1);
display_set_gui_size(screen.width, screen.height);
instance_create_depth(0, 0, -100, ob_gui_controller);

// Oh yes
languageLoad();

// Create a collision list
global.colList = ds_list_create();
// Create a map to save surfaces
global.surfaceMap = ds_map_create();
// Startup
global.surfaceMap[? "gui"] = surface_create(screen.width * global.screenSize, screen.height * global.screenSize);
// Create a surface for font
global.surfaceMap[? "text"] = surface_create(1, 1);




// Activate the camera dude
instance_create_depth(0, 0, -100, ob_camera);
// Now to control the music and that stuff
instance_create_depth(0, 0, -100, ob_music_controller);
// We need to control volume too
instance_create_depth(0, 0, -100, ob_volume_controller);
// Surface draw is disabled, so we must draw it by ourselves
instance_create_depth(0, 0, -100, ob_surface_draw);


// Level curretn frame, very, VERY useful
global.levelFrame = 0; 
// Global game speed, adjust this changes physics, background, and more
global.gameSpeed = 1;
// Global game mode, determines certain objects behavior
global.gameMode = "play";
// If game must show FPS
global.showFPS = false;
// For testing and checks
global.debugMode = false;



// health things
global.healthValueMax = 130;
global.healthValue = global.healthValueMax;
// and PHYSHIC PWOERRR
global.ppMax = 50;
global.pp = global.ppMax;



// Adjust global volume, range from 0 to 1
global.volumeValue = 1;
// Total numbers of players
global.playersNumber = 1;

// Set font map string
var mapString;
mapString = " ABCDEFGHIJKLMNÑOPQRSTUVWXYZ():;[]abcdefghijklmnñopqrstuvwxyzáéíóú'-¿?¡!.$/,0123456789°%+=&#*_{}\\^<>|~©@\"";
var mapStringKong;
mapStringKong = " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789:+-*/$=%\"'#@&_(),.;?¿!¡\\|{}<>[]÷~^©`™ßàáâãäåæçèéêëîïíìñòóôõöøœùúûü‰¢€£¥¤§¶µ®ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÑÒÓÔÕÖØŒÙÚÛÜ";
var _mapStringNostalgia;
_mapStringNostalgia = " ABCDEFGHIJKLMNÑOPQRSTUVWXYZ():;[]abcdefghijklmnñopqrstuvwxyzáéíóú'-?!.$/,0123456789°%+=&#*_{}\^<>|~";

var _fontKongS = font_add_sprite_ext(sp_fo_kongtext, mapStringKong, false, -1);

// Load in fonts
global.fontMap = ds_map_create();
// Add fonts to the map ma boi
global.fontMap[? "test"]		 = fo_test;
// Smmal 5x3 font
global.fontMap[? "small"]		 = fo_small;
// UI battle
global.fontMap[? "ui-buttons"]	 = fo_ui_buttons;
// Debug numbers
global.fontMap[? "debug-num"]	 = font_add_sprite_ext(sp_fo_debug_numbers, ".0123456789truefals°,", 1, -1);
// General font dude
global.fontMap[? "general"]		 = _fontKongS;
// For testing
global.fontMap[? "test-data"]	 = font_add_sprite_ext(sp_fo_debug_numbers, ".0123456789truefals°,p:", true, -1);

// Enumerate each keybind ID for search
enum keybindType { keyboard = 0, keyboard_alt = 1, gamepad = 2, gamepad_alt = 3 };
// Create a keys array (for each one player)
global.keybindArray = [
	
	// Build a struct for keys map
	{
		// Using gamepad for this player
		gamepad_id : -1,
		gamepad_id_forced : -1, // If has set a gamepad in settings for this particular player
		gamepad_deadzone : 0.6,
		
		// This follows the next structure: [ keyboard, keyboard_alt, gamepad, gamepad_alt ]
		right	 : [ vk_right, -1, gp_padr, "axisl_right" ],
		left	 : [ vk_left, -1, gp_padl, "axisl_left" ],
		down	 : [ vk_down, -1, gp_padd, "axisl_down" ],
		up		 : [ vk_up, -1, gp_padu, "axisl_up" ],
		// Use this for horizontal movement (-1 = no key assigned)
		hmove : [ -1, -1, "axisl_horizontal", -1 ],
		vmove : [ -1, -1, "axisl_vertical", -1 ],
		
		// Other keys
		action	 : [ ord("Z"), vk_enter, gp_face1, gp_face4 ],
		back	 : [ ord("X"), vk_lshift, gp_face3, gp_face2 ],
		menu	 : [ ord("C"), vk_lcontrol, gp_shoulderl, gp_shoulderr ],
		escape	 : [ vk_escape, -1, gp_start, -1 ],
		// Battle keys
		battle_right			 : [ vk_right, -1, gp_padr, "axisl_right" ],
		battle_left				 : [ vk_left, -1, gp_padl, "axisl_left" ],
		battle_menu_right		 : [ vk_down, -1, gp_padd, "axisl_down" ],
		battle_menu_left		 : [ vk_up, -1, gp_padu, "axisl_up" ],
		// Battle jump etc
		battle_jump		 : [ ord("Z"), vk_control, gp_face1, -1 ],
		battle_action	 : [ ord("X"), vk_lshift, gp_face3, -1 ],
		battle_dash		 : [ vk_space, -1, gp_face2, gp_face4 ],
		battle_super	 : [ ord("D"), -1, gp_stickl, -1 ],
		// Battle keys
		battle_inventory_action	 : [ ord("A"), -1, gp_shoulderrb, -1 ],
		battle_inventory_back	 : [ ord("S"), -1, gp_shoulderlb, -1 ],
		
		// Adjust guitar match keys
		gm_key_0	 : [ ord("D"), -1, gp_shoulderlb, -1 ],
		gm_key_1	 : [ ord("F"), -1, gp_shoulderl, -1 ],
		gm_key_2	 : [ vk_space, -1, gp_face1, -1 ],
		gm_key_3	 : [ ord("J"), -1, gp_shoulderr, -1 ],
		gm_key_4	 : [ ord("K"), -1, gp_shoulderrb, -1 ],
		arcade_retry	 : [ ord("R"), -1, gp_select, -1 ],
	}
];
// Save a backup
keybindBackup = arrayDuplicate(global.keybindArray);
// list of connected gamepads
global.gamepadConnected = ds_list_create();


// Yip
global.loadedConfigStruct = { };
// Load player configuration
configLoad();


// Exit game with escape key
escapeKeyTimer = 0;
escapeKeyTimerMax = timerGet(5);
// Debug log
debugLog = false;

//// Adjust player main stats

// Flags
global.flagValue = ds_map_create();
randomize();
global.funValue = irandom_range(1, 100);

