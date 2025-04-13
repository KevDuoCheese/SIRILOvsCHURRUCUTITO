/// @description Create a GUI surface to use this, oh boi

// Adjust ma depth
depth = -1500;


// Create the GUI surface
global.guiSurface = surface_create(display_get_gui_width(), display_get_gui_height());
// create a GUI camera
guiCamera = camera_create_view(0, 0, display_get_gui_width(), display_get_gui_height());
