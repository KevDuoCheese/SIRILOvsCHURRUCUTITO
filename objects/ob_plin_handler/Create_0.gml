/// @description To do the plin animation

// get the phase we ahre
phase = 0;
// wait to plin
plinWait = timerGet(0.2);

// get the actual zoom
camOcZoom = cameraGetZoom();
camZoomIncrease = 0.0015;

// now if it can
canDestroy = false;

// you decide this bro
plinPower = 0;