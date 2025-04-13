/// @description Draw here the volume effect

// Y pos is 0 or less
if (yPos <= 0) { exit; };

// Get height of volume sprite
var _vHeight = sprite_get_height(sp_volume_controller_bg);
// Where to draw it?
var _drawPosX = (screen.width / 2) + (((0.5 - random(1)) * remap(shakeEffectTimer, 0, shakeEffectTimerMax, 1, 2)) * (shakeEffectTimer > 0));
var _drawPosY = screen.height + (_vHeight * (1 - yPos));

// Draw the BG in pos
draw_sprite(sp_volume_controller_bg, 0, _drawPosX, _drawPosY);
// Draw the volume indicator
draw_sprite(sp_volume_controller,
			round(remap(global.volumeValue,
						0, 1,
						0, sprite_get_number(sp_volume_controller) - 1)), _drawPosX, _drawPosY);
