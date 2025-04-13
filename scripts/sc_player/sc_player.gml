
function npcMoveX(xSpd, preYSpd = preYSpeed) {

var _pFix = .1;

// Ajudst here the shot direction
var _rayDirection, _bboxSide, _bboxSideInv, _bboxDistance, _bboxSign;
// Has X speed
if (xSpd != 0) {
// On positive way
if (xSpd > 0) {
	_rayDirection = DIR_RIGHT;
	_bboxSide = bbox_right;
	_bboxDistance = bbox_right - x;
	_bboxSideInv = bbox_left;
	_bboxSign = 1;
} else {
	_rayDirection = DIR_LEFT;
	_bboxSide = bbox_left;
	_bboxDistance = bbox_left - x;
	_bboxSideInv = bbox_right;
	_bboxSign = -1;
};

// Get the positions rays
var _rayUp, _rayMedium, _rayBottom;
_rayUp		 = colRay(x, bbox_top + _pFix,	 _rayDirection, abs(xSpd) + abs(_bboxDistance) + 0.1);
_rayMedium	 = colRay(x, y,					 _rayDirection, abs(xSpd) + abs(_bboxDistance));
_rayBottom	 = colRay(x, bbox_bottom - _pFix,	 _rayDirection, abs(xSpd) + abs(_bboxDistance) + 0.1);

// Has collide here
if (_rayBottom.found || _rayUp.found) {
	
	var _choosenRay, _choosenRaySign = 0; // 1 bottom -1 up
	// Found both
	if (_rayBottom.found && _rayUp.found) {
		// Choose shorter distance
		if (_rayBottom.distance < _rayUp.distance) { _choosenRay = _rayBottom; _choosenRaySign = 1; }
		else { _choosenRay = _rayUp; _choosenRaySign = -1; };
	} else if (_rayBottom.found) { _choosenRay = _rayBottom; _choosenRaySign = 1;  } else { _choosenRay = _rayUp; _choosenRaySign = -1;  };
	// How much distance has done
	var _distance = _choosenRay.distance - abs(_bboxDistance);
	var _normalAngle = _choosenRay.normal_angle;
	
	// Whats the angle of the collide wall?
	show_debug_message("xANGLE: " + string(_normalAngle));
	debugXAngle = _normalAngle;
	// How much distance has done?
	x += _distance * sign(xSpd);
	
	// Is not a rect wall
	if ((abs(_normalAngle) != 90) && (abs(_normalAngle) != 0) && (abs(_normalAngle) != 180)) {
		
		// The angle is going down
		if (angleInRange(180, 360, _normalAngle)) { _normalAngle = angle_difference(_normalAngle + (90 * _bboxSign), 0); }
		else { _normalAngle = angle_difference(_normalAngle - (90 * _bboxSign), 0); };
		debugXAngle = _normalAngle;
		
		var _newDistance = max(abs(xSpd) - _distance, 0);
		// Shot rays in the direction
		var _extraUL, _extraUR, _extraDL, _extraDR;
		_extraUL = colRay(bbox_left,	bbox_top,		_normalAngle, _newDistance);
		_extraUR = colRay(bbox_right,	bbox_top,		_normalAngle, _newDistance);
		_extraDL = colRay(bbox_left,	bbox_bottom,	_normalAngle, _newDistance);
		_extraDR = colRay(bbox_right,	bbox_bottom,	_normalAngle, _newDistance);
		// Ignore one of those rays
		if (_choosenRaySign > 0) {
			if (_bboxSign > 0) { _extraDR.found = false; _extraDR.distance = 0; }
			else { _extraDL.found = false; _extraDL.distance = 0; };
		} else {
			if (_bboxSign > 0) { _extraUR.found = false; _extraUR.distance = 0; }
			else { _extraUL.found = false; _extraUL.distance = 0; };
		};
		// One of them found something
		if (_extraUL.found || _extraUR.found || _extraDL.found || _extraDR.found) {
			// Choose distance
			_newDistance = min(_extraDR.distance, _extraDL.distance, _extraUR.distance, _extraUL.distance);
		};
		
		
		// Conditioner
		var _conditioner = lengthdir_y(_newDistance, _normalAngle);
		if ((sign(_conditioner) == sign(preYSpd)) || (preYSpd == 0)) {
			// Add position
			x += lengthdir_x(_newDistance, _normalAngle);
			y += lengthdir_y(_newDistance, _normalAngle);
		};
	};
// Only medium side
} else if (_rayMedium.found) {
	var _mov = (_rayMedium.distance - abs(_bboxDistance)) * sign(xSpd);
	// Add only the distance of ray
	x += _mov;
	// Is now colliding?
	if (colMeeting(mask_index, x, y)) {
		//x -= _mov;
	};
	
} else {
	// Just add the position
	x += xSpd;
};
};

return xSpd;

};

