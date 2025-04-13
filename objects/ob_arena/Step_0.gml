/// @description

image_angle++;
image_xscale = image_yscale + sinInverval(10) * wallSize;

x = xstart + (sinInverval(timerGet(2)) * TILE_SIZE);
y = ystart + (sinInverval(timerGet(1.4)) * TILE_SIZE);

// Rotate and move the box

// adjust coordinares
var _bLength = point_distance(0, 0, image_xscale / 2, image_yscale / 2);
var _bAngle = radtodeg(arctan(abs(image_yscale / 2) / abs(image_xscale / 2))) - image_angle;

var _b4Length = point_distance(0, 0, image_xscale / 2, (image_yscale / 2) - wallSize);
var _b4Angle = radtodeg(arctan(abs((image_yscale / 2) - wallSize) / abs(image_xscale / 2))) + image_angle;

var _b2Length = point_distance(0, 0, (image_xscale / 2) - wallSize, image_yscale / 2);
var _b2Angle = radtodeg(arctan(abs(image_yscale / 2) / abs((image_xscale / 2) - wallSize))) + image_angle;

var _newP1x, _newP1y;
_newP1x = x + lengthdir_x(_bLength, 180 - _bAngle);
_newP1y = y + lengthdir_y(_bLength, 180 - _bAngle);
var _newP2x, _newP2y;
_newP2x = x + lengthdir_x(_b2Length, _b2Angle);
_newP2y = y + lengthdir_y(_b2Length, _b2Angle);
var _newP3x, _newP3y;
_newP3x = x + lengthdir_x(_bLength, -_bAngle);
_newP3y = y + lengthdir_y(_bLength, -_bAngle);
var _newP4x, _newP4y;
_newP4x = x + lengthdir_x(_b4Length, 180 + _b4Angle);
_newP4y = y + lengthdir_y(_b4Length, 180 + _b4Angle);
// Update pointas
var _roundC = 2;
_newP1x = roundDecimal(_newP1x, _roundC);
_newP1y = roundDecimal(_newP1y, _roundC);
_newP2x = roundDecimal(_newP2x, _roundC);
_newP2y = roundDecimal(_newP2y, _roundC);
_newP3x = roundDecimal(_newP3x, _roundC);
_newP3y = roundDecimal(_newP3y, _roundC);
_newP4x = roundDecimal(_newP4x, _roundC);
_newP4y = roundDecimal(_newP4y, _roundC);
// New scales to
//show_debug_message("p1 x: " + string(_newP1x) + ", y: " + string(_newP1y))
// Move to new position
fwallUpdate(wallLeft,	 _newP1x, _newP1y, image_angle);

fwallUpdate(wallTop,	 _newP1x, _newP1y, image_angle);

fwallUpdate(wallRight,	 _newP2x, _newP2y, image_angle);

fwallUpdate(wallBottom,	 _newP4x, _newP4y, image_angle);
