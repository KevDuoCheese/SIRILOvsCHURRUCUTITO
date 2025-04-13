/// @description 
if (!drawCan()) { exit; };

if (debugVGetValue("showData")) {
	draw_sprite(sprite_index, 0, x, y);
};

// Get vertex from each point of the rectangles
var _dV1, _dV2, _dV3, _dV4;
_dV1 = wallLeft.colPoints[0];
_dV2 = wallRight.colPoints[1];
_dV3 = wallRight.colPoints[2];
_dV4 = wallLeft.colPoints[3];

// Draw debug mode
draw_set_color(c_black);

// Start this
draw_primitive_begin(pr_trianglefan);
// Add a;; vertex
draw_vertex(_dV1.x, _dV1.y);
draw_vertex(_dV2.x, _dV2.y);
draw_vertex(_dV3.x, _dV3.y);
draw_vertex(_dV4.x, _dV4.y);

// Draw the final shape
draw_primitive_end();