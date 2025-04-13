
enum kesoAnimCurveType {
	animcurve,
	channel
};

enum kesoAnimCurveCurveType {
	linear,
	beizer
};

function kesoAnimCurveCore(_name) constructor {
	// set up
	name = _name;
	// herit
	mySelf = self;
	parent = noone;
	// and get that out
	type = -1;
};

/// @description Creates a keso animation curve
function kesoAnimCurve(_name) : kesoAnimCurveCore(_name) constructor {
	// set up type
	type = kesoAnimCurveType.animcurve;
	
	// here get all the channels
	channels = [ ];
	// get channel
	static channelGet = function (_channelName) {
		// loop for it
		for (var i = 0; i < array_length(channels); i++) {
			// delete the channel here
			if (channels[i].name == _channelName) { return channels[i]; };
		};
		
		return noone;
	};
	// get channel iD
	static channelGetID = function (_channelName) {
		// loop for it
		for (var i = 0; i < array_length(channels); i++) {
			// delete the channel here
			if (channels[i].name == _channelName) { return i; };
		};
		
		return -1;
	};
	// does channel exists
	static channelExists = function (_channelName) {
		// loop for it
		for (var i = 0; i < array_length(channels); i++) {
			// delete the channel here
			if (channels[i].name == _channelName) { return true; };
		};
		
		return false;
	};
	// to add channel
	static channelAdd = function (_channelIns) {
		// save up here
		for (var i = 0; i < argument_count; i++) {
			// push it
			array_push(channels, argument[i]);
			argument[i].parent = mySelf;
		};
	};
	// to delete a channel
	static channelDelete = function (_channelName) {
		// search for it
		array_delete(channels, channelGetID(_channelName), 1);
	};
	// to read channel
	static channelRead = function (_channelName, _valueX, _defaultV = 0) {
		
		// get the id
		var _channelId = channelGetID(_channelName);
		// found?
		if (_channelId != -1) {
			// return it
			return channelGet(_channelName).checkOnX(_valueX);
		};
		
		return _defaultV;
	};
};

function kesoAnimCurveChannel(_name, _pointStartY, _pointEndY, _pointType) : kesoAnimCurveCore(_name) constructor {
	// set up the colors
	points = [ ];
	// yup this is up
	pointType = _pointType;
	
	// for default values
	limitTop = 10;
	limitBottom = -10;
	
	static limitSetTop = function (_newTop) { limitTop = _newTop; };
	
	static limitSetBottom = function (_newBottom) { limitBottom = _newBottom; };
	
	
	static pointGet = function(_pointIndex) { return points[_pointIndex]; };
	
	static pointAdd = function(_point) {
		
		var _toInsert = 0;
		// search up
		for (var i = 0; i < array_length(points); i++) {
			var _pIns = points[i];
			// X is more
			if (_pIns.x > _point.x) { _toInsert++; break; } else {
				// insert here
				_toInsert = i;
			};
		};
		// is bigger than last point?
		if (array_length(points) >= 1) {
			if (points[array_length(points) - 1].x <= _point.x) { _toInsert = array_length(points); };
		};
		
		// inser it
		_point.parent = mySelf;
		// push that in
		array_insert(points, _toInsert, _point);
		show_debug_message(points);
		// update point
		pointUpdate();
		
		return _toInsert;
	};
	
	static pointDelete = function(_pointIndex) { array_delete(points, _pointIndex, 1); };
	
	// add the first points
	static pointUpdate = function () {
		
		var _xPrev, _xNext;
		
		// search up
		for (var i = 0; i < array_length(points); i++) {
			var _pIns = points[i];
			// has prev?
			if ((i - 1) >= 0) {
				// set it up
				_xPrev = points[i - 1].x;
			} else { _xPrev = 0; };
			// has next?
			if ((i + 1) < array_length(points)) {
				// set it up
				_xNext = points[i + 1].x;
			} else { _xNext = 1; };
			
			// update the points
			_pIns.pointUpdate(_xPrev, _xNext);
		};
	};
	
	static searchForX = function (_x) {
		
		// nd check here
		for (var i = 0; i < array_length(points); i++) {
			// reached here
			if (points[i].x == _x) { return i; };
		};
		
		return -1;
	};
	
	static searchForLowerX = function (_x) {
		// get the points that are here
		var _pointSelected = 0;
		// nd check here
		for (var i = 0; i < array_length(points); i++) {
			// reached here
			if (points[i].x >= _x) { break; } else {
				// set up here
				_pointSelected = i;
			};
		};
		
		return _pointSelected;
	};
	
	static checkOnX = function (_x) {
		// get the points that are here
		var _pointSelected = 0;
		// nd check here
		for (var i = 0; i < (array_length(points) - 1); i++) {
			// reached here
			if (points[i].x >= _x) { _pointSelected = i - 1; break; } else {
				// set up here
				_pointSelected = i;
			};
		};
		_pointSelected = max(_pointSelected, 0);
		
		// now this is the pair of selected points
		var _cPointA, _cPointB, _cPointC, _cPointD;
		_cPointA = [	points[_pointSelected].x, 
		
						points[_pointSelected].y ];
		
		_cPointB = [	(points[_pointSelected].x	 + points[_pointSelected].rPX), 
		
						points[_pointSelected].y	 + points[_pointSelected].rPY ];
		
		_cPointC = [	(points[_pointSelected + 1].x	 + points[_pointSelected + 1].lPX), 
		
						points[_pointSelected + 1].y	 + points[_pointSelected + 1].lPY ];
		
		_cPointD = [	points[_pointSelected + 1].x, 
		
						points[_pointSelected + 1].y ];
		
		// get teh solver
		var _aForX = ((3 * _cPointB[0]) - (3 * _cPointC[0]) + _cPointD[0] - _cPointA[0]);
		var _bForX = 3 * (_cPointA[0] - (2 * _cPointB[0]) + _cPointC[0]);
		var _cForX = 3 * (_cPointB[0] - _cPointA[0]);
		var _dForX = _cPointA[0] - _x;
		// and solve for it
		var _solutions;
		// has it?
		if (_aForX != 0) {
			_solutions = algCubicFormulaResolveForRealRoots(_aForX, _bForX, _cForX, _dForX);
		} else if (_bForX != 0) {
			_solutions = algSquareFormulaResolveForRealRoots(_bForX, _cForX, _dForX);
		} else if (_cForX != 0) {
			_solutions = -_dForX / _cForX;
		} else {
			_solutions = [ _cPointA[0] ];
		};
		var _endT = -1;
		// seach for the answer
		for (var i = 0; i < array_length(_solutions); i++) {
			// is it?
			if (_solutions[i] <= 1 && _solutions[i] >= 0) {
				_endT = _solutions[i];
				break;
			};
		};
		// no solutions?
		if (_endT == -1) {
			// then found the nearest
			if ((_x - _cPointA[0]) < (_cPointD[0] - _x)) {
				// set it up
				return _cPointA[1];
			} else {
				// the other one
				return _cPointD[1];
			};
		};
		
		var _appliedPoint = beizerPointsGet(_endT,
					new beizerVec2(_cPointA[0], _cPointA[1]),
					new beizerVec2(_cPointB[0], _cPointB[1]),
					new beizerVec2(_cPointC[0], _cPointC[1]),
					new beizerVec2(_cPointD[0], _cPointD[1]));
		
		//show_debug_message("finalp: " + string(_appliedPoint))
		
		return _appliedPoint.y;
	};
	
	// insert points
	pointAdd(new kesoAnimCurvePoint("pStart",	 0, _pointStartY, pointType));
	pointAdd(new kesoAnimCurvePoint("pEnd",		 1, _pointEndY, pointType));
	// lock up those
	pointGet(0).lockedX = true;
	pointGet(1).lockedX = true;
};

