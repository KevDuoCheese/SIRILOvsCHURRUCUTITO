/// @description update here
depth = -35;

// so how much?
iterations = 100;
tShift = 1 / iterations;

// and my position is x and y as expected
// this are the points of this
image_xscale = windowIns.width - 2;
image_yscale = windowIns.height - 2;
x = windowIns.x + 1;
y = windowIns.y + 1;
// mention myself
windowIns.animcurveHandler = id;

// get the top and bottom
drawLimitBottom		 = -50;
drawLimitTop		 = 50;

// set this up
aeEditorAnimationObject = noone;

// here goes a curve
kAnimCurveWorking = new kesoAnimCurve("main");
// add it a channek
kAnimCurveWorking.channelAdd(new kesoAnimCurveChannel("x", 0, 0, kesoAnimCurveCurveType.beizer));

// save here the curve
kAnimCurveChannel = -1;//kAnimCurveWorking.channelGet("x");

drawConvertPoint = function (_pointX, _pointY) {
	return [
		x + (_pointX * image_xscale),
		y + (image_yscale - remap(_pointY, drawLimitBottom, drawLimitTop, 0, image_yscale))
	];
};

drawDeconvertPoint = function (_pointX, _pointY) {
	return [
		(_pointX - x) / image_xscale,
		remap((image_yscale - (_pointY - y)), 0, image_yscale, drawLimitBottom, drawLimitTop)
	];
};

selectedPoint = -1;

selectedPointR = false;
selectedPointL = false;

selectedPointROn = false;
selectedPointLOn = false;

onTheCurve = -1;
testPointOnCurve = false;

curveColor = c_fuchsia;

mouseInside = false;

mouseOnPoint = -1;
mouseXOff = 0;
mouseYOff = 0;

readPoint = 0;

// to boot up all values from here
restoreValues = function () {
	
	selectedPoint = -1;

	selectedPointR = false;
	selectedPointL = false;
	
	selectedPointROn = false;
	selectedPointLOn = false;
	
	onTheCurve = -1;
	testPointOnCurve = false;
	
	curveColor = c_fuchsia;
	
	mouseInside = false;
	
	mouseOnPoint = -1;
	mouseXOff = 0;
	mouseYOff = 0;
	
	readPoint = 0;
};

phase = "noSelection";

#region Draw event

