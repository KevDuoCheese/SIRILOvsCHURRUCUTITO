/// @description Draw surface

// Get surface position on screen
var _aP = application_get_position();
// Adjust given data
var _topX, _topY, _w, _h;
_topX = _aP[0];
_topY = _aP[1];
_w = _aP[2] - _aP[0];
_h = _aP[3] - _aP[1];

// Draw surface
//draw_clear(c_black);
draw_surface_stretched(application_surface, _topX, _topY, _w, _h);


















