/// @description Adjust size and colors

if (buttonActive) {
	
	// Increase size by lerp
	image_xscale = lerp(image_xscale, 1.05, 0.15);
} else {
	
	// Decrease size by lerp
	image_xscale = lerp(image_xscale, 1, 0.25);
};
// Lock to X scale
image_yscale = image_xscale;