// set it up
windowIns.userSetDrawEvent(function () {
	
	// draw the background
	//draw_sprite_stretched(sp_kui_slider_bg, 0, x - 1, y - 1, image_xscale + 2, image_yscale + 2);
	var _oId = animcurveHandler;
	var _w = _oId.image_xscale / 10;
	var _h = _oId.image_yscale / 14;
	
	// loop it in here
	for (var i = 0; i < 10; i++) {
		
		// draw it here
		draw_sprite_stretched_ext(sp_11box, 0, _oId.x + (_w * i), _oId.y, 1, _oId.image_yscale, #1B1B1B, 0.75);
	};
	// and for height
	for (var i = 0; i < 14; i++) {
		
		// draw it here
		draw_sprite_stretched_ext(sp_11box, 0, _oId.x, _oId.y + (_h * i), _oId.image_xscale, 1, #1B1B1B, 0.75);
	};
	
	// has a channel
	if (_oId.kAnimCurveChannel != -1) {
	
	var _points = _oId.kAnimCurveChannel.points;
	
	// set it up
	draw_set_color(_oId.curveColor);
	
	var _cPointA, _cPointB, _cPointC, _cPointD;
	// loop for each set of points
	for (var i = 0; i < (array_length(_points) - 1); i++) {
		// set up this
		_cPointA = _oId.drawConvertPoint(_points[i].x, _points[i].y);
		_cPointB = _oId.drawConvertPoint(_points[i].x + _points[i].rPX, _points[i].y + _points[i].rPY);
		_cPointC = _oId.drawConvertPoint(_points[i + 1].x + _points[i + 1].lPX, _points[i + 1].y + _points[i + 1].lPY);
		_cPointD = _oId.drawConvertPoint(_points[i + 1].x, _points[i + 1].y);
		
		// set it up
		draw_primitive_begin(pr_linestrip);
		draw_set_color((_oId.onTheCurve == i) ? c_aqua : _oId.curveColor);
		
		var _distX = _oId.tShift;
		// get the distance
		if (_cPointA[0] != _cPointD[0]) { _distX = 1 / abs(_cPointD[0] - _cPointA[0]); };
		
		// and loop
		for (var n = 0; n <= 1; n += _distX) {
			
			var _finalPoint = beizerPointsGet(n,
							new beizerVec2(_cPointA[0], _cPointA[1]),
							new beizerVec2(_cPointB[0], _cPointB[1]),
							new beizerVec2(_cPointC[0], _cPointC[1]),
							new beizerVec2(_cPointD[0], _cPointD[1]));
			
			// and add vertex
			draw_vertex(_finalPoint.x, _finalPoint.y);
		};
		
		// and end it
		draw_primitive_end();
	};
	
	
	
	// has selected point?
	if (_oId.selectedPoint != -1) {
		// get the converted point here
		var _convertedPoint = _oId.drawConvertPoint(_points[_oId.selectedPoint].x, _points[_oId.selectedPoint].y);
		// get the T points
		var _tLPoint = _oId.drawConvertPoint(
			_points[_oId.selectedPoint].x + _points[_oId.selectedPoint].lPX,
			_points[_oId.selectedPoint].y + _points[_oId.selectedPoint].lPY);
		// get the T points
		var _tRPoint = _oId.drawConvertPoint(
			_points[_oId.selectedPoint].x + _points[_oId.selectedPoint].rPX,
			_points[_oId.selectedPoint].y + _points[_oId.selectedPoint].rPY);
		
		// yup
		draw_set_color(c_gray);
		// draw in position
		draw_primitive_begin(pr_linestrip);
		draw_vertex(_tLPoint[0], _tLPoint[1]);
		draw_vertex(_tRPoint[0], _tRPoint[1]);
		draw_primitive_end();
		//draw_line(_tLPoint[0] - 1, _tLPoint[1] - 1, _tRPoint[0] - 1, _tRPoint[1] - 1);
		
		// is on right side
		if (_points[_oId.selectedPoint].x < 1) {
		// and draw here
		draw_sprite_ext(sp_animed_curve_point, _oId.selectedPointR,
						_tRPoint[0], _tRPoint[1],
						1, 1,
						0, _oId.selectedPointR ? c_aqua : (_oId.selectedPointROn ? c_white : c_gray), 1);
		};
		
		// is on left side
		if (_points[_oId.selectedPoint].x > 0) {
			// and draw here the left one
			draw_sprite_ext(sp_animed_curve_point, _oId.selectedPointL,
							_tLPoint[0], _tLPoint[1],
							1, 1,
							0, _oId.selectedPointL ? c_aqua : (_oId.selectedPointLOn ? c_white : c_gray), 1);
		};
	};
	// not selecting anything
	if ((_oId.mouseOnPoint == -1) && (!_oId.selectedPointLOn) && (!_oId.selectedPointROn)) {
		
		// has on curve?
		if ((_oId.onTheCurve != -1) && _oId.testPointOnCurve) {
			
			// levae out
			var _restoredPoint = _oId.drawDeconvertPoint(windowGetMouseX(), clamp(windowGetMouseY(), _oId.y, _oId.y + _oId.image_yscale));
			
			// is on the curve
			var _yCurve = _oId.kAnimCurveChannel.checkOnX(_restoredPoint[0]);
			// is near?
			var _convertedY = _oId.drawConvertPoint(_restoredPoint[0], _yCurve);
			
			// and draw here the left one
			draw_sprite_ext(sp_animed_curve_point, 0,
							_convertedY[0], _convertedY[1],
							1, 1,
							0, _oId.curveColor, 1);
		};
	};
	
	// set up agan
	draw_set_color(_oId.curveColor);
	// loop for each set of points
	for (var i = 0; i < array_length(_points); i++) {
		// set up this
		var _convertedPoint = _oId.drawConvertPoint(_points[i].x, _points[i].y);
		
		var _pIndex = 0;
		var _pColor = draw_get_color();
		
		// is do
		if (_oId.selectedPoint == i) { _pColor = c_white; };
		
		// is myself and selected
		if (_oId.phase == "movingPoint" && _oId.selectedPoint == i) { _pIndex = 1; }
		// is mouse on point
		else if (_oId.mouseOnPoint == i) { _pColor = c_white; };
		
		// and draw here
		draw_sprite_ext(sp_animed_curve_point, _pIndex,
						_convertedPoint[0], _convertedPoint[1],
						1, 1,
						0, _pColor, 1);
	};
	
	};
	
	// andr draw the line
	draw_sprite_stretched(sp_11box, 0, x + (_oId.readPoint * _oId.image_xscale) - 0.5, y, 1, _oId.image_yscale);
});

#endregion
