
/// @description Get all uniforms from outline shader
function outline_init() {

outlineUniTexel			 = shader_get_uniform(sh_outline, "in_Texel");
outlineUniSize			 = shader_get_uniform(sh_outline, "outlineSize");
outlineUniColor			 = shader_get_uniform(sh_outline, "outlineColor");
outlineUniAlpha			 = shader_get_uniform(sh_outline, "outlineAlpha");
outlineUniGAlpha		 = shader_get_uniform(sh_outline, "globalAlpha");
outlineUniCoverCorners	 = shader_get_uniform(sh_outline, "coverCorners");
outlineUniPixelPerfect	 = shader_get_uniform(sh_outline, "isPixelPerfect");
outlineUniURes			 = shader_get_uniform(sh_outline, "uRes");

};//*/


/// @param thickness
/// @param color
/// @param {Pointer.Texture} texture
/// @param {bool} coverCorners
/// @param {bool} pixelPerfect
function outline_start(thickness, color, texture, coverCorners = true, pixelPerfect = false) {

// Get all uniforms
var uniTexel			 = outlineUniTexel;//shader_get_uniform(sh_outline, "in_Texel");
var uniThick			 = outlineUniSize;//shader_get_uniform(sh_outline, "outlineSize");
var uniColor			 = outlineUniColor;//shader_get_uniform(sh_outline, "outlineColor");
var uniAlpha			 = outlineUniAlpha;//shader_get_uniform(sh_outline, "outlineAlpha");
var uniGlobalAlpha		 = outlineUniGAlpha;
var uniURes				 = outlineUniURes;
var uniPixelPerfect		 = outlineUniPixelPerfect;
var uniCoverCorners		 = outlineUniCoverCorners;

// Get draw alpha
var _alpha;
_alpha = draw_get_alpha();
// Set to outline shader
shader_set(sh_outline);

// Get texture texel size
var _w = texture_get_texel_width(texture);
var _h = texture_get_texel_height(texture);
// Set obtained texels
shader_set_uniform_f(uniTexel, _w, _h);
// Set cover corners
shader_set_uniform_f(uniCoverCorners, coverCorners);
// Outline thick
shader_set_uniform_f(uniThick, thickness);
// Set color of the outline
shader_set_uniform_f(uniColor, color_get_red(color) / 255,
								color_get_green(color) / 255,
								color_get_blue(color) / 255);
// Set alpha (For outline only)
shader_set_uniform_f(uniAlpha, _alpha);
// Set global alpha (Mean, draw alpha)
shader_set_uniform_f(uniGlobalAlpha, draw_get_alpha());

if (pixelPerfect) {
	
	shader_set_uniform_f(uniPixelPerfect, true);
	
	// Get next power of two of this man
	var wScalar = 1;//nextPowTwo(1 / _w);
	var hScalar = 1;//nextPowTwo(1 / _h);
	// Adjust the uniform on this
	shader_set_uniform_f(uniURes, wScalar, hScalar);
} else {
	
	shader_set_uniform_f(uniPixelPerfect, false);
};

};


/// @description End outline shader use
function outline_end() {

// Well... it's just a shader reset...
shader_reset();

};

