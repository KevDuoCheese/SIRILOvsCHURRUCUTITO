
/// @description Creates a array that holds the nineslice shader uniforms
function nineslice_uniforms() {

var ret = array_create(4);
 
ret[0] = shader_get_uniform(sh_nineslice, "position");
ret[1] = shader_get_uniform(sh_nineslice, "size");
ret[2] = shader_get_uniform(sh_nineslice, "uvs");
ret[3] = shader_get_uniform(sh_nineslice, "sliceSize");

return ret;

};

/// @param sprite
/// @param subimg
function nineslice_uvs(sprite, subimg) {

var ret = array_create(5);
 
 // Save sprite in there
ret[0] = sprite;
ret[1] = subimg;
// Get UVS and slice width and height
ret[2] = sprite_get_uvs(ret[0], ret[1]);

ret[3] = sprite_get_width(ret[0]) * 0.25;
ret[4] = sprite_get_height(ret[0]) * 0.25;

return ret;

};

/// @description Init shit dude
function nineslice_init(sprite, subimg) {

// Draw this shit dude
_ninesliceUniforms = nineslice_uniforms();
_ninesliceUvs = nineslice_uvs(sprite, subimg);

};

/// @param uniforms
/// @param uvs
/// @param x
/// @param y
/// @param w
/// @param h
function draw_nineslice(uniforms, uvs, x_, y_, w, h, color = c_white, alpha = 1) {

// Nineslice shader
shader_set(sh_nineslice);

// Adjust uniforms:

// Drawing X and Y position
shader_set_uniform_f(uniforms[0], x_, y_);
// Drawing width and height
shader_set_uniform_f(uniforms[1], w, h);
// Set the fucking UVS
shader_set_uniform_f_array(uniforms[2], uvs[2]);
// Set the slice size
shader_set_uniform_f(uniforms[3], uvs[3], uvs[4]);

// Draw the sprite stretched buddy
draw_sprite_stretched_ext(uvs[0], uvs[1], x_, y_, w, h, color, alpha);

// Fuck off
shader_reset();

};

/// @param x
/// @param y
/// @param w
/// @param h
function draw_d_nineslice(x_, y_, w, h) {

// Directly draw the nineslice shit
draw_nineslice(_ninesliceUniforms, _ninesliceUvs, x_, y_, w, h);

};

/// @param x
/// @param y
/// @param w
/// @param h
/// @param color
/// @param alpha
function draw_d_nineslice_ext(x_, y_, w, h, color, alpha) {

// Directly draw the nineslice shit
draw_nineslice(_ninesliceUniforms, _ninesliceUvs, x_, y_, w, h, color, alpha);

};