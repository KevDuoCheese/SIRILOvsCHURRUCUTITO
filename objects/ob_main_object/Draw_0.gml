/// @description To draw self only in view
if (!drawCan()) { exit; };

if (shader_current() != -1) { shader_reset(); };

surfaceSetBlend()
shader_set(sh_alpha_surface);


if (sprite_index != -1) { draw_self(); };


surfaceEndBlend();
if (shader_current() != -1) { shader_reset(); };











