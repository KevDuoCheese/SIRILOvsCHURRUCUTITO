
/// @description Returns the camera ID from camera object
function cameraGetId() {

// Return camera ID my man
return ob_camera.cameraId;

};

/// @description Force camera object to update camera to a new position
function cameraUpdatePosition() {

// Update camera new positions 
var newCamX, newCamY;
newCamX = ob_camera.viewX + (cameraGetWidth() * 0.5) + ob_camera.offX;
newCamY = ob_camera.viewY + (cameraGetHeight() * 0.5) + ob_camera.offY;


var _xUp, _yUp;
_xUp = cos(degtorad(ob_camera.cameraAngle + 90));
_yUp = sin(degtorad(ob_camera.cameraAngle + 90));

// Update this dude
ob_camera.vM = matrix_build_lookat(newCamX, newCamY, -10, newCamX, newCamY, 0, _xUp, _yUp, 0);
// Set view matrix again
camera_set_view_mat(ob_camera.cameraId, ob_camera.vM);

// Update this
ob_camera.lastX = ob_camera.viewX;
ob_camera.lastY = ob_camera.viewY;
// And camera too
cameraUpdate();

};

/// @description Force camera object to update camera width and height
function cameraUpdateSize() {

// Update this dude
ob_camera.pM = matrix_build_projection_ortho(ob_camera.cameraWidth, ob_camera.cameraHeight, -400.0, 32000.0);
// Set view projection again
camera_set_proj_mat(ob_camera.cameraId, ob_camera.pM);

};


/// @description Update camera variables of it
function cameraUpdate() {

// Update camera position
ob_camera.cameraX = ob_camera.viewX;
ob_camera.cameraY = ob_camera.viewY;

};

/// @description Update camera angle
function cameraSetAngle(newAngle) {

// Adjust view angle
ob_camera.cameraAngle = newAngle;
// And update camera position
cameraUpdatePosition();


};

/// @description Set camera to a new position my man
function cameraSetPosition(newX, newY) {

// Set new view position oh boi
ob_camera.viewX = newX;
ob_camera.viewY = newY;

// And update camera position
cameraUpdatePosition();

};

/// @description Modify camera offset
function cameraSetOffset(newX, newY) {

// Set it
ob_camera.offX = newX;
ob_camera.offY = newY;

// And update camera position
cameraUpdatePosition();

};

/// @description Set camera size
function cameraSetZoom(newZoom) {

// Update zoom value
ob_camera.cameraZoom = newZoom;
// Get real zoom dude
var realZoom = 1 / ob_camera.cameraZoom;
// Get middle position of this shit
var newCamX, newCamY;
newCamX = cameraGetX() + (cameraGetWidth() / 2);
newCamY = cameraGetY() + (cameraGetHeight() / 2);

// Get new width and height man
ob_camera.cameraWidth		 = screen.width * realZoom;
ob_camera.cameraHeight		 = screen.height * realZoom;
// Update camera size
cameraUpdateSize();

// Adjust to new position
newCamX -= cameraGetWidth() / 2;
newCamY -= cameraGetHeight() / 2;
// Update position
cameraSetPosition(newCamX, newCamY);

};

/// @description Get camera angle
function cameraGetAngle() { return ob_camera.cameraAngle; };

/// @description Get camera real zoom of this shit
function cameraGetRealZoom()	 { return 1 / ob_camera.cameraZoom; };
/// @description Get camera interior zoom using
function cameraGetZoom()		 { return ob_camera.cameraZoom; };


/// @description As the name says, returns camera X
function cameraGetX() { return ob_camera.cameraX; };

/// @description This gives you bread, jk, returns camera Y
function cameraGetY() { return ob_camera.cameraY; };


/// @description Returns camera X offset value
function cameraGetOffX() { return ob_camera.offX; };

/// @description Same as Get X, this returns Y
function cameraGetOffY() { return ob_camera.offY; };


/// @description Get camera width boy
function cameraGetWidth() { return ob_camera.cameraWidth; };

/// @description Obtain camera height my man
function cameraGetHeight() { return ob_camera.cameraHeight; };


/// @description Get mouse position in X
function mouseGetX() {

// Get display dude, the mouse X in there
var windowMouseX = window_mouse_get_x();
// Get camera dude
var _camX = cameraGetX();
var _camW = cameraGetWidth();

// To return this back
return floor(remap(windowMouseX, 0, window_get_width(), _camX, _camX + _camW));

};
/// @description Get mouse position in Y
function mouseGetY() {

// Get display dude, the mouse Y in there
var windowMouseY = window_mouse_get_y();
// Get camera dude
var _camY = cameraGetY();
var _camH = cameraGetHeight();

// To return this back
return floor(remap(windowMouseY, 0, window_get_height(), _camY, _camY + _camH));

};