/// @description the points here
function kesoAnimCurvePoint(_name, _xPos, _yPos, _pointType) : kesoAnimCurveCore(_name) constructor {
	// this up
	pointType = _pointType;
	lockedX = false;
	
	// and x
	x = _xPos;
	y = _yPos;
	// the left point
	lPX = -0.1;
	lPY = 0;
	// the right point
	rPX = 0.1;
	rPY = 0;
	// set up
	xMin = 0;
	xMax = 1;
	
	static setPosition = function (_newX, _newY) {
		// set up the X
		if (!lockedX) { x = clamp(_newX, xMin, xMax); };
		y = _newY;
		// and update here
		parent.pointUpdate();
	};
	
	/// @description
	static setRPosition = function (_newRX, _newRY, _aspectX, _aspectY) {
		
		// set up RX
		rPX = max(0, _newRX - x);
		rPY = _newRY - y;
		
		
		// set up tan
		var _angle = point_direction(0, 0, rPX * _aspectX, rPY * _aspectY) + 180;
		// set up distance
		var _distance = point_distance(0, 0, lPX * _aspectX, lPY * _aspectY);
		
		// set the l PX
		lPX = lengthdir_x(_distance, _angle) / _aspectX;
		lPY = lengthdir_y(_distance, _angle) / _aspectY;
		// update it
		parent.pointUpdate();
	};
	/// @description
	static setLPosition = function (_newLX, _newLY, _aspectX, _aspectY) {
		
		// set up LX
		lPX = min(0, _newLX - x);
		lPY = _newLY - y;
		
		
		// set up tan
		var _angle = point_direction(0, 0, lPX * _aspectX, lPY * _aspectY) + 180;
		// set up distance
		var _distance = point_distance(0, 0, rPX * _aspectX, rPY * _aspectY);
		
		// set the r PX
		rPX = lengthdir_x(_distance, _angle) / _aspectX;
		rPY = lengthdir_y(_distance, _angle) / _aspectY;
		// update it
		parent.pointUpdate();
	};
	
	static pointUpdate = function (_xMin, _xMax) {
		
		xMin = _xMin;
		xMax = _xMax;
		
		// get the new length
		var _newRLength = min(x + rPX, _xMax) - x;
		// has changed?
		if (_newRLength != rPX) {
			// is 0
			if (_newRLength == 0) {
				rPY = 0; rPX = 0;
				
			} else {
				var _m = rPY / rPX;
				// set this up
				rPX = _newRLength;
				rPY = rPX * _m;
			};
		};
		
		// get the new length
		var _newLLength = max(x + lPX, _xMin) - x;
		// has changed?
		if (_newLLength != lPX) {
			// is 0
			if (_newLLength == 0) {
				lPY = 0; lPX = 0;
				
			} else {
				var _m = lPY / lPX;
				// set this up
				lPX = _newLLength;
				lPY = lPX * _m;
			};
		};
	};
};