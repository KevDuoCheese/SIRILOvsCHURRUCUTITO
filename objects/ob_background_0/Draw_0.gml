/// @description 
if (!drawCan(viewId.draw)) { exit; };

var _palleteSprite = sp_bg_teacher;
var _sprWidth = sprite_get_width(_palleteSprite);
var _sprHeight = sprite_get_height(_palleteSprite);

// Now get that up
if (!surface_exists(colorPalleteSurf)) { colorPalleteSurf = surface_create(_sprWidth, _sprHeight); };

// Set this down
surface_set_target(colorPalleteSurf);
// Clear this up
draw_clear_alpha(c_black, 0);
gpu_set_blendmode_ext(bm_one, bm_zero);

shader_set(sh_pallete16);
var _colPalNew = array_concat(colorToFloatArray(#000000), arrayScrollByChunk(colorPallete15, floor(timePlaying / 6), 3));
//show_debug_message(_colPalNew)
shader_set_uniform_f_array(cpPallete, _colPalNew);

var _dX, _dY;
_dX = (sin(timePlaying / 120) * 150) mod _sprWidth;
_dY = (cos(timePlaying / 150) * 46) mod _sprHeight;
while (_dX < 0) { _dX += _sprWidth; };
while (_dY < 0) { _dY += _sprHeight; };

draw_sprite_stretched(_palleteSprite, 0, _dX, _dY, _sprWidth, _sprHeight);
draw_sprite_stretched(_palleteSprite, 0, _dX - _sprWidth, _dY - _sprHeight, _sprWidth, _sprHeight);
draw_sprite_stretched(_palleteSprite, 0, _dX - _sprWidth, _dY, _sprWidth, _sprHeight);
draw_sprite_stretched(_palleteSprite, 0, _dX, _dY - _sprHeight, _sprWidth, _sprHeight);

shader_reset();
gpu_set_blendmode(bm_normal);

surface_reset_target();



trdsStart(	timePlaying / 12, timePlaying / 20,
			60, 45,
			(sinInverval(timerGet(4), timePlaying) * 0.1), 0.02 + (sinInverval(timerGet(10), timePlaying) * 0.5),
			true, false, true);


// And draw here that
draw_surface(colorPalleteSurf, 0, 0);


trdsEnd();