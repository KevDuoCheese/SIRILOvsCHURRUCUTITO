/// @description 
if (!drawCan(viewId.draw)) { exit; };

var _mainWW = image_xscale - ((image_xscale * 0.9) * (1 - animValue));
var _mainWX = x - (_mainWW / 2);

// Draw the main window of punch animation
draw_sprite_stretched_ext(sp_window_ui_button_medium, 0,
                    _mainWX, y,
                    _mainWW, image_yscale,
                    c_white, animValue);

// Draw the fight shit here
draw_sprite_stretched_ext(sp_fight_window, 0,
                    _mainWX, y,
                    _mainWW, image_yscale,
                    c_white, animValue);

// Draw the thingy here
draw_sprite_ext(sp_fight_index, indexActive ? spriteAnim(sp_fight_index) : 0,
                (_mainWX + 0) + ((_mainWW - 0) * (indexPos / 2)), y + (image_yscale / 2), 1, 1, 0, c_white, animValue * indexAlpha);
