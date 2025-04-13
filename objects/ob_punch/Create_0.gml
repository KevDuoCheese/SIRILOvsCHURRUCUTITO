/// @description 
depth = -15;
image_xscale = 12 * TILE_SIZE;
image_yscale = 3 * TILE_SIZE;
// Set my X value
y = screen.height / 2;
x = screen.width / 2;

// Set up effects
animValue = 0;
// Where are we
phase = 0;

destroyTimer = timerGet(1);

indexPos = 0;
indexActive = false;

indexAlpha = 0;
indexAlphaShift = 1 / 5;
// Reach middle in 15 frames
indexShift = ((image_xscale / 2) / timerGet(0.5)) / (image_xscale / 2);
