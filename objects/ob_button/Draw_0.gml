/// @description 
if (!drawCan(viewId.draw)) { exit; };

var _topX, _topY;
_topX = (x + (buttonWidth * 0.5)) - ((buttonWidth * 0.5) * image_xscale);
_topY = (y + (buttonHeight * 0.5)) - ((buttonHeight * 0.5) * image_yscale);

var _color = buttonActive ? COLOR_YELLOW : COLOR_WHITE;

// Draw the window in my place, according to my size
draw_sprite_stretched_ext(sprite_index, 0,
					_topX,
					_topY,
					buttonWidth * image_xscale,
					buttonHeight * image_yscale,
					_color, 1);
// Draw here
if (!buttonActive) {
	draw_sprite_ext(buttonIcon, buttonIconIndex,
		_topX + (24 * image_xscale * 0.5),
		_topY + (23 * image_yscale * 0.5),
		image_xscale * 0.5, image_yscale * 0.5, 0, c_white, 1);
};

// Deactive button if active, I would use begin step but this is better, after drawing
buttonActive = false;

// Draw the button text
drawPreset("ui-buttons");
draw_set_color(_color);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_text(	_topX + (buttonWidth * 0.6 * image_xscale),
			_topY + (buttonHeight * 0.475 * image_yscale),
			buttonText);

drawReset();