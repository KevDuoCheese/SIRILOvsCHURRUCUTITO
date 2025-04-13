/// @description Adjust GUI surface size to window size

// Make sure that the GUI surface exists
surfaceGUICheckCreate();

// Is there a difference beetween surface and window
if (surface_get_width(global.guiSurface) != display_get_gui_width() ||
	surface_get_height(global.guiSurface) != display_get_gui_height()) {
	
	// Resize surface to adjust to window size
	surface_resize(global.guiSurface, display_get_gui_width(), display_get_gui_height());
	
	// Show it
	show_debug_message("Updated GUI Surface Size");
};

// Is there a difference beetween view and window
if (view_get_wport(viewId.gui) != display_get_gui_width() ||
	view_get_hport(viewId.gui) != display_get_gui_height()) {
	
	// Adjust width and height port
	view_set_wport(viewId.gui, display_get_gui_width());
	view_set_hport(viewId.gui, display_get_gui_height());
	
	// Show it
	show_debug_message("Updated GUI Viewport Size");
};//*/

// Is there a difference beetween camera and window
if (camera_get_view_width(guiCamera) != display_get_gui_width() ||
	camera_get_view_height(guiCamera) != display_get_gui_height()) {
	
	// Adjust width and height port
	camera_set_view_size(guiCamera, display_get_gui_width(), display_get_gui_height());
	// Activate the camera and enable it to GUI view
	view_camera[viewId.gui]		 = guiCamera;
	
	// Show it
	show_debug_message("Updated GUI Camera Size");
};//*/

// Adjust view surface too

// Check if it exists
if (!surface_exists(global.surfaceMap[? "gui"])) {
	// Get application surface draw width and height
	var _a = application_get_position();
	var _ww = _a[2] - _a[0];
	var _hh = _a[3] - _a[1];
	// And create the surface for GUI camera
	global.surfaceMap[? "gui"] = surface_create(_ww, _hh);
	view_set_surface_id(viewId.gui, global.surfaceMap[? "gui"]);
};
// Complete it
surface_set_target(global.surfaceMap[? "gui"]);
draw_clear_alpha(c_black, 0);
surface_reset_target();


// No view activated in room
if (!view_get_visible(viewId.gui)) {
	
	// Adjust width and height port
	view_set_wport(viewId.gui, screen.width);
	view_set_hport(viewId.gui, screen.height);
	// Enable this dude
	view_set_surface_id(viewId.gui, global.surfaceMap[? "gui"]);
	// Actviate visible on it
	view_set_visible(viewId.gui, true);
	
	// Activate the camera and enable it to GUI view
	view_camera[viewId.gui]		 = guiCamera;
	// Tahts it
	show_debug_message("Activated GUI view and camera");
};//*/