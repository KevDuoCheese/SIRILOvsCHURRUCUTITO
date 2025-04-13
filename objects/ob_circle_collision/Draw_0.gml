/// @description Draw the sprite here
if (!drawCanDraw()) { exit; };

// Draw debug mode
draw_set_color(c_white);


draw_set_alpha(image_alpha);
shader_set(sh_alpha_surface);
gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);

// Start this
draw_primitive_begin(pr_trianglestrip);
// For all my collision points
for (var i = 0; i <= circleIterations; i++) {
	
	var _an = i * angleSlice;
	
	// Add vertex
	draw_vertex(x + lengthdir_x(circleRadius, _an), y + lengthdir_y(circleRadius, _an));
	// And exterior one
	draw_vertex(x + lengthdir_x(circleRadius + circleExRad, _an), y + lengthdir_y(circleRadius + circleExRad, _an));
};


draw_primitive_end();

gpu_set_blendmode(bm_normal);
shader_reset();
draw_set_alpha(1);

if (debugVGetValue("showData")) {
	
	draw_set_color(c_lime);
	draw_set_alpha(0.2);
	draw_rectangle(bbox_left, bbox_top, bbox_right - 1, bbox_bottom - 1, true);
	drawReset();
	
	draw_sprite(sp_gamepad_characters, 3, x, y);
};