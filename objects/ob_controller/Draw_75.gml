/// @description Reset GUI again

// Reset GUI surface to use application surface again
surfaceGUICustomSurface();

// Set custom blendmode to draw it
gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);

var posLoc;
posLoc = (currentFrame() / 50);
posLoc -= floor(posLoc);

var guiScaleX, guiScaleY, guiRot;
guiScaleX = 1;//animcurveRead(ac_test_rotate, "scale", posLoc, 1);
guiScaleY = 1;//guiScaleX;
guiRot = 0;//animcurveRead(ac_test_rotate, "rot", posLoc, 0);

var guiXPos, guiYPos;
guiXPos = display_get_gui_width() / 2;
guiYPos = display_get_gui_height() / 2;

var guiWidth, guiHeight;
guiWidth = display_get_gui_width();
guiHeight = display_get_gui_height();

guiXPos -= (lengthdir_x(guiWidth / 2, guiRot + DIR_RIGHT) * guiScaleX + lengthdir_x(guiHeight / 2, guiRot + DIR_BOTTOM) * guiScaleX);
guiYPos -= (lengthdir_y(guiWidth / 2, guiRot + DIR_RIGHT) * guiScaleY + lengthdir_y(guiHeight / 2, guiRot + DIR_BOTTOM) * guiScaleY);

//shader_set(sh_invert);
//shader_set_uniform_f(shader_get_uniform(sh_invert, "time"), pi * 0.5)
//shader_set(sh_trying);
var _mapGUIWidth, _mapGUIHeight;
_mapGUIWidth	 = surface_get_width(global.surfaceMap[? "gui"]);
_mapGUIHeight	 = surface_get_height(global.surfaceMap[? "gui"]);
// Start drawing surface
draw_surface_general(	global.surfaceMap[? "gui"],
						0, 0,
						_mapGUIWidth, _mapGUIHeight,
						guiXPos, guiYPos,
						(guiWidth / _mapGUIWidth) * guiScaleX, (guiHeight / _mapGUIHeight) * guiScaleY,
						guiRot, c_white, c_white, c_white, c_white, 1 );

// Draw the surface on it XDD
draw_surface_ext(global.guiSurface,
				 guiXPos, guiYPos,
				 guiScaleX, guiScaleY,
				 guiRot, c_white, 1);


// Take out that shader
shader_reset();
// Reset blendmode
gpu_set_blendmode(bm_normal);


// In case of GUI drawing
if (global.showFPS) {
	var _a = application_get_position();
	var _ww = _a[2] - _a[0];
	var _hh = _a[3] - _a[1];
	
	var _aspect = screen.width / _ww;
	
	drawPreset("small");
	draw_set_alpha(1);
	
	draw_text_transformed(0, 0, string(fps) + "/" + string(game_get_speed(gamespeed_fps)) + " FPS",
						_aspect, _aspect, 0);
	
	drawReset();
	drawPreset("general");
};