
/// @description Get the points of a rotated rectangle
function rotatedRectanglePoints(_posX, _posY, _offX, _offY, _width, _height, _rotAngle) {

// get the points here
var _p1x, _p1y, _p2x, _p2y, _p3x, _p3y, _p4x, _p4y;
// set here
_p1x = _posX - vector2XAngled(_offX, _offY, _rotAngle);
_p1y = _posY - vector2YAngled(_offX, _offY, _rotAngle);
// set second point
_p2x = _p1x + lengthdir_x(_width, _rotAngle);
_p2y = _p1y + lengthdir_y(_width, _rotAngle);

// set the third point
_p3x = _p2x + lengthdir_x(_height, _rotAngle - 90);
_p3y = _p2y + lengthdir_y(_height, _rotAngle - 90);

// set the final point
_p4x = _p3x + lengthdir_x(_width, _rotAngle - 180);
_p4y = _p3y + lengthdir_y(_width, _rotAngle - 180);


return	[
			new Vec2(_p1x, _p1y),
			new Vec2(_p2x, _p2y),
			new Vec2(_p3x, _p3y),
			new Vec2(_p4x, _p4y)
		];

};

/// @description
function mouseInRotatedRectangle(_posX, _posY, _offX, _offY, _width, _height, _rotAngle) {


// return this shit
return point_in_polygon(mouseGetX(), mouseGetY(),
						rotatedRectanglePoints(_posX, _posY, _offX, _offY, _width, _height, _rotAngle));

};

/// @description
function mouseInGUIRotatedRectangle(_posX, _posY, _offX, _offY, _width, _height, _rotAngle) {


// return this shit
return point_in_polygon(windowGetMouseX(), windowGetMouseY(),
						rotatedRectanglePoints(_posX, _posY, _offX, _offY, _width, _height, _rotAngle));

};