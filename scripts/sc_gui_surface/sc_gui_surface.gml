/// Control the GUI surface from other objects

/// @description Check if GUI surface exists or not
function surfaceGUICheckCreate() {

// If doesn't exists GUI surface
if (!surface_exists(global.guiSurface)) {
	
	// Create again GUI surface
	global.guiSurface = surface_create(display_get_gui_width(), display_get_gui_height());
};

};

/// @description Surface GUI width boi
function surfaceGUIGetWidth() {

// Return GUI height
return display_get_gui_width();

};


/// @description Surface GUI height my man
function surfaceGUIGetHeight() {

// Return GUI height
return display_get_gui_height();

};

/// @description If drawing in GUI surface, take a custom blending mode
function surfaceGUICustomBlend() {

// Set blendmode to normal
gpu_set_blendmode(bm_normal);

};

/// @description If drawing in GUI surface, reset default blending
function surfaceGUIResetBlend() {

// Reset to GUI blend
gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);

};

/// @description If drawing in GUI surface, use another shader
function surfaceGUICustomShader() {

// Reset shader
shader_reset();

};

/// @description If drawing in GUI surface, back to normal shader
function surfaceGUIResetShader() {

// Reset to GUI blend
shader_set(sh_alpha_surface);

};

/// @description Use a custom surface in GUI drawing
function surfaceGUICustomSurface() {

// Reset GUI surface
surface_reset_target();

// Reset everything
surfaceGUICustomShader();
surfaceGUICustomBlend();

};

/// @description Back to using surface in GUI drawing
function surfaceGUIResetSurface() {

// Make sure that the GUI surface exists
surfaceGUICheckCreate();
// Has surface selected, reset target
if (surface_get_target() > 0) { surface_reset_target(); };
// Reset GUI surface
surface_set_target(global.guiSurface);

// Reset everything
surfaceGUIResetShader();
surfaceGUIResetBlend();

};