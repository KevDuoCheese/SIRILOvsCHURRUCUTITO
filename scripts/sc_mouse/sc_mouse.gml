
/// @description Get mouse X in window, Uses in GUI
function windowGetMouseX() {

return clamp(device_mouse_x_to_gui(0), 0, display_get_gui_width());//mouse_x - ob_Control.CamX;//window_mouse_get_x();

};

/// @description Get mouse Y in window, Uses in GUI
function windowGetMouseY() {

return clamp(device_mouse_y_to_gui(0), 0, display_get_gui_height());//mouse_y - ob_Control.CamY;//window_mouse_get_y();

};

/// @arg x1
/// @arg y1
/// @arg x2
/// @arg y2
/// @description Mouse inside a box in world space
function mouseIn(x1, y1, x2, y2){

// Set variables
var _return;
_return = false;

// Mouse must be in
if ((mouseGetX() >= x1 && mouseGetX() < x2) && (mouseGetY() >= y1 && mouseGetY() < y2))
{
	// Set return to true
	_return = true;
};

// Return obtained variable
return _return;

};

/// @arg x1
/// @arg y1
/// @arg x2
/// @arg y2
/// @description Mouse inside a box in GUI layer
function mouseInGUI(x1, y1, x2, y2) {

// Set variables
var _return;
_return = false;

// Mouse must be in
if ((windowGetMouseX() >= x1 && windowGetMouseX() < x2) && (windowGetMouseY() >= y1 && windowGetMouseY() < y2))
{
	// Set return to true
	_return = true;
};

// Return obtained variable
return _return;

//return point_in_rectangle(windowGetMouseX(), windowGetMouseY(), x1, y1, x2, y2);

};
