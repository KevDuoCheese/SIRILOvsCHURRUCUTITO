/// @description Draw the sprite here
if (!drawCanDraw()) { exit; };

draw_self();


if (debugVGetValue("showMasks")) {
	colDebugDraw(COLOR_BLUE);
};
if (debugVGetValue("showData")) {
	
	draw_set_color(c_lime);
	draw_set_alpha(0.2);
	draw_rectangle(bbox_left, bbox_top, bbox_right - 1, bbox_bottom - 1, true);
	drawReset();
	
	draw_sprite(sp_gamepad_characters, 3, x, y);
};