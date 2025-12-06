/// @description update points

// get this
//readPoint = (currentFrame() / 60) mod 1;
// has selected point?
if (ob_animation_editor.animationSelectedExists()) {
	// get it
	aeEditorAnimationObject = ob_animation_editor.animationSelectedGetId();
	// workding curve
	kAnimCurveWorking = aeEditorAnimationObject.mainCurve;
	// sert read point
	readPoint = aeEditorAnimationObject.animValue;
} else { aeEditorAnimationObject = noone; };

// update this
image_xscale = windowIns.width;
image_yscale = windowIns.height;
x = windowIns.x;
y = windowIns.y;

var _points;

// has point
if (kAnimCurveChannel != -1) {
	// update points
	kAnimCurveChannel.pointUpdate();
	
	_points = kAnimCurveChannel.points;
};

mouseOnPoint = -1;
// reset on too
selectedPointROn = false;
selectedPointLOn = false;
// is on the curve?
onTheCurve = -1;
testPointOnCurve = false;
// update for it
mouseInside = mouseInGUI(x, y, x + image_xscale, y + image_yscale) && windowIns.mouseInside;

//
switch (phase) {
	
	case "noSelection":
		
		 // has no point
		 if (kAnimCurveChannel == -1) {
			 // for this too
			 selectedPoint = -1;
			 break;
		 };
		
		// loop for each set of points
		for (var i = 0; i < array_length(_points); i++) {
			// set up this
			var _convertedPoint = drawConvertPoint(_points[i].x, _points[i].y);
			// and get there the mouse
			var _mouseIn =
				mouseInGUI(	_convertedPoint[0] - 4, _convertedPoint[1] - 4,
							_convertedPoint[0] + 4, _convertedPoint[1] + 4);
			
			// get it?
			if (_mouseIn && mouseInside && windowIns.wasUseable && windowIns.wasInZone) {
				mouseOnPoint = i;
				mouseXOff = _convertedPoint[0] - windowGetMouseX();
				mouseYOff = _convertedPoint[1] - windowGetMouseY();
				// does click?
				if (mouse_check_button_pressed(mb_left)) {
					// here set up
					selectedPoint = i;
					break;
				};
			};
		};
		// has mouse on point?
		if (selectedPoint != -1) {
			// on the curve
			onTheCurve = selectedPoint;
			// get the other points
			var _tLPoint = drawConvertPoint(
				_points[selectedPoint].x + _points[selectedPoint].lPX,
				_points[selectedPoint].y + _points[selectedPoint].lPY);
			// get the T points
			var _tRPoint = drawConvertPoint(
				_points[selectedPoint].x + _points[selectedPoint].rPX,
				_points[selectedPoint].y + _points[selectedPoint].rPY);
			
			// is on legt side
			if (_points[selectedPoint].x > 0) {
				// does click
				if (mouseInGUI(	_tLPoint[0] - 2, _tLPoint[1] - 2,
								_tLPoint[0] + 2, _tLPoint[1] + 2)) {
					// on left point
					selectedPointLOn = true;
					// does click?
					if (mouse_check_button_pressed(mb_left)) {
						// set this up
						selectedPointL = true;
						mouseXOff = _tLPoint[0] - windowGetMouseX();
						mouseYOff = _tLPoint[1] - windowGetMouseY();
						phase = "movingL";
						break;
					};
				};
			};
			
			// is on right side
			if (_points[selectedPoint].x < 1) {
				// does click on right side
				if (mouseInGUI(	_tRPoint[0] - 2, _tRPoint[1] - 2,
								_tRPoint[0] + 2, _tRPoint[1] + 2)) {
					// on right point
					selectedPointROn = true;
					// does click?
					if (mouse_check_button_pressed(mb_left)) {
						// set this up
						selectedPointR = true;
						mouseXOff = _tRPoint[0] - windowGetMouseX();
						mouseYOff = _tRPoint[1] - windowGetMouseY();
						phase = "movingR";
						break;
					};
				};
			};
			
			
			
			// is clicking?
			if (mouse_check_button(mb_left) && (mouseOnPoint == selectedPoint)) {
				phase = "movingPoint";
				selectedPointCanMove = false;
				// get the positions for this shit
				selectedPointMoveMouseXOc = windowGetMouseX();
				selectedPointMoveMouseYOc = windowGetMouseY();
				// get the other points
				var _pointPosition = drawConvertPoint(_points[selectedPoint].x, _points[selectedPoint].y);
				// save the offset
				selectedPointMoveMouseXOffset = _pointPosition[0] - selectedPointMoveMouseXOc;
				selectedPointMoveMouseYOffset = _pointPosition[1] - selectedPointMoveMouseYOc;
				break;
			};
			
		};
		
		if ((mouseOnPoint == -1) && (!selectedPointROn) && (!selectedPointLOn) && mouseInside) {
			// levae out
			var _restoredPoint = drawDeconvertPoint(windowGetMouseX(), clamp(windowGetMouseY(), y, y + image_yscale));
			// is not any point
			if (kAnimCurveChannel.searchForX(_restoredPoint[0]) == -1) {
				// is on the curve
				var _yCurve = kAnimCurveChannel.checkOnX(_restoredPoint[0]);
				// is near?
				var _convertedY = drawConvertPoint(_restoredPoint[0], _yCurve);
				
				// is near?
				if (abs(windowGetMouseY() - _convertedY[1]) <= 4) {
					// yup
					testPointOnCurve = true;
					// search for lower X
					var _lowerXSearchUpI = kAnimCurveChannel.searchForLowerX(_restoredPoint[0]);
					onTheCurve = _lowerXSearchUpI;
					
					// and click
					if (mouse_check_button_pressed(mb_left)) {
						// reset this up
						selectedPoint = -1;
						// create a point here
						kAnimCurveChannel.pointAdd(
							new kesoAnimCurvePoint(	"newP" + string(current_time),
													_restoredPoint[0], _yCurve,
													kAnimCurveChannel.pointType)
						);
						
						break;
					};
				};
			};
		};
		
		// has mouse on point?
		if (selectedPoint != -1) {
			// want to delete it?
			if (keyboard_check_pressed(vk_delete)) {
				// is neither the last or first point
				if ((selectedPoint > 0) && (selectedPoint < (array_length(kAnimCurveChannel.points) - 1))) {
					// delete this point
					kAnimCurveChannel.pointDelete(selectedPoint);
					selectedPoint = -1; break;
				};
			};
			// to deselect the point
			if (mouse_check_button_pressed(mb_left) && mouseInside) { selectedPoint = -1; break; };
		};
	break;
	
	case "movingPoint":
		
		// no channel
		if (kAnimCurveChannel == -1) {
			phase = "noSelection";
			break;
		};
		
		// on the curve
		onTheCurve = selectedPoint;
		// ensure it moved a little alleast
		if (!mouseInGUI(selectedPointMoveMouseXOc - 2, selectedPointMoveMouseYOc - 2, 
						selectedPointMoveMouseXOc + 2, selectedPointMoveMouseYOc + 2)) {
			// now you can
			selectedPointCanMove = true;
		};
		
		
		// wait to start reconverting
		if (modifyPointTimer > 0) {
			
		};
		
		// if you can move it
		if (selectedPointCanMove) {
			// levae out
			var _restoredPoint = drawDeconvertPoint(windowGetMouseX() + selectedPointMoveMouseXOffset, clamp(windowGetMouseY() + selectedPointMoveMouseYOffset, y, y + image_yscale));
			// set up the point position
			_points[selectedPoint].setPosition(_restoredPoint[0], _restoredPoint[1]);
		};
		
		// levae out
		if (!mouse_check_button(mb_left)) {
			// not now
			phase = "noSelection";
			break;
		};
	break;
	
	case "movingR":
		
		// no channel
		if (kAnimCurveChannel == -1) {
			phase = "noSelection";
			selectedPointR = false;
			break;
		};
		
		// on the curve
		onTheCurve = selectedPoint;
		
		// levae out
		var _restoredPoint = drawDeconvertPoint(windowGetMouseX(), clamp(windowGetMouseY(), y, y + image_yscale));
		// set up the point position
		_points[selectedPoint].setRPosition(_restoredPoint[0], _restoredPoint[1], image_xscale, image_yscale / abs(drawLimitTop - drawLimitBottom));
		
		// levae out
		if (!mouse_check_button(mb_left)) {
			// not now
			phase = "noSelection";
			selectedPointR = false;
			break;
		};
	break;
	
	case "movingL":
		
		// no channel
		if (kAnimCurveChannel == -1) {
			phase = "noSelection";
			selectedPointL = false;
			break;
		};
		
		// on the curve
		onTheCurve = selectedPoint;
		
		// levae out
		var _restoredPoint = drawDeconvertPoint(windowGetMouseX(), clamp(windowGetMouseY(), y, y + image_yscale));
		// set up the point position
		_points[selectedPoint].setLPosition(_restoredPoint[0], _restoredPoint[1], image_xscale, image_yscale / abs(drawLimitTop - drawLimitBottom));
		
		// levae out
		if (!mouse_check_button(mb_left)) {
			// not now
			phase = "noSelection";
			selectedPointL = false;
			break;
		};
	break;
};

