/// @description In the preset bro
if (!drawCan()) { exit; };

// preset
drawPreset("hit");

// st alpha
draw_set_alpha(textAlpha);
// Shine in red and white when reached bottom
draw_set_color((y >= ystart && ySpeed >= 0) ? ((floor(currentFrame() / 5) mod 2) ? c_white : COLOR_RED) : c_white);
// Draw the text outline in the position
draw_text_outline(x, y, myText, COLOR_BLACK);

// reset
drawReset();