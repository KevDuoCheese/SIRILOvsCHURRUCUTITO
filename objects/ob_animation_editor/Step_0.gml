/// @description step call
mainCore.stepCall();



// there is a selecred animatioon
if (animationSelectedExists()) {
	// get the global id
	var _animationId = animationSelectedGetId();
	// set the animation id
	_animationId.animLoopType = animationGlobalLoopType;
	
	// channel is selected
	if (animationChannelSelectedExists()) {
		
		// set the reading point on animation point
		animcurveHandler.readPoint = _animationId.animValue;
	};
	
	// press play
	if (keyboard_check_pressed(vk_space)) {
		// si playing?>
		if (!_animationId.isPlaying) {
			// play that shit
			_animationId.animPlay();
		} else {
			// is paused?
			if (_animationId.isPaused) {
				
				// resume
				_animationId.animResume();
			} else {
				
				// stop that shit
				_animationId.animPause();
			};
		};
	};
};

// get all the data
var _objectNames = struct_get_names(objectData);
// one by one
for (var i = 0; i < array_length(_objectNames); i++) {
	// get it
	var _objectId = objectData[$ _objectNames[i]];
	// yup? make it move
	_objectId.stepEvent();
};

// if pressed control A
if ((global._kuiDepth == 0) && (!mainCore.childrenCursorInside)) {
	// wants to delete
	if (keyboard_check_pressed(vk_delete)) {
		// has selected anything?
		if (objectSelectedExists()) {
			// get the id
			var _selectedId = objectSelectedGetId();
			
			// delete the object
			objectDelete(_selectedId);
			// update it
			ob_animation_editor.objectUpdateList();
			exit;
		};
	};
	
	// pressed control A
	if (keyboard_check_direct(vk_lcontrol) && keyboard_check_pressed(ord("A"))) {
		
		// create the window
		var _windowIns = new kuiMoveWindow("createObjectList", new kuiUIVec2(windowGetMouseX(), 0, windowGetMouseY(), 0), new kuiUIVec2(100, 0, 50, 0), "Create Anim", true);
		
		// create it
		var _butName = new kuiInput("oName", new kuiUIVec2(4, 0, 17, 0), new kuiUIVec2(-8, 1, 14, 0), "Enter Name", "", 500, false, KUI_INPUT_TYPE.stringType);
		
		#region Button for create object
		// add to it
		var _butObject = new kuiButtonImage("object", new kuiUIVec2(4, 0, 33, 0), new kuiUIVec2(14, 0, 14, 0), sp_ae_type, 0, function () {
			
			// get the name
			var _nameSet = parent.elements.oName.getText();
			// valid?
			if (_nameSet == "") { show_message("/!\\ Put a name first.") exit; };
			
			// exists
			if (ob_animation_editor.objectSelectedExists()) {
				
				// create a new object
				var _selectedOb = ob_animation_editor.objectSelectedGetId();
				// it should be an object
				if (_selectedOb.type == eAnimType.object) {
					
					// exists?
					if (struct_exists(_selectedOb.elements, _nameSet)) { show_message("/!\\ Already exists \"" + _nameSet + "\""); exit; };
					// create there the object
					var _newEOb = new eAnimObjectCreate(_nameSet, 0, 0);
					// add to it
					_selectedOb.elementAdd(_newEOb);
					
					// update it
					ob_animation_editor.objectUpdateList();
					
				} else {
					// show error
					show_message("/!\\ Select an object or empty space.");
					exit;
				};
			} else {
				
				// exists?
				if (struct_exists(ob_animation_editor.objectData, _nameSet)) { show_message("/!\\ Already exists \"" + _nameSet + "\""); exit; } else {
					
					// create there the object
					var _newEOb = new eAnimObjectCreate(_nameSet, mouseGetX(), mouseGetY());
					// add to it
					struct_set(ob_animation_editor.objectData, _newEOb.id, _newEOb);
					
					// update it
					ob_animation_editor.objectUpdateList();
				};
			};
			
			
			// destroy window
			parent.selfDestroy();
		});
		
		#endregion
		/* */
		#region Button for create sprite
		
		// add to it
		var _butSprite = new kuiButtonImage("sprite", new kuiUIVec2(20, 0, 33, 0), new kuiUIVec2(14, 0, 14, 0), sp_ae_type, 1, function () {
			
			// get the name
			var _nameSet = parent.elements.oName.getText();
			// valid?
			if (_nameSet == "") { show_message("/!\\ Put a name first.") exit; };
			
			// exists
			if (ob_animation_editor.objectSelectedExists()) {
				
				// create a new object
				var _selectedOb = ob_animation_editor.objectSelectedGetId();
				// it should be an object
				if (_selectedOb.type == eAnimType.object) {
					
					// exists?
					if (struct_exists(_selectedOb.elements, _nameSet)) { show_message("/!\\ Already exists \"" + _nameSet + "\""); exit; };
					// increase depth
					depthIncrease();
					// create the list
					var _selectedList = new kuiList("spriteList", new kuiUIVec2(10, 0, 10, 0), new kuiUIVec2(120, 0, 200, 0),
						function (_oId, _listParent, _infoStruct, _oX, _oY, _oW, _oH) {
							
							var _spriteName						 = structRead(_infoStruct, "spriteName", "");
							var _spriteId						 = structRead(_infoStruct, "spriteId", 0);
							var _animationOriginalObject		 = structRead(_infoStruct, "originalObject", -1);
							var _animationSpriteName			 = structRead(_infoStruct, "newSpriteName", "");
							// get that object name
							
							var _internalWindow = new kuiWindowInternal(string(_oId) + "_" + string(current_time) + "window",
										new kuiUIVec2(0, 0, 0, 0),
										new kuiUIVec2(0, 1, 0, 1));
							
							// get the button ins name
							var _objectName = _animationOriginalObject.id;
							
							// Add text inside
							var _textUI = new kuiText("textUI", new kuiUIVec2(16, 0, 0, 0), new kuiUIVec2(-16, 1, 0, 1), _spriteName, c_black, fa_left, fa_middle);
							// Add image too
							var _imageUI = new kuiImage("imageUI", _spriteId, 0, new kuiUIVec2(2, 0, 1, 0), new kuiUIVec2(12, 0, -2, 1));
							
							// set it up
							var _buttonListIns = new kuiButton(string(_oId) + "button",
																	new kuiUIVec2(0, 0, 0, 0), new kuiUIVec2(0, 1, 0, 1), 
																	function () {
																		
																		// create there the object
																		var _newEOb = eAnimSpriteCreateDefault(dataSNewName, 0, 0, dataSSpriteId, 0);
																		// add to it
																		dataSObject.elementAdd(_newEOb);
																		// yup
																		depthDecrease();
																		
																		// quti otu it
																		dataSListParent.parent.selfDestroy();
																	});
							// adjust this
							_buttonListIns.dataSSpriteName	 = _spriteName;
							_buttonListIns.dataSSpriteId	 = _spriteId;
							_buttonListIns.dataSObject		 = _animationOriginalObject;
							_buttonListIns.dataSListParent	 = _listParent;
							_buttonListIns.dataSNewName		 = _animationSpriteName;
							// add to button
							_buttonListIns.elementAdd(_textUI, _imageUI);
							
							// Add content to list
							_listParent.optionAddElement(_oId, _buttonListIns);
							// set up
							_listParent.userSetDestroyEvent(function () {
								
								// update it
								//globalParent.updateNextFrame = true;
								globalParent.objectUpdateList();
								exit;
							})
							
					}, function () { });
					_selectedList.drawOutAll = true;
					// loop this all
					for (var i = 0; i < array_length(globalParent.spriteListMain); i++) {
						// add to it
						_selectedList.optionAdd({ 
							spriteName : globalParent.spriteListMain[i][0],
							spriteId : globalParent.spriteListMain[i][1],
							originalObject : _selectedOb,
							newSpriteName : _nameSet
						});
					};
					
					// add to parent list
					parent.elementAdd(_selectedList);
					
				} else {
					// show error
					show_message("/!\\ Select an object or empty space.");
					exit;
				};
			} else {
				// select an object
				show_message("/!\\ Select an object first.");
				exit;
			};
		});
		
		#endregion
		/* */
		#region Button for creating animation
		
		// add to it
		var _butAnim = new kuiButtonImage("animation", new kuiUIVec2(36, 0, 33, 0), new kuiUIVec2(14, 0, 14, 0), sp_ae_type, 2, function () {
			
			// get the name
			var _nameSet = parent.elements.oName.getText();
			// valid?
			if (_nameSet == "") { show_message("/!\\ Put a name first.") exit; };
			
			// exists
			if (ob_animation_editor.objectSelectedExists()) {
				
				// create a new object
				var _selectedOb = ob_animation_editor.objectSelectedGetId();
				// it should be an object
				if (_selectedOb.type == eAnimType.object) {
					
					// exists?
					if (struct_exists(_selectedOb.elements, _nameSet)) { show_message("/!\\ Already exists \"" + _nameSet + "\""); exit; };
					
					// main curve in
					var _mainCurve = new kesoAnimCurve(_nameSet);
					// add channel
					_mainCurve.channelAdd(new kesoAnimCurveChannel("shift", 0.1, 0.1, kesoAnimCurveCurveType.beizer));
					
					// create there the object
					var _newEOb = new eAnimAnimationCreate(_nameSet, eAnimAnimType.groupKCurve, _mainCurve, false, eAnimRepeatType.endloop);
					// add to it
					_selectedOb.elementAdd(_newEOb);
					
					// update it
					ob_animation_editor.objectUpdateList();
					
				} else {
					// show error
					show_message("/!\\ Select an object first.");
					exit;
				};
			} else {
				// select an object
				show_message("/!\\ Select an object first.");
				exit;
			};
			
			
			// destroy window
			parent.selfDestroy();
		});
		
		#endregion
		
		_windowIns.elementAdd(_butName, _butObject, _butSprite, _butAnim);
		//show_debug_message(_windowIns);
		mainCore.elementAdd(_windowIns);
		mainCore.stepCall();
	};
	
	// moving the zoom thing
	if (keyboard_check_direct(vk_lcontrol)) {
		// get the thing here
		var _movingScroll = mouse_wheel_up() - mouse_wheel_down();
		// dd it?
		if (mouse_wheel_up()) { cameraSetZoom(cameraGetZoom() * 1.2); };
		// inverse it
		if (mouse_wheel_down()) { cameraSetZoom(cameraGetZoom() / 1.2); };
		
		// set limits
		cameraSetZoom(clamp(cameraGetZoom(), cameraGetZoom() * power(1 / 1.2, 20), cameraGetZoom() * power(1.2, 5)));
		
		
		// for this
		switch (cameraScrolling) {
			
			case 0:
				// starts to scroll
				if (mouse_check_button(mb_middle)) {
					// save this up
					cameraScrollingMouseX = window_mouse_get_x();
					cameraScrollingMouseY = window_mouse_get_y();
					// change to it
					cameraScrolling = 1;
					break;
				};
			break;
			
			case 1:
				// stop scrolling
				if (!mouse_check_button(mb_middle)) {
					// change to it
					cameraScrolling = 0;
					break;
				};
				
				// get the movement
				var _cameraX = remap(window_mouse_get_x() - cameraScrollingMouseX,
										0, window_get_width(),
										0, cameraGetWidth());
				var _cameraY = remap(window_mouse_get_y() - cameraScrollingMouseY,
										0, window_get_height(),
										0, cameraGetHeight());
				
				// set up
				//window_mouse_set(cameraScrollingMouseX, cameraScrollingMouseY);
				// update mouse
				cameraScrollingMouseX = window_mouse_get_x();
				cameraScrollingMouseY = window_mouse_get_y();
				// and reset this up
				cameraSetPosition(cameraGetX() - _cameraX, cameraGetY() - _cameraY);
				
				
			break;
		};
		
		// wants to cut
		if (keyboard_check_pressed(ord("X"))) {
			// has selected anything?
			if (objectSelectedExists()) {
				// get the id
				var _selectedId = objectSelectedGetId();
				
				// save in clipboard
				clipboardContain = _selectedId;
				// delete the object
				objectDelete(_selectedId, false);
				
				// update it
				ob_animation_editor.objectUpdateList();
			};
		};
		
		// wants to paste
		if (keyboard_check_pressed(ord("V"))) {
			// has selected anything?
			if (clipboardContain != -1) {
				var _couldPaste = false;
				
				// has selected anything?
				if (objectSelectedExists()) {
					// get the id
					var _selectedId = objectSelectedGetId();
					// depends on type
					if (clipboardContain.type == eAnimType.object || clipboardContain.type == eAnimType.sprite) {
						// needs to be object
						if (_selectedId.type == eAnimType.object) {
							// doesn't exists any similar?
							if (!struct_exists(_selectedId.elements, clipboardContain.id)) {
								// paste in
								_selectedId.elementAdd(clipboardContain);
								// yup it could paste
								_couldPaste = true;
								
							} else { show_message("/!\\ Can't paste, same ID in elements"); };
						};
					};
					
				} else {
					// is obejct?
					if (clipboardContain.type == eAnimType.object) {
						// doesn't exists any similar?
						if (!struct_exists(objectData, clipboardContain.id)) {
							// add to object data
							struct_set(objectData, clipboardContain.id, clipboardContain);
							_couldPaste = true;
							
						} else { show_message("/!\\ Can't paste, same ID in elements"); };
					};
				};
				
				// update it
				if (_couldPaste) {
					show_debug_message("ANIM EDITOR: Could paste successfully.");
					ob_animation_editor.objectUpdateList();
					// quit out
					clipboardContain = -1;
				};
			};
		};
	} else { cameraScrolling = 0; };
	
	// updaet this
	objectPositionDataUpdate();
	// there is a selected obejct?
	if (objectPositionDataSelectedExists()) {
		
		// get data
		var _selectedId = objectSelectedGetId();
		var _dataOfSelected = objectPositionDataGetSelected();
		// adjust here
		var _camUISize = cameraGetWidth() / surfaceGUIGetWidth();
		
		// object or sprite
		if (_dataOfSelected.type == eAnimType.object || _dataOfSelected.type = eAnimType.sprite) {
			
			// get the position
			var _angledPositionX, _angledPositionY;
			_angledPositionX = _dataOfSelected.mainX - vector2XAngled(16, 16, _dataOfSelected.mainAngle) * _camUISize;
			_angledPositionY = _dataOfSelected.mainY - vector2YAngled(16, 16, _dataOfSelected.mainAngle) * _camUISize;
			var _angledOn;
			_angledOn = mouseInRotatedRectangle(_angledPositionX, _angledPositionY,
											8 * _camUISize, 8 * _camUISize,
											16 * _camUISize, 16 * _camUISize,
											_dataOfSelected.mainAngle);
			// get the right arrow
			var _xArrowX, _xArrowY, _xArrowOn;
			_xArrowX = _dataOfSelected.mainX + lengthdir_x(_camUISize * 16, _dataOfSelected.angleOff);
			_xArrowY = _dataOfSelected.mainY + lengthdir_y(_camUISize * 16, _dataOfSelected.angleOff);
			_xArrowOn = mouseInRotatedRectangle(_xArrowX, _xArrowY,
												0, 4 * _camUISize,
												_camUISize * 32, 8 * _camUISize, _dataOfSelected.angleOff);
			// get the down arrow
			var _yArrowX, _yArrowY, _yArrowOn;
			_yArrowX = _dataOfSelected.mainX + lengthdir_x(_camUISize * 16, _dataOfSelected.angleOff - 90);
			_yArrowY = _dataOfSelected.mainY + lengthdir_y(_camUISize * 16, _dataOfSelected.angleOff - 90);
			_yArrowOn = mouseInRotatedRectangle(_yArrowX, _yArrowY,
												4 * _camUISize, 0,
												8 * _camUISize, _camUISize * 32, _dataOfSelected.angleOff);
			
			// here and on
			switch (objectTransformPhase) {
				
				case "wait":
					
					// rotate transform
					if (_angledOn) {
						// activated
						if (mouse_check_button(mb_left)) {
							
							// set it up off
							objectTransformAngleOff = angle_difference(_dataOfSelected.mainAngle, 
													point_direction(_dataOfSelected.mainX, _dataOfSelected.mainY,
																	mouseGetX(), mouseGetY()));
							// swithc on it
							objectTransformPhase = "angle";
							break;
						};
					};
					
					// moving transform
					if (_xArrowOn) {
						// activated
						if (mouse_check_button(mb_left)) {
							
							// get the difference
							var _mainPosition = lines_intersect_pos(mouseGetX(), mouseGetY(), 
												mouseGetX() + lengthdir_x(80, _dataOfSelected.angleOff + 90),
												mouseGetY() + lengthdir_y(80, _dataOfSelected.angleOff + 90),
												
												_dataOfSelected.mainX, _dataOfSelected.mainY,
												_dataOfSelected.mainX + lengthdir_x(80, _dataOfSelected.angleOff),
												_dataOfSelected.mainY + lengthdir_y(80, _dataOfSelected.angleOff), false);
							
							// mod this
							objectTransformXMainOff = _dataOfSelected.mainX;
							objectTransformYMainOff = _dataOfSelected.mainY;
							// set it up
							objectTransformXOCOff = _selectedId.x;
							// set it up off
							objectTransformXOff = point_distance(_dataOfSelected.mainX, _dataOfSelected.mainY,
														_mainPosition.x, _mainPosition.y);
							// swithc on it
							objectTransformPhase = "x";
							break;
						};
					};
					
					// moving transform
					if (_yArrowOn) {
						// activated
						if (mouse_check_button(mb_left)) {
							
							// get the difference
							var _mainPosition = lines_intersect_pos(mouseGetX(), mouseGetY(), 
												mouseGetX() + lengthdir_x(80, _dataOfSelected.angleOff),
												mouseGetY() + lengthdir_y(80, _dataOfSelected.angleOff),
												
												_dataOfSelected.mainX, _dataOfSelected.mainY,
												_dataOfSelected.mainX + lengthdir_x(80, _dataOfSelected.angleOff + 90),
												_dataOfSelected.mainY + lengthdir_y(80, _dataOfSelected.angleOff + 90), false);
							
							// mod this
							objectTransformXMainOff = _dataOfSelected.mainX;
							objectTransformYMainOff = _dataOfSelected.mainY;
							// set it up
							objectTransformYOCOff = _selectedId.y;
							// set it up off
							objectTransformYOff = point_distance(_dataOfSelected.mainX, _dataOfSelected.mainY,
														_mainPosition.x, _mainPosition.y);
							// swithc on it
							objectTransformPhase = "y";
							break;
						};
					};
					
				break;
				
				case "x":
					
					// get the difference
					var _newPosition = lines_intersect_pos(mouseGetX(), mouseGetY(), 
										mouseGetX() + lengthdir_x(80, _dataOfSelected.angleOff + 90),
										mouseGetY() + lengthdir_y(80, _dataOfSelected.angleOff + 90),
										
										objectTransformXMainOff, objectTransformYMainOff,
										objectTransformXMainOff + lengthdir_x(80, _dataOfSelected.angleOff),
										objectTransformYMainOff + lengthdir_y(80, _dataOfSelected.angleOff), false);
					// get the change
					var _distanceX = point_distance(objectTransformXMainOff, objectTransformYMainOff,
													_newPosition.x, _newPosition.y);
					
					
					// is less
					var _activeAngle = angle_difference(_dataOfSelected.angleOff + 90, 0);
					if (_activeAngle == 90 || _activeAngle == -90) {
						
						// is just less (positive)
						if (mouseGetX() < objectTransformXMainOff) {
							// invert it
							_distanceX *= -1;
						};
						// is fucking neg
						if (_activeAngle < 0) { _distanceX *= -1; };//show_debug_message("doubleinv") };
					} else if (_activeAngle == 0 || _activeAngle == -180 || _activeAngle == 180) {
						
						// is just less )positive)
						if (mouseGetY() < objectTransformYMainOff) {
							// invert it
							_distanceX *= -1;
						};
						// is fucking neg
						if (_activeAngle < 0) { _distanceX *= -1; };//show_debug_message("doubleinv") };
					} else {
						// inver
						var _trueX = objectTransformXMainOff - (objectTransformYMainOff * (1 / -tan(degtorad(_activeAngle))));
						// is more?
						if (_newPosition.y > ((_newPosition.x - _trueX) * -tan(degtorad(_activeAngle)))) {
							//show_debug_message("on invert side")
							// invert it
							_distanceX *= -1;
						};// else { show_debug_message("not on invert side") };
						// is fucking neg
						if (angle_difference(_dataOfSelected.angleOff, 0) < 0) { _distanceX *= -1; };//show_debug_message("doubleinv") };
					};
					
					//show_debug_message("distanceX: " + string(_distanceX) +  ", acAngle: " + string(_activeAngle))
					
					// adjsut the change X
					var _changeX = _distanceX - objectTransformXOff;
					// modify X
					var _xModifier = _changeX / _dataOfSelected.mainXScale;
					// add to X
					_selectedId.x = objectTransformXOCOff + _xModifier;
					
					// deactivated
					if (!mouse_check_button(mb_left)) {
						// return to it
						objectTransformPhase = "wait";
					};
				break;
				
				case "y":
					
					// get the difference
					var _newPosition = lines_intersect_pos(mouseGetX(), mouseGetY(), 
										mouseGetX() + lengthdir_x(80, _dataOfSelected.angleOff),
										mouseGetY() + lengthdir_y(80, _dataOfSelected.angleOff),
										
										objectTransformXMainOff, objectTransformYMainOff,
										objectTransformXMainOff + lengthdir_x(80, _dataOfSelected.angleOff + 90),
										objectTransformYMainOff + lengthdir_y(80, _dataOfSelected.angleOff + 90), false);
					// get the change
					var _distanceY = point_distance(objectTransformXMainOff, objectTransformYMainOff,
													_newPosition.x, _newPosition.y);
					
					
					// is less
					var _activeAngle = angle_difference(_dataOfSelected.angleOff, 0);
					if (_activeAngle == 90 || _activeAngle == -90) {
						
						// is just less (positive)
						if (mouseGetX() < objectTransformXMainOff) {
							// invert it
							_distanceY *= -1;
						};
						// is fucking neg
						if (_activeAngle < 0) { _distanceY *= -1; };
					} else if (_activeAngle == 0 || _activeAngle == -180 || _activeAngle == 180) {
						
						// is just less )positive)
						if (mouseGetY() < objectTransformYMainOff) {
							// invert it
							_distanceY *= -1;
						};
						// is fucking neg
						if (_activeAngle < 0) { _distanceY *= -1; };
					} else {
						// inver
						var _trueX = objectTransformXMainOff - (objectTransformYMainOff * (1 / -tan(degtorad(_activeAngle))));
						// is more?
						if (_newPosition.y > ((_newPosition.x - _trueX) * -tan(degtorad(_activeAngle)))) {
							
							// invert it
							_distanceY *= -1;
						};
						// is fucking neg
						if (angle_difference(_dataOfSelected.angleOff - 90, 0) < 0) { _distanceY *= -1; };
					};
					
					//show_debug_message("distanceY: " + string(_distanceY) +  ", acAngle: " + string(_activeAngle))
					
					// adjsut the change Y
					var _changeY = _distanceY - objectTransformYOff;
					// modify Y
					var _yModifier = _changeY / _dataOfSelected.mainYScale;
					// add to Y
					_selectedId.y = objectTransformYOCOff + _yModifier;
					
					// deactivated
					if (!mouse_check_button(mb_left)) {
						// return to it
						objectTransformPhase = "wait";
					};
				break;
				
				case "angle":
					
					// set the new angle
					var _newAngle = point_direction(_dataOfSelected.mainX, _dataOfSelected.mainY,
																	mouseGetX(), mouseGetY()) + objectTransformAngleOff;
					// adjust for it, return orignal angle
					_newAngle -= _dataOfSelected.angleOff + _dataOfSelected.angleShift;
					// set the new angle
					_selectedId.angle = angle_difference(_newAngle, 0);
					
					// deactivated
					if (!mouse_check_button(mb_left)) {
						// return to it
						objectTransformPhase = "wait";
					};
				break;
			};
		};
	};
} else { cameraScrolling = 0; objectTransformPhase = "wait"; };











