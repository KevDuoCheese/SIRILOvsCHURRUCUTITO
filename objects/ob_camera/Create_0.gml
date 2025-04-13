/// @description Adjust camera and activate it

// Create the camera ID
cameraId = camera_create();
// Set camera size
cameraWidth = screen.width;
cameraHeight = screen.height;
// Camera zoom??
cameraZoom = 1;
// aAdjust angle
cameraAngle = 0;

// View matrix
vM		 = matrix_build_lookat(0, 0, -10, 0, 0, 0, 0, 1, 0);
// Projection matrix
pM		 = matrix_build_projection_ortho(cameraWidth, cameraHeight, -400.0, 32000.0);


// Adjust most recent camera position
cameraX = 0;
cameraY = 0;

// End the camera end script
//camera_set_end_script(cameraId, cameraUpdate());


// View position if this
viewX = 0;
viewY = 0;
// Camera offset from real position
offX = 0;
offY = 0;

// Last X and Y
lastX = undefined;
lastY = undefined;