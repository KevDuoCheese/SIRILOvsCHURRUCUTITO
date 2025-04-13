
/// @description Creates a vector 2 that will be used here to control all
function beizerVec2(_x, _y) constructor {
	
	x = _x;
	y = _y;
};

/// @description Due a given series of points get the final point by given a T
function beizerPointsGet(_t) {

// get points count
var _pointsCount = argument_count - 1;
// not enough, return just the point
if (_pointsCount <= 1) { return argument[1]; };
// and interpolate here
var _interpolatedPoints = [ ];

// get all the interpolated points
for (var i = 0; i < (_pointsCount - 1); i++) {
	// get all the points
	var _point1 = argument[i + 1];
	var _point2 = argument[i + 2];
	
	// push in the inerpolated point
	array_push(_interpolatedPoints,
				new beizerVec2(	lerp(_point1.x, _point2.x, _t),
								lerp(_point1.y, _point2.y, _t)));
};

// return it
return script_execute_ext(beizerPointsGet, array_concat([ _t ], _interpolatedPoints));

};

function beizerPointsGetXForTAprox(_xPos, _interpolation) {

// set up this
var _t = 1 / _interpolation;
// get points count
var _pointsCount = argument_count - 2;
var _pointsArray = [ ];
for (var i = 2; i < argument_count; i++) { array_push(_pointsArray, argument[i]); }; // to take on count extra ones

var _lastPointNearX = -1;
var _lastPointFarX = -1;

var _lastPointNearXValue = -1;
var _lastPointFarXValue = -1;

var _pointsApplied = [  ];
// loop here
for (var i = 0; i <= 1; i += _t) {
	var _thisPoints = script_execute_ext(beizerPointsGet, array_concat([ i ], _pointsArray));
	// is less than it
	if (_thisPoints.x < _xPos) {
		// update near
		_lastPointNearX = i;
		_lastPointNearXValue = _thisPoints.x;
		// far is different
		if (_lastPointFarX != -1) {
			var _inter = (_xPos - _lastPointNearXValue) / (_lastPointFarXValue - _lastPointNearXValue);
			// add to applied points
			array_push(_pointsApplied, lerp(_lastPointNearX, _lastPointFarX, _inter));
			// reset near
			_lastPointFarX = -1;
		};
	};
	// is more than it
	if (_thisPoints.x > _xPos) {
		// update near
		_lastPointFarX = i;
		_lastPointFarXValue = _thisPoints.x;
		// far is different
		if (_lastPointNearX != -1) {
			var _inter = (_xPos - _lastPointNearXValue) / (_lastPointFarXValue - _lastPointNearXValue);
			// add to applied points
			array_push(_pointsApplied, lerp(_lastPointNearX, _lastPointFarX, _inter));
			// reset near
			_lastPointNearX = -1;
		};
	};
};

return _pointsApplied;

};

function beizerPointsGetYForTAprox(_yPos, _interpolation) {

// set up this
var _t = 1 / _interpolation;
// get points count
var _pointsCount = argument_count - 2;
var _pointsArray = [ ];
for (var i = 2; i < argument_count; i++) { array_push(_pointsArray, argument[i]); }; // to take on count extra ones

var _lastPointNearY = -1;
var _lastPointFarY = -1;

var _lastPointNearYValue = -1;
var _lastPointFarYValue = -1;

var _pointsApplied = [  ];
// loop here
for (var i = 0; i <= 1; i += _t) {
	var _thisPoints = script_execute_ext(beizerPointsGet, array_concat([ i ], _pointsArray));
	// is less than it
	if (_thisPoints.y < _yPos) {
		// update near
		_lastPointNearY = i;
		_lastPointNearYValue = _thisPoints.y;
		// far is different
		if (_lastPointFarY != -1) {
			var _inter = (_yPos - _lastPointNearYValue) / (_lastPointFarYValue - _lastPointNearYValue);
			// add to applied points
			array_push(_pointsApplied, lerp(_lastPointNearY, _lastPointFarY, _inter));
			// reset near
			_lastPointFarY = -1;
		};
	};
	// is more than it
	if (_thisPoints.y > _yPos) {
		// update near
		_lastPointFarY = i;
		_lastPointFarYValue = _thisPoints.y;
		// far is different
		if (_lastPointNearY != -1) {
			var _inter = (_yPos - _lastPointNearYValue) / (_lastPointFarYValue - _lastPointNearYValue);
			// add to applied points
			array_push(_pointsApplied, lerp(_lastPointNearY, _lastPointFarY, _inter));
			// reset near
			_lastPointNearY = -1;
		};
	};
};

return _pointsApplied;

};