function npcMoveY(ySpd, preXSpd = preXSpeed) {

var _pFix = .1;

// Ajudst here the shot direction
var _rayDirection, _bboxSide, _bboxSideInv, _bboxDistance, _bboxSign;
// Only if has Y speed
if (ySpd != 0) {
// On positive way
if (ySpd > 0) {
	_rayDirection = DIR_BOTTOM;
	_bboxSide = bbox_bottom;
	_bboxDistance = bbox_bottom - y;
	_bboxSideInv = bbox_top;
	_bboxSign = 1;
} else {
	_rayDirection = DIR_TOP;
	_bboxSide = bbox_top;
	_bboxDistance = bbox_top - y;
	_bboxSideInv = bbox_bottom;
	_bboxSign = -1;
};

// Get the positions rays
var _rayLeft, _rayMedium, _rayRight;
_rayLeft	 = colRay(bbox_left + _pFix,	 y,	 _rayDirection, abs(ySpd) + abs(_bboxDistance) + 0.1);
_rayMedium	 = colRay(x,				 y,	 _rayDirection, abs(ySpd) + abs(_bboxDistance));
_rayRight	 = colRay(bbox_right - _pFix,	 y,	 _rayDirection, abs(ySpd) + abs(_bboxDistance) + 0.1);

// Has collide here
if (_rayRight.found || _rayLeft.found) {
	
	var _choosenRay, _choosenRaySign = 0; // 1 bottom -1 up
	// Found both
	if (_rayRight.found && _rayLeft.found) {
		// Choose shorter distance
		if (_rayRight.distance < _rayLeft.distance) { _choosenRay = _rayRight; _choosenRaySign = 1; }
		else { _choosenRay = _rayLeft; _choosenRaySign = -1; };
	} else if (_rayRight.found) { _choosenRay = _rayRight; _choosenRaySign = 1; } else { _choosenRay = _rayLeft; _choosenRaySign = -1;  };
	// How much distance has done
	var _distance = _choosenRay.distance - abs(_bboxDistance);
	var _normalAngle = _choosenRay.normal_angle;
	
	// Whats the angle of the collide wall?
	show_debug_message("yANGLE: " + string(_normalAngle));
	debugYAngle = _normalAngle;
	// How much distance has done?
	y += _distance * sign(ySpd);
	
	// Is not a rect wall
	if ((abs(_normalAngle) != 90) && (abs(_normalAngle) != 0) && (abs(_normalAngle) != 180)) {
		
		// The angle is going down
		if (angleInRange(90, 270, _normalAngle)) { _normalAngle = angle_difference(_normalAngle + (90 * _bboxSign), 0); }
		else { _normalAngle = angle_difference(_normalAngle - (90 * _bboxSign), 0); };
		debugYAngle = _normalAngle;
		
		
		var _newDistance = max(abs(ySpd) - _distance, 0);
		// Shot rays in the direction
		var _extraUL, _extraUR, _extraDL, _extraDR;
		_extraUL = colRay(bbox_left,	bbox_top,		_normalAngle, _newDistance);
		_extraUR = colRay(bbox_right,	bbox_top,		_normalAngle, _newDistance);
		_extraDL = colRay(bbox_left,	bbox_bottom,	_normalAngle, _newDistance);
		_extraDR = colRay(bbox_right,	bbox_bottom,	_normalAngle, _newDistance);
		// Ignore one of those rays
		// Is the right side ray
		if (_choosenRaySign > 0) {
			// Bottom Right
			if (_bboxSign > 0) { _extraDR.found = false; _extraDR.distance = 0; }
			// Top Right
			else { _extraUR.found = false; _extraUR.distance = 0; };
		// Left side ray
		} else {
			// Bottom Left
			if (_bboxSign > 0) { _extraDL.found = false; _extraDL.distance = 0; }
			// Top Left
			else { _extraUL.found = false; _extraUL.distance = 0; };
		};
		// One of them found something
		if (_extraUL.found || _extraUR.found || _extraDL.found || _extraDR.found) {
			// Choose distance
			_newDistance = min(_extraDR.distance, _extraDL.distance, _extraUR.distance, _extraUL.distance);
		};
		
		
		// Conditioner
		var _conditioner = lengthdir_x(_newDistance, _normalAngle);
		if ((sign(_conditioner) == sign(preXSpd)) || (preXSpd == 0)) {
			// Add position
			x += lengthdir_x(_newDistance, _normalAngle);
			y += lengthdir_y(_newDistance, _normalAngle);
		};
	};
// Only medium side
} else if (_rayMedium.found) {
	
	var _mov = (_rayMedium.distance - abs(_bboxDistance)) * sign(ySpd);
	// Add only the distance of ray
	y += _mov;
	// Is now colliding?
	if (colMeeting(mask_index, x, y)) {
		//y -= _mov;
	};
} else {
	// Just add the position
	y += ySpd;
};
};

return ySpd;

};