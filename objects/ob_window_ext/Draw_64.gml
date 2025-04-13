/// @description Draw the stupid window in GUI surface

// Reset GUI shader
surfaceGUICustomShader();

var _drawX, _drawY, _xScale, _yScale;
_drawX = x - (((visualXScale * image_xscale) - image_xscale) * 0.5) + visualX;
_drawY = y - (((visualYScale * image_yscale) - image_yscale) * 0.5) + visualY;

_xScale = image_xscale * visualXScale;
_yScale = image_yscale * visualYScale;

// Draw the nineslice
draw_d_nineslice_ext(	_drawX, _drawY,
						_xScale, _yScale, image_blend, image_alpha * visualAlpha);

// Back to GUI normal thing
surfaceGUIResetShader();

// Create window surface
if (!surface_exists(global.cMenuSurfWindow)) { global.cMenuSurfWindow = surface_create(image_xscale, image_yscale); };
// Resize window shit
if ((surface_get_height(global.cMenuSurfWindow) < image_yscale) || (surface_get_width(global.cMenuSurfWindow) < image_xscale)) {
	
	// Resize it bro
	surface_resize(	global.cMenuSurfWindow,
					max(surface_get_width(global.cMenuSurfWindow), image_xscale),
					max(surface_get_height(global.cMenuSurfWindow), image_yscale));
};

surfaceGUICustomSurface();
surface_set_target(global.cMenuSurfWindow);
// Clear surface
draw_clear_alpha(c_black, 0);
gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
shader_set(sh_alpha_surface);

// Reset the drawing mode
drawPreset("general");

windowInsideDrawFunction();

// Reset surface to normal
gpu_set_blendmode(bm_normal);
shader_reset();
surface_reset_target();
surfaceGUIResetSurface();

// Draw the fucking surface
draw_surface_ext(global.cMenuSurfWindow, _drawX, _drawY, visualXScale, visualYScale, 0, c_white, image_alpha * visualAlpha);