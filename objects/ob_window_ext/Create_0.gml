/// @description Start variables

depth = -15;

// Init the nineslice shit 
nineslice_init(sprite_index, image_index);

// Set image X and Y scale
image_xscale = sprite_width;
image_yscale = sprite_height;

// Get optional bounds uniform
uniBounds = shader_get_uniform(sh_clip, "u_bounds");
uniAlphaBounds = shader_get_uniform(sh_clip_alpha_surface, "u_bounds");

// For menus
depthOwner = noone;
depthLevel = -1;
depthId = "";

// Yup, this one has open and close animations
phase = 0;
// Visual scales for this one
visualXScale = 1;
visualYScale = 1;
// Take this as offsets
visualX = 0;
visualY = 0;
// yup
visualAlpha = 1;

// Works with animation curves
animOpen = -1;
animIdle = -1;
animClose = -1;
// animation value
value = 0;

// Close window
closeTrigger = function () {
	// Set to close animation
	phase = 2;
	value = 0;
};

wSetAnimCurve = function (cId) {
	
	// get shift value
	value += 1 / animcurveRead(cId, "shiftFrames", 0, 15);
	// Set visual scales
	visualXScale = animcurveRead(cId, "xScale", value, 1);
	visualYScale = animcurveRead(cId, "yScale", value, 1);
	// Set visual position offset
	visualX = animcurveRead(cId, "x", value, 0);
	visualY = animcurveRead(cId, "y", value, 0);
	// Image alpha
	visualAlpha = animcurveRead(cId, "alpha", value, 1);
};

windowInsideDrawFunction = function () {
	
	
};