// has channek
if (kAnimCurveChannel != -1) {
	
	// on the last?
	if ((onTheCurve > 0) && (onTheCurve == (array_length(kAnimCurveChannel.points) - 1))) { onTheCurve = onTheCurve - 1; };
	
	// change draw limit
	var _heightType = abs(drawLimitTop - drawLimitBottom);
	// goes up
	var _movingScroll = _heightType / 20;
	// get thtat
	var _movingShift = mouse_wheel_up() - mouse_wheel_down();
	
	// doing it
	if (mouseInside) {
		// has control
		if (keyboard_check_direct(vk_lcontrol)) {
			
			// get middle points
			var _middleLimit = (drawLimitBottom + drawLimitTop) / 2;
			// set middle height
			var _newHeight = _heightType / 2;
			var _scrollSize = 1.2;
			// get mouse
			if (mouse_wheel_up())	 { _newHeight /= _scrollSize; };
			if (mouse_wheel_down())	 { _newHeight *= _scrollSize; };
			// set middle limit
			drawLimitTop	 = _middleLimit + _newHeight;
			drawLimitBottom	 = _middleLimit - _newHeight;
			
		} else {
			
			// increase both
			drawLimitBottom	 += _movingShift * _movingScroll;
			drawLimitTop	 += _movingShift * _movingScroll;
		};
	};
};

// is no selection
if (phase == "noSelection") {
	// no point
	if (selectedPoint == -1) {
		// click here
		if (mouse_check_button(mb_left) && mouseInside) {
			// set new value
			var _newValue = remapClamp(windowGetMouseX(), x, x + image_xscale, 0, 1);
			// now update it
			if (eAnimExists(aeEditorAnimationObject)) {
				
				//show_debug_message("Playing Animation.");
				// play and pause
				//aeEditorAnimationObject.animPlay();
				
				show_debug_message("Pausing Animation.");
				// pause it
				aeEditorAnimationObject.animPause();
				
				show_debug_message("Setting Animation.");
				// srt it
				aeEditorAnimationObject.animSetValue(_newValue);
			};
		};
	};
};
















