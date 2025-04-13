/// @description 
//draw_self();
if (!drawCan()) { exit; };

draw_sprite_ext(sprite_index, image_index, x, y, image_xscale * 0.5, image_yscale * 0.5, image_angle, image_blend, image_alpha);

if (debugVGetValue("showData")) {
	
	draw_set_color(COLOR_PURPLE);
	drawLine(x, y, x + lengthdir_x(TILE_SIZE, debugXAngle), y + lengthdir_y(TILE_SIZE, debugXAngle));
	
	draw_set_color(COLOR_LIME);
	drawLine(x, y, x + lengthdir_x(TILE_SIZE, debugYAngle), y + lengthdir_y(TILE_SIZE, debugYAngle));
	
	draw_set_color(COLOR_YELLOW);
	drawLine(bbox_left, bbox_top, bbox_right, bbox_top);
	drawLine(bbox_right, bbox_top, bbox_right, bbox_bottom);
	drawLine(bbox_right, bbox_bottom, bbox_left, bbox_bottom);
	drawLine(bbox_left, bbox_bottom, bbox_left, bbox_top);
};