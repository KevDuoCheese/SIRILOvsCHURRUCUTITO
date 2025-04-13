
/// @description Take a custom blending mode
function surfaceEndBlend() {

// Set blendmode to normal
gpu_set_blendmode(bm_normal);

};
/// @description Reset default blending
function surfaceSetBlend() {

// Reset to GUI blend
gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);

};

/// @description Use another shader
function surfaceEndShader() {

// Reset shader
shader_reset();

};
/// @description Back to normal shader
function surfaceSetShader() {

// Reset to GUI blend
shader_set(sh_alpha_surface);

};


/// @description Set shader and blend mode for surface
function surfaceSetAll() {

// Set all at once
surfaceSetShader();
surfaceSetBlend();

};
/// @description Clear all
function surfaceEndAll() {

// End blendmode and shader use
surfaceEndBlend();
surfaceEndShader();

};


/// @description Set shader and blend mode for surface
function surfaceSet(surfId) {

// Set blendmode and shader use
surfaceSetAll();
// And surface use
surface_set_target(surfId);

};
/// @description Clear all and surface use too
function surfaceEnd() {

// End blendmode and shader use
surfaceEndAll();
// And surface use
surface_reset_target();

};


/// @description Resize to max size
function surfaceResizeMax(surfId, maxWidth, maxHeight) {

// One of the variables is lower thanrequired
if ((surface_get_width(surfId) < maxWidth ) ||
	(surface_get_height(surfId) < maxHeight)) {
	
	// Resize surface to max
	surface_resize(surfId,	 max(maxWidth, surface_get_width(surfId)),
							 max(maxHeight, surface_get_height(surfId)));
};

};
/// @description Create surface if it doesn't exists
function surfaceExists(surfId, startWidth = 1, startHeight = 1) {

// Adjust text surface
if (!surface_exists(surfId)) {
	// Create a surface for font
	return surface_create(startWidth, startHeight);
};

return surfId;

};
