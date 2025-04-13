/// @description If the view isn't enabled

// No view activated in room
if (!view_enabled || !view_get_visible(viewId.draw)) {
	
	// Adjust width and height port
	view_set_wport(viewId.draw, screen.width);
	view_set_hport(viewId.draw, screen.height);
	// Enable this dude
	view_set_surface_id(viewId.draw, application_surface);
	// Actviate visible on it
	view_set_visible(viewId.draw, true);
	
	// Set view and project matrix
	camera_set_view_mat(cameraId, vM);
	camera_set_proj_mat(cameraId, pM);
	// Activate the camera and enable it
	view_camera[viewId.draw]		 = cameraId;
	
	// Enable view
	view_enabled = true;
};

// changed surface?
if (view_get_surface_id(viewId.draw) != application_surface) { view_set_surface_id(viewId.draw, application_surface); };

// It's different
if (lastX != viewX ||
	lastY != viewY) {
	// Update camera new positions 
	cameraUpdatePosition();
};
