/// @description 
if (!drawCan(viewId.gui)) { exit; };



var _hpX, _ppX;
_hpX = 4.5;
_ppX = (393 * 0.5);

// And positions
var _liquidWindowY;
_liquidWindowY = (340 * 0.5) - (sinInverval(130) * 2);
// For window and gauge
var _liquidWindowWidth, _liquidWindowHeight;
_liquidWindowWidth	 = 238 * 0.5;
_liquidWindowHeight	 = 40 * 0.5;

var _gaugeX, _gaugeY;
_gaugeX = 25;
_gaugeY = _liquidWindowY + 5;
var _gaugeWidth, _gaugeHeight;
_gaugeWidth = 89;
_gaugeHeight = 10;


// and here draw thee window up
draw_sprite_stretched(sp_window_ui_button_small, 0, 4.5, _liquidWindowY,
					_liquidWindowWidth, _liquidWindowHeight);
// what is it?
draw_sprite_ext(sp_battle_liquids, 0, _hpX + 4.5, _liquidWindowY + 7, 0.5, 0.5, 0, c_white, 1);

// and draw here the shit of health
draw_sprite_ext(sp_11box, 0, _hpX + _gaugeX, _gaugeY, _gaugeWidth, _gaugeHeight, 0, COLOR_RED, 1);
draw_sprite_ext(sp_11box, 0, _hpX + _gaugeX, _gaugeY, _gaugeWidth * (global.healthValue / global.healthValueMax), _gaugeHeight, 0, COLOR_YELLOW, 1);


// this is for PP
draw_sprite_stretched(sp_window_ui_button_small, 0, 393 * 0.5, _liquidWindowY,
					_liquidWindowWidth, _liquidWindowHeight);
// and its PP one
draw_sprite_ext(sp_battle_liquids, 1, _ppX + 4.5, _liquidWindowY + 7, 0.5, 0.5, 0, c_white, 1);

// and draw here the shit of PP
draw_sprite_ext(sp_11box, 0, _ppX + _gaugeX, _gaugeY, _gaugeWidth, _gaugeHeight, 0, COLOR_BLUE, 1);
draw_sprite_ext(sp_11box, 0, _ppX + _gaugeX, _gaugeY, _gaugeWidth * (global.pp / global.ppMax), _gaugeHeight, 0, COLOR_AQUA, 1);

// set up this
drawPreset("general");
draw_set_valign(fa_middle);
// draw here
draw_text_transformed(_hpX + _gaugeX + 2, _gaugeY + (_gaugeHeight / 2), string(floor(global.healthValue)) + "/" + string(global.healthValueMax), 1.25, 1, 0);
draw_text_transformed(_ppX + _gaugeX + 2, _gaugeY + (_gaugeHeight / 2), string(floor(global.pp)) + "/" + string(global.ppMax), 1.25, 1, 0);

drawReset();