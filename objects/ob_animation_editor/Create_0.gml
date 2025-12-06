/// @description set up everything
depth = -30;

musicDeleteAll();

//display_set_gui_size(round(window_get_width() / 2), round(window_get_height() / 2));
display_set_gui_size(screen.width * 2, screen.height * 2);
// set camera position
cameraSetPosition(-cameraGetWidth() / 2, -cameraGetHeight() / 2);


// get the shader
uniformLoopUvsUvs		 = shader_get_uniform(sh_loop_uvs, "uvs");
uniformLoopUvsSize		 = shader_get_uniform(sh_loop_uvs, "size");
uniformLoopUvsPosition	 = shader_get_uniform(sh_loop_uvs, "position");


// set up main core
mainCore = new kuiCore("main",
						new kuiUIVec2(0, 0, 0, 0), 
						new kuiUIVec2(surfaceGUIGetWidth(), 0, surfaceGUIGetHeight(), 0));
mainCore.parent = id;
mainCore.globalParent = id;

var _timelineHeight = 120;
// add other windows
windowTimeline = new kuiWindow("wTimeline",
								new kuiUIVec2(-2, 0, -_timelineHeight + 2, 1),
								new kuiUIVec2(4, 1, _timelineHeight, 0));
mainCore.elementAdd(windowTimeline);

var _inOffX = 80;
var _inOffY = 4;
var _inOffYHeight = 90;

var _timelineY = -(_inOffYHeight + _inOffY); // is on top of the animcurve
// ad inside
windowTimelineIn = new kuiWindowInternal("wTimelineIn",
										new kuiUIVec2(_inOffX, 0, _timelineY, 1),
										new kuiUIVec2(-2 * _inOffX, 1, _inOffYHeight, 0));
windowTimeline.elementAdd(windowTimelineIn);

// crea this handler
animcurveHandler = instance_create_depth(0, 0, 0, ob_animcurve_handler, {
	windowIns : windowTimelineIn
});

// add the buttons in position
var _limitTopButton = new kuiInputText("curveTop",
						new kuiUIVec2(-_inOffX + 4, 1, _timelineY - 16, 1), new kuiUIVec2(40, 0, 14, 0), "LTop: ", 30, "Set number here", "", 10, false, KUI_INPUT_TYPE.floatType,
						function () {
							
							// set the top limit to that value
							ob_animation_editor.animcurveHandler.drawLimitTop = storedNumber;
						}, fa_left);
_limitTopButton.setNoInputControl(function () { storedNumber = ob_animation_editor.animcurveHandler.drawLimitTop; });

var _limitBottomButton = new kuiInputText("curveBottom",
						new kuiUIVec2(-_inOffX + 4, 1, _timelineY, 1), new kuiUIVec2(40, 0, 14, 0), "LBut: ", 30, "Set number here", "", 10, false, KUI_INPUT_TYPE.floatType,
						function () {
							
							// set the bottom limit to that value
							ob_animation_editor.animcurveHandler.drawLimitBottom = storedNumber;
						}, fa_left);
_limitBottomButton.setNoInputControl(function () { storedNumber = ob_animation_editor.animcurveHandler.drawLimitBottom; });

// ---- FOR SELECTED POINTS IN A ANIMCURVE SETTINGS -----

#region This is for modifing the X, Y position of the point selected of the animcurve channel.

// Create a core to hold this and hide if needed
curvePointCore = new kuiCore("pointCore", new kuiUIVec2(0, 0, 0, 0), new kuiUIVec2(0, 1, 0, 1));
curvePointCore.hide = true;

// H position of the point
var _curvePointH = new kuiInputText("pointH",
						new kuiUIVec2(-_inOffX + 4, 1, _timelineY + 24, 1), new kuiUIVec2(40, 0, 14, 0), "h: ", 30, "Set number here", "", 10, false, KUI_INPUT_TYPE.floatType,
						function () {
							
							// not selected nothing
							if ((ob_animation_editor.animcurveHandler.kAnimCurveChannel != -1) && (ob_animation_editor.animcurveHandler.selectedPoint >= 0)) {
								var _points = ob_animation_editor.animcurveHandler.kAnimCurveChannel.points;
								
								// set the top limit to that value
								_points[ob_animation_editor.animcurveHandler.selectedPoint].setPosition(storedNumber, _points[ob_animation_editor.animcurveHandler.selectedPoint].y);
							};
						}, fa_left);
_curvePointH.setNoInputControl(function () { 
	// not selected nothing
	if ((ob_animation_editor.animcurveHandler.kAnimCurveChannel != -1) && (ob_animation_editor.animcurveHandler.selectedPoint >= 0)) {
	storedNumber = ob_animation_editor.animcurveHandler.kAnimCurveChannel.points[ob_animation_editor.animcurveHandler.selectedPoint].x; }; });
	
	// H position of the point
var _curvePointV = new kuiInputText("pointV",
						new kuiUIVec2(-_inOffX + 4, 1, _timelineY + 40, 1), new kuiUIVec2(40, 0, 14, 0), "v: ", 30, "Set number here", "", 10, false, KUI_INPUT_TYPE.floatType,
						function () {
							
							// not selected nothing
							if ((ob_animation_editor.animcurveHandler.kAnimCurveChannel != -1) && (ob_animation_editor.animcurveHandler.selectedPoint >= 0)) {
								var _points = ob_animation_editor.animcurveHandler.kAnimCurveChannel.points;
								
								// set the top limit to that value
								_points[ob_animation_editor.animcurveHandler.selectedPoint].setPosition(_points[ob_animation_editor.animcurveHandler.selectedPoint].x, storedNumber);
							};
						}, fa_left);
_curvePointV.setNoInputControl(function () { 
	// not selected nothing
	if ((ob_animation_editor.animcurveHandler.kAnimCurveChannel != -1) && (ob_animation_editor.animcurveHandler.selectedPoint >= 0)) {
	storedNumber = ob_animation_editor.animcurveHandler.kAnimCurveChannel.points[ob_animation_editor.animcurveHandler.selectedPoint].y; }; });


curvePointCore.elementAdd(_curvePointH, _curvePointV);

#endregion

// ---- FOR SAVE AND LOAD THE CREATED ANIMATIONS AND OBJECTS ----

// set the button to save up
var _systemSaveButton = new kuiButtonImage("save_up", new kuiUIVec2(4, 0, 3, 0), new kuiUIVec2(16, 0, 16, 0), sp_ae_system, 0,
						function () {
							
							// just save it
							var _locationSelf = get_save_filename_ext("Keso Animation (*.kesoanim)|*.kesoanim", "", program_directory, "Save the animation");
							// found
							if (_locationSelf != "") {
								
								// save it
								_locationSelf = filenameCheckExtension(_locationSelf, "kesoanim");
								
								// save here
								//saveString(ob_animation_editor.objectData, _locationSelf);
								jsonSave(aeSaveElements(ob_animation_editor.objectData), _locationSelf);
								// just save it
								show_debug_message("ANIM EDITOR: Saved up");
							};
						});
// set the button to save up
var _systemLoadButton = new kuiButtonImage("load_up", new kuiUIVec2(22, 0, 3, 0), new kuiUIVec2(16, 0, 16, 0), sp_ae_system, 1,
						function () {
							
							// just save it
							var _locationSelf = get_open_filename_ext("Keso Animation (*.kesoanim)|*.kesoanim", "", program_directory, "Load the animation");
							// found
							if (_locationSelf != "") {
								
								// clear data
								delete ob_animation_editor.objectData;
								
								// save here
								//saveString(ob_animation_editor.objectData, _locationSelf);
								ob_animation_editor.objectData = aeLoadGeneral(jsonToStruct(_locationSelf));
								
								// update list
								ob_animation_editor.objectUpdateList();
								
								show_debug_message("obdat:" + string(ob_animation_editor.objectData))
								// just save it
								show_debug_message("ANIM EDITOR: Load up");
							};
						});


/* Due this will export directly to game, we cant have a global loop, because we need to REALLY save up the loop type
// set for this loop type
animationGlobalLoopType = eAnimRepeatType.endloop; // end loop
// creat that
var _animationLoopButton = new kuiButtonImage("loop_type", new kuiUIVec2(_inOffX, 0, 3, 0), new kuiUIVec2(16, 0, 16, 0), sp_ae_loop_type, animationGlobalLoopType,
						function () {
							
							// go next
							ob_animation_editor.animationGlobalLoopType++;
							// set up limit
							if (ob_animation_editor.animationGlobalLoopType >= 3) {
								// reset it
								ob_animation_editor.animationGlobalLoopType = 0;
							};
							
							// here
							show_debug_message("ANIM EDITOR: Changed animation loop type");
						});
_animationLoopButton.userSetStepEvent(function () {
	// set the flobal loop]
	elements.imageUI.imageIndex = ob_animation_editor.animationGlobalLoopType;
});//*/


// creat that
var _animationLoopButton = new kuiButtonImage("loop_type", new kuiUIVec2(_inOffX, 0, 3, 0), new kuiUIVec2(16, 0, 16, 0), sp_ae_loop_type, /*animationGlobalLoopType*/3,
						function () {
							
							// there is a selecred animatioon
							if (ob_animation_editor.animationSelectedExists()) {
								// get the global id
								var _animationId = ob_animation_editor.animationSelectedGetId();
								// go next
								_animationId.animLoopType++;
								// set up limit
								if (_animationId.animLoopType >= 3) {
									// reset it
									_animationId.animLoopType = 0;
								};
								
								// here
								show_debug_message("ANIM EDITOR: Changed animation loop type");
							};
							
							show_debug_message("ANIM EDITOR: Couldn't change animation loop type because BRO, YOU DIDNT SELECT ANYTHING WHAA??");
						});
_animationLoopButton.userSetStepEvent(function () {
	// there is a selecred animatioon
	if (ob_animation_editor.animationSelectedExists()) {
		// get the global id
		var _animationId = ob_animation_editor.animationSelectedGetId();
		// set the flobal loop]
		elements.imageUI.imageIndex = _animationId.animLoopType;
	
	// well, if nothing selected just put an X
	} else { elements.imageUI.imageIndex = 3; };
});

// creat that
var _animationPlayingButton = new kuiButtonImage("playing", new kuiUIVec2(_inOffX + 18, 0, 3, 0), new kuiUIVec2(16, 0, 16, 0), sp_ae_anim_play, 0,
						function () {
							
							// has it?
							if (!ob_animation_editor.animationSelectedExists()) { exit; };
							// save it
							var _animationId = ob_animation_editor.animationSelectedGetId();
							
							// is not playing
							if (!_animationId.isPlaying) {
								_animationId.animPlay();
							} else {
								if (_animationId.isPaused) {
									_animationId.animResume();
								} else {
									_animationId.animPause();
								};
							};
							
						});
_animationPlayingButton.userSetStepEvent(function () {
	// has it?
	if (!ob_animation_editor.animationSelectedExists()) { hide = true; exit; };
	// not hide
	hide = false;
	
	// get the animation
	var _animationId = ob_animation_editor.animationSelectedGetId();
	
	// is not playing
	if (!_animationId.isPlaying) {
		elements.imageUI.imageIndex = 0;
	} else {
		elements.imageUI.imageIndex = 1 + !_animationId.isPaused;
	};
});

// heckour for data thing
var _animationValueEditButton = new kuiInputText("value_edit", new kuiUIVec2(_inOffX + 36, 0, 4, 0), new kuiUIVec2(50, 0, 14, 0), "Value: ", 40, "Animation Value",
								"", 10, false, KUI_INPUT_TYPE.floatType, function () {
									
									// has it?
									if (!ob_animation_editor.animationSelectedExists()) { exit; };
									// save it
									var _animationId = ob_animation_editor.animationSelectedGetGlobalParentId();
									
									// is in range
									_animationId.animValue = storedNumber;
									
								}, fa_left, fa_top, function () {
									// has it?
									if (!ob_animation_editor.animationSelectedExists()) { hide = true; exit; };
									// not hide
									hide = false;
									// save it
									var _animationId = ob_animation_editor.animationSelectedGetGlobalParentId();
									
									// sert the
									storedNumber = _animationId.animValue;
								});
_animationValueEditButton.userSetCheckout(function (_text) {
	// convert to real
	var _realTemp = real(_text);
	// in range
	return ((_realTemp >= 0) && (_realTemp <= 1));
});

// heckour for data thing
var _animationShiftEditButton = new kuiInputText("fpsDuration", new kuiUIVec2(_inOffX + 128, 0, 4, 0), new kuiUIVec2(50, 0, 14, 0), "FPS D: ", 40, "FPS Duration",
								"", 10, false, KUI_INPUT_TYPE.floatType, function () {
									
									// has it?
									if (!ob_animation_editor.animationSelectedExists()) { exit; };
									// save it
									var _animationId = ob_animation_editor.animationSelectedGetGlobalParentId();
									// get the main curve
									var _channelCurve = _animationId.mainCurve.channelGet("shift");
									_channelCurve.pointGet(0).y = 1 / storedNumber;
									_channelCurve.pointGet(1).y = 1 / storedNumber;
									
								}, fa_left, fa_top, function () {
									// has it?
									if (!ob_animation_editor.animationSelectedExists()) { hide = true; exit; };
									// not hide
									hide = false;
									// save it
									var _animationId = ob_animation_editor.animationSelectedGetGlobalParentId();
									var _channelCurve = _animationId.mainCurve.channelGet("shift");
									
									// sert the
									storedNumber = 1 / _channelCurve.checkOnX(0);
								});
_animationShiftEditButton.userSetCheckout(function (_text) {
	// convert to real
	var _realTemp = real(_text);
	// in range
	return (_realTemp >= 0);
});


// add to it
windowTimeline.elementAdd(_limitTopButton, _limitBottomButton, curvePointCore, _systemSaveButton, _systemLoadButton, _animationLoopButton, _animationPlayingButton, _animationValueEditButton, _animationShiftEditButton);

debugVSetValue("showUICreation", true);
debugVSetValue("showEAnimCreation", true);

// set up a list
objectList = new kuiList("obList", new kuiUIVec2(10, 0, 10, 0), new kuiUIVec2(150, 0, 200, 0),
						function (_oId, _listParent, _infoStruct, _oX, _oY, _oW, _oH) {
							
							var _myOffX							 = structRead(_infoStruct, "offsetX", 0);
							var _myButtonParent					 = structRead(_infoStruct, "buttonParent", noone);
							var _internalOptionId				 = structRead(_infoStruct, "internalOptionId", _oId);
							var _animationType					 = structRead(_infoStruct, "animationType", -1);
							var _animationOriginalObject		 = structRead(_infoStruct, "originalObject", -1);
							// get that object name
							
							var _internalWindow = new kuiWindowInternal(string(_oId) + "_" + string(current_time) + "window",
										new kuiUIVec2(0, 0, 0, 0),
										new kuiUIVec2(0, 1, 0, 1));
							
							// get the button ins name
							var _objectName;
							
							if (_animationType == eAnimType.objectChannelAnimation) { _objectName = _animationOriginalObject; } else
							{ _objectName = _animationOriginalObject.id; };
							
							
							var _objectImgIndex = 0;
							switch (_animationType) {
								case eAnimType.sprite: _objectImgIndex = 1; break;
								
								case eAnimType.animationSprite: _objectImgIndex = 4; break;
								
								case eAnimType.animation: _objectImgIndex = 2; break;
								
								case eAnimType.objectChannelAnimation: _objectImgIndex = 3; break;
							};
							
							
							
							
							// set it up
							var _buttonListIns = new kuiCheckerButton(string(_oId) + "_" + string(current_time) + "button",
																	new kuiUIVec2(_myOffX, 0, 0, 0), new kuiUIVec2(-_myOffX, 1, 0, 1), 
																	function () {
								/* */
								#region Pressed button of object, so open the list or do what the object requires
								
								show_debug_message("Called PRESS event on button.");
								
								// if type if that
								if (animationType == eAnimType.objectChannelAnimation) {
									
									// is selecting the animation
									if (!ob_animation_editor.objectAnimationCompatible(myButtonParent.animationOriginalObject)) { myButtonParent.unpressCallback(); };
									
									// select the channel
									ob_animation_editor.animationChannelSelect(animationOriginalObject);
									// get channel id
									var _channelId = ob_animation_editor.animationChannelSelectedGetId();
									
									// set the limits
									ob_animation_editor.animcurveHandler.drawLimitTop = _channelId.limitTop;
									ob_animation_editor.animcurveHandler.drawLimitBottom = _channelId.limitBottom;
									
									// yes sir
									myButtonParent.spriteChildrenAnimationChannelSelected = animationOriginalObject;
									
									
									// not openede
									opened = false;
									return;
								};
								
								// was selecred
								var _ocSelection = ob_animation_editor.objectSelectedGetId();
								// select the object
								ob_animation_editor.objectSelect(animationOriginalObject);
								
								// has to open something?
								if (array_length(insideButtonsData) <= 0) {
									// was already selected?
									if (_ocSelection == animationOriginalObject) {
										// de select
										ob_animation_editor.objectSelectedDeselect();
									};
									// not openede
									opened = false;
									return;
								};
								// already opened?
								if (opened) {
									// end it up
									unpressCallback();
								};
								// do the step event
								parent.stepEvent();
								stepUserEvent();
								
								// clear up
								if (array_length(myButtons) > 0) { array_delete(myButtons, 0, array_length(myButtons)); };
								
								show_debug_message("Adding from: (" + string(listOId) + ") of option " + string(animationId));
								// loop for each one
								for (var i = 0; i < array_length(insideButtonsData); i++) {
									
									var _returnData = parent.optionAddFrom(listOId + i, insideButtonsData[i]);
									
									// concat array
									myButtons = array_concat(myButtons, _returnData);
								};
								
								// opened
								opened = true;
								
								exit;
								
								#endregion
								/* */
							}, function () {
								/* */
								#region When object unpresses, so close the list and delete my extra buttons
								
								show_debug_message("Called UNPRESS event on button.");
								// If its a channel, we dont need to do ANYTHING. Just close it.
								if (animationType == eAnimType.objectChannelAnimation) {
									opened = false;
									exit;
								};
								
								// is opened and not selcted?
								if (opened && (ob_animation_editor.objectSelectedGetId() != animationOriginalObject) && (unpressSelectCheck)) {
									
									// select the object
									ob_animation_editor.objectSelect(animationOriginalObject);
									exit;
								};
								
								// search up for my buttons
								for (var i = 0; i < array_length(myButtons); i++) {
									// self destroy
									//myButtons[i].selfDestroy();
									parent.optionDelete(myButtons[i].listOId);
									// update it
									parent.stepEvent();
								};
								// opened
								opened = false;
								// get the selected
								if (ob_animation_editor.objectSelectedGetId() == animationOriginalObject) {
									// deselect
									ob_animation_editor.objectSelectedDeselect();
								};
								
								// THIS IS FOR DESELECT OWN ANIMATION CHANNEL WHEN CLOSING UP SPRITE
								if ((animationType == eAnimType.sprite) || (animationType == eAnimType.object)) {
									// check this up
									if ((spriteChildrenAnimationChannelSelected != "") && (spriteChildrenAnimationChannelSelected == ob_animation_editor.animationChannelSelected)) {
										// check for object
										if (ob_animation_editor.objectAnimationCompatible(animationOriginalObject)) {
											// deselect
											ob_animation_editor.animationChannelDeselect();
										};
									};
								};
								
								#endregion
								/* */
							}, function () { return opened; });
							
							/* */
							#region Add the text, image, and details to the button (UI asthetic)
							
							// Add text inside
							var _textUI = new kuiText("textUI", new kuiUIVec2(16, 0, 0, 0), new kuiUIVec2(-16, 1, 0, 1), _objectName, c_black, fa_left, fa_middle);
							// Add image too
							var _imageUI = new kuiImage("imageUI", sp_ae_type, _objectImgIndex, new kuiUIVec2(2, 0, 1, 0), new kuiUIVec2(12, 0, -2, 1)); 
							// A list image
							var _imageList = new kuiImage("imageList", sp_kui_list_button, 0, new kuiUIVec2(-12, 1, -3.5, 0.5), new kuiUIVec2(7, 0, 7, 0));
							// Add to myself
							_buttonListIns.elementAdd(_textUI, _imageUI, _imageList);
							
							#endregion
							/* */
							
							// set up destroy event
							_buttonListIns.destroyEvent = method(_buttonListIns, function () {
								// is openede?
								if (opened) {
									// set it up
									unpressSelectCheck = false;
									// unpress it
									unpressCallback();
								};
							});
							// adjust this
							_buttonListIns.myButtonParent = _myButtonParent;
							_buttonListIns.myOcOffX = _myOffX;
							// opened extra buttons
							_buttonListIns.opened = false;
							
							_buttonListIns.listOId = _oId;
							// Adjust for what it should open
							_buttonListIns.insideButtonsData = [ ];
							// should say:
							/*
								{
									animationType: animationType
									originalObject : animationOriginalObject
								}
							*/
							// button type too
							_buttonListIns.animationType = _animationType;
							_buttonListIns.animationOriginalObject = _animationOriginalObject;
							// get name
							if (_animationType != eAnimType.objectChannelAnimation) { _buttonListIns.animationId = _animationOriginalObject.id; };
							
							// set it up
							_buttonListIns.internalOptionId = _internalOptionId;
							// added buttons
							_buttonListIns.myButtons = [ ];
							
							_buttonListIns.unpressSelectCheck = true;
							
							// for sprites only
							_buttonListIns.spriteChildrenAnimationChannelSelected = "";
							
							// update here
							_buttonListIns.userSetStepEvent(function () {
								
								// before doing anything, clear this up
								if (array_length(insideButtonsData) > 0) { array_delete(insideButtonsData, 0, array_length(insideButtonsData)); };
								
								// if type if that
								if (animationType == eAnimType.objectChannelAnimation) {
									
									// get the selected
									if (ob_animation_editor.animationChannelSelected == animationOriginalObject) {
										// set up text
										elements.textUI.setColor(COLOR_YELLOW);
									} else {
										// reset it back
										elements.textUI.setColor(c_black);
									};
									
									exit;
								};
								
								// exists?
								if (!eAnimExists(animationOriginalObject)) { exit; };
								
								// get the selected
								if (ob_animation_editor.objectSelectedGetId() == animationOriginalObject) {
									// set up text
									elements.textUI.setColor(COLOR_YELLOW);
								} else if (ob_animation_editor.animationSelectedGetId() == animationOriginalObject) { 
									// set up text
									elements.textUI.setColor(COLOR_FUCHSIA);
								} else {
									// reset it back
									elements.textUI.setColor(c_black);
								};
								// is opened
								elements.imageList.setImageIndex(opened);
								
								// switch the type
								switch (animationOriginalObject.type) {
									
									case eAnimType.object:
										
										// read up elements
										var _elementsName = struct_get_names(animationOriginalObject.elements);
										for (var i = 0; i < array_length(_elementsName); i++) {
											// get the element ID
											var _elementId = animationOriginalObject.elements[$ _elementsName[i]];
											
											insideButtonsData[i] = {
												
												offsetX : myOcOffX + 5,
												buttonParent : mySelf,
												internalOptionId : i,
												
												animationType : _elementId.type,
												originalObject : _elementId.mySelf
											};
										};
									break;
									
									case eAnimType.sprite:
										
										// read up elements
										var _elementsName = struct_get_names(animationOriginalObject.elements);
										for (var i = 0; i < array_length(_elementsName); i++) {
											// get the element ID
											var _elementId = animationOriginalObject.elements[$ _elementsName[i]];
											
											insideButtonsData[i] = {
												
												offsetX : myOcOffX + 5,
												buttonParent : mySelf,
												internalOptionId : i,
												
												animationType : _elementId.type,
												originalObject : _elementId.mySelf
											};
										};
									break;
								};
								// sprite or object, FOR ANIM, this is for an anim curve that is on the same layer and its comaptible to handle with
								if ((animationOriginalObject.type == eAnimType.sprite) || (animationOriginalObject.type == eAnimType.object)) {
									
									// has animation?
									if (ob_animation_editor.objectAnimationCompatible(animationOriginalObject)) {
										// get the anim curve
										var _animCurve = ob_animation_editor.animationSelectedGetId().mainCurve;
										// get the mentioned curveds
										var _valuesOfTheObject = eAnimKCurveGetMentionedValues(_animCurve, animationOriginalObject.id);
										
										//
										var _finalId;
										// loop for it
										for (var i = 0; i < array_length(_valuesOfTheObject); i++) {
												
											_finalId = array_length(insideButtonsData);
											// push in
											array_push(insideButtonsData, {
												
												offsetX : myOcOffX + 5,
												buttonParent : mySelf,
												internalOptionId : _finalId,
												
												animationType : eAnimType.objectChannelAnimation,
												originalObject : animationOriginalObject.id + "_" + _valuesOfTheObject[i]
											});
										};
									};
								};
							});
							
							// Add content to list
							_listParent.optionAddElement(_oId, _internalWindow, _buttonListIns);
							
							return _buttonListIns;
						},
						function (_oId, _listParent, _infoStruct, _oX, _oY, _oW, _oH) {
							
							// get the elemnts
							var _buttonListIns = _listParent.optionGetElements(_oId)[1];
							
							// set up it
							_buttonListIns.listOId = _oId;
						});



// get this up
objectDataWindow = new kuiWindow("objectData", new kuiUIVec2(-185, 1, 5, 0), new kuiUIVec2(180, 0, 200, 0));
// add to it
objectDataWindow.objectDataTransform = new kuiCore("objectTransform", new kuiUIVec2(4, 0, 4, 0), new kuiUIVec2(-8, 1, 62, 0));
objectDataWindow.objectDataTransform.uiDeactive();

// add to it
objectDataWindow.objectDataIdHandler = new kuiCore("objectIdHandler", new kuiUIVec2(4, 0, 4, 0), new kuiUIVec2(-8, 1, 62, 0));
objectDataWindow.objectDataIdHandler.uiDeactive();

// and add to it
var _objectDataId = new aeInputSelectedElement("idHandler", new kuiUIVec2(0, 0, 0, 0), new kuiUIVec2(-25, 1, 14, 0), "id", "Id:", 25, "Name", "", 60, KUI_INPUT_TYPE.stringType, fa_left, fa_middle, c_black,
							function (_newValue) {
								var _selectedId = globalParent.objectSelectedGetId();
								originalSelectedObject = _selectedId;
								originalSelectedId = _selectedId.id;
								originalSelectedTree = globalParent.objectSelected;
								// get th eobject id
								if (array_length(globalParent.objectSelected) > 1) {
									// get the parent
									return !struct_exists(_selectedId.parent.elements, _newValue);
								} else {
									// not in data
									return !struct_exists(globalParent.objectData, _newValue);
								};
							}, 
							function () {
								// get th eobject id
								if (array_length(originalSelectedTree) > 1) {
									// delete originla
									struct_remove(originalSelectedObject.parent.elements, originalSelectedId);
									struct_set(originalSelectedObject.parent.elements, originalSelectedObject.id, originalSelectedObject);
								} else {
									// delete originla
									struct_remove(globalParent.objectData, originalSelectedId);
									struct_set(globalParent.objectData, originalSelectedObject.id, originalSelectedObject);
								};
								// deselect
								globalParent.objectSelectedDeselect();
								// update it
								globalParent.objectUpdateList();
								// select this object
								globalParent.objectSelect(originalSelectedObject);
								// update posiiton data
								globalParent.objectPositionDataUpdate();
							});

// add here
objectDataWindow.objectDataIdHandler.elementAdd(_objectDataId);


// and add to it
var _objectDataX = new aeInputSelectedElement("xPos", new kuiUIVec2(0, 0, 16, 0), new kuiUIVec2(50, 0, 14, 0), "x", "X:", 12, "X position", "", 60, KUI_INPUT_TYPE.floatType);

// and add to it
var _objectDataY = new aeInputSelectedElement("yPos", new kuiUIVec2(0, 0, 32, 0), new kuiUIVec2(50, 0, 14, 0), "y", "Y:", 12, "Y position", "", 60, KUI_INPUT_TYPE.floatType);


// and add to it
var _objectDataXScale = new aeInputSelectedElement("xScale", new kuiUIVec2(75, 0, 16, 0), new kuiUIVec2(50, 0, 14, 0), "xScale", "X Scale:", 45, "X scale", "", 60, KUI_INPUT_TYPE.floatType);

// and add to it
var _objectDataYScale = new aeInputSelectedElement("yScale", new kuiUIVec2(75, 0, 32, 0), new kuiUIVec2(50, 0, 14, 0), "yScale", "Y Scale:", 45, "Y scale", "", 60, KUI_INPUT_TYPE.floatType);


// and add to it
var _objectDataRot = new aeInputSelectedElement("angle", new kuiUIVec2(0, 0, 48, 0), new kuiUIVec2(50, 0, 14, 0), "angle", "Angle:", 40, "Angle", "", 60, KUI_INPUT_TYPE.floatType);

// srt it up
objectDataWindow.objectDataTransform.elementAdd(_objectDataX, _objectDataY, _objectDataRot, _objectDataXScale, _objectDataYScale);

// add to it
objectDataWindow.spriteDataTransform = new kuiCore("spriteTransform", new kuiUIVec2(4, 0, 68, 0), new kuiUIVec2(-8, 1, 46, 0));
objectDataWindow.spriteDataTransform.uiDeactive();

// and add to it
var _spriteDataDepth = new aeInputSelectedElement("depth", new kuiUIVec2(0, 0, 0, 0), new kuiUIVec2(50, 0, 14, 0), "myDepth", "Depth", 40, "Depth", "", 60, KUI_INPUT_TYPE.floatType);
// srt it up
objectDataWindow.spriteDataTransform.elementAdd(_spriteDataDepth);

// add to it
objectDataWindow.objectDataTimeline = new kuiCore("objectTimeline", new kuiUIVec2(4, 0, 84, 0), new kuiUIVec2(-8, 1, 46, 0));
objectDataWindow.objectDataTimeline.uiDeactive();

#region Add the object animation add (Position, Scale, etc)
// and add to it
var _objectDataTimeline = new kuiListButton("animationElements", new kuiUIVec2(0, 0, 0, 0), new kuiUIVec2(0, 1, 14, 0), "Add Animation", 50,
						function (_oId, _listParent, _infoStruct, _oX, _oY, _oW, _oH) {
							// creatte the button
							var _buttonList = new kuiButtonText(string(current_time) + "_" + string(_oId),
												new kuiUIVec2(0, 0, 0, 0), new kuiUIVec2(0, 1, 0, 1),
												structRead(_infoStruct, "valuesName", ""), function () {
													
													// set it
													if (ob_animation_editor.objectSelectedExists()) {
														// get the data
														var _obId = ob_animation_editor.objectSelectedGetId();
														// now we need the animation
														if (ob_animation_editor.animationSelectedExists()) {
															// get the animation
															var _animId = ob_animation_editor.animationSelectedGetId();
															// get the main curve
															var _animCurve = _animId.mainCurve;
															
															// loop for needed
															var _valuesNames = struct_get_names(buttonValuesGrab);
															for (var i = 0; i < array_length(_valuesNames); i++) {
																
																// get the values
																var _valueStruct = buttonValuesGrab[$ _valuesNames[i]];
																
																// try to add it
																animCurveAddChannel(_animCurve, _obId, _valuesNames[i], _valueStruct);
															};
															
															// update it
															ob_animation_editor.objectUpdateList();
														};
													};
													// die
													buttonListParent.selfDestroy();
												});
							// give it a function to add values
							_buttonList.animCurveAddChannel = method(_buttonList, function (_kCurveId, _obId, _valueId, _valueStruct) {
								
								// create the name
								var _channelName = _obId.id + "_" + _valueId;
								
								// it does not exists
								if (!_kCurveId.channelExists(_channelName)) {
									// add the channel with the deafult value
									var _channelNew = new kesoAnimCurveChannel(_channelName, _valueStruct.value, _valueStruct.value, kesoAnimCurveCurveType.beizer);
									// set limit
									_channelNew.limitTop	 = _valueStruct.top;
									_channelNew.limitBottom	 = _valueStruct.bottom;
									
									// add to it
									return _kCurveId.channelAdd(_channelNew);
								};
							})
							// save up the info struct
							_buttonList.buttonValuesGrab = structRead(_infoStruct, "initValues", -1);
							// the parent
							_buttonList.buttonListParent = _listParent;
							
							// add to list
							_listParent.optionAddElement(_oId, _buttonList);
						},
						[
							{
								valuesName : "Position (x, y)",
								initValues : {
									
									x : { value : 0, top : 20, bottom : -20 },
									y : { value : 0, top : 20, bottom : -20 }
								}
							},
							
							{
								valuesName : "Scale (x, y, e)",
								initValues : {
									
									xScale : { value : 1, top : 1.5, bottom : 0.5 },
									yScale : { value : 1, top : 1.5, bottom : 0.5 },
									eScale : { value : 1, top : 1.5, bottom : 0.5 },
								}
							},
							
							{
								valuesName : "Alpha",
								initValues : {
									
									alpha : { value : 1, top : 1, bottom : 0 },
								}
							},
							
							{
								valuesName : "Angle",
								initValues : {
									
									angle : { value : 0, top : 180, bottom : -180 },
								}
							},
							
							{
								valuesName : "Depth",
								initValues : {
									
									depth : { value : 0, top : 20, bottom : -20 },
								}
							},
						]);
#endregion

// srt it up
objectDataWindow.objectDataTimeline.elementAdd(_objectDataTimeline);


// sert up to animation
objectDataWindow.animationData = new kuiCore("animationData", new kuiUIVec2(4, 0, 20, 0), new kuiUIVec2(-8, 1, 0, 93));
objectDataWindow.animationData.uiDeactive();

// set the link button
var _animationDataLink = new kuiListButton("linkAnimation", new kuiUIVec2(0, 0, 0, 0), new kuiUIVec2(0, 1, 14, 0), "Link Animation", 50,
						function (_oId, _listParent, _infoStruct, _oX, _oY, _oW, _oH) {
							
							// get the info struct
							var _animationInstance = structRead(_infoStruct, "animationId", -1);
							// creat eh button here
							var _buttonList = new kuiButtonText(string(current_time) + string(_oId), new kuiUIVec2(0, 0, 0, 0), new kuiUIVec2(0, 1, 0, 1),
																_animationInstance.id, function () {
																	
																	// get the object
																	var _eObjectId = ob_animation_editor.objectSelectedGetId();
																	
																	// link to it
																	_eObjectId.animLinkValueToAnim(animationInstance, eAnimLinkType.aFull);
																	// delete list parent
																	listParent.selfDestroy();
																})
							// save up
							_buttonList.animationInstance = _animationInstance;
							_buttonList.listParent = _listParent;
							
							// add it
							_listParent.optionAddElement(_oId, _buttonList);
							
						}, [ ], function () { }, function () {
							
							// restore this
							__listOptions = [ ];
							// get it
							var _selectedOb = ob_animation_editor.objectSelectedGetId();
							var _arrayConcat = ob_animation_editor.objectSearchObjectType(eAnimType.animation);
							// loop for all of it
							for (var i = 0; i < array_length(_arrayConcat); i++) {
								
								// is not myself
								if (_arrayConcat[i][0] != _selectedOb) {
									
									// set it
									array_push(__listOptions, {
										
										animationId : _arrayConcat[i][0],
										animationIdTree : _arrayConcat[i][1]
									});
								};
							};
						});

// creat that
var _animationUnlinkButton = new kuiButtonText("unlink", new kuiUIVec2(0, 0, 16, 0), new kuiUIVec2(0, 1, 14, 0), "Unlink",
						function () {
							
							// has it?
							if (!ob_animation_editor.animationSelectedExists()) { exit; };
							// save it
							var _animationId = ob_animation_editor.animationSelectedGetId();
							
							// is not playing
							if (eAnimExists(_animationId.linkValueTo)) {
								_animationId.animUnlinkValueToAnim();
							};
						});
_animationUnlinkButton.userSetStepEvent(function () {
	// has it?
	if (!ob_animation_editor.animationSelectedExists()) { hide = true; exit; };
	// must have
	if (!eAnimExists(ob_animation_editor.animationSelectedGetId().linkValueTo)) { hide = true; exit; };
	// not hide
	hide = false;
});



objectDataWindow.animationData.elementAdd(_animationDataLink, _animationUnlinkButton);

// incluse it
objectDataWindow.elementAdd(objectDataWindow.objectDataTransform, objectDataWindow.spriteDataTransform, objectDataWindow.objectDataTimeline, objectDataWindow.objectDataIdHandler, objectDataWindow.animationData);

// set user step event
objectDataWindow.userSetStepEvent(function () {
	
	// quit out
	objectDataIdHandler.uiDeactive();
	objectDataTransform.uiDeactive();
	spriteDataTransform.uiDeactive();
	objectDataTimeline.uiDeactive();
	animationData.uiDeactive();
	// selected one
	if (ob_animation_editor.objectSelectedExists()) {
		// get the data
		var _oId = ob_animation_editor.objectSelectedGetId();
		// turn it on
		objectDataIdHandler.uiActive();
		
		// exists?
		if (_oId.type == eAnimType.object || _oId.type == eAnimType.sprite) {
			
			// is active
			if (ob_animation_editor.animationSelectedExists() && (ob_animation_editor.animationSelectedGetId().parent == _oId.parent)) { objectDataTimeline.uiActive(); };
			
			// active this
			objectDataTransform.uiActive();
			// only sprites
			if (_oId.type == eAnimType.sprite) {
				spriteDataTransform.uiActive();
			};
		};
		// is animation
		if (_oId.type == eAnimType.animation) {
			// active
			animationData.uiActive();
		};
	};
});

mainCore.elementAdd(objectList, objectDataWindow);





clipboardContain = -1;

cameraScrolling = 0;
cameraScrollingMouseX = 0;
cameraScrollingMouseY = 0;

#region Declare variables to make object transform work, like edit position and rotation

objectTransformPhase = "wait";
objectTransformAngleOff = 0;
objectTransformXOff = 0;
objectTransformYOff = 0;
objectTransformXMainOff = 0;
objectTransformYMainOff = 0;

objectTransformXOCOff = 0;
objectTransformYOCOff = 0;

#endregion
/* */
#region Create a list to ssave in all the existent sprites of the project

// get the spriotes
spriteListMain = [  ];
// get all the sprites here
var _checkinSprite = 0;
while (sprite_exists(_checkinSprite)) {
	// add to list
	show_debug_message("Added sprite to list: " + sprite_get_name(_checkinSprite));
	// add to array
	array_push(spriteListMain, [ sprite_get_name(_checkinSprite), _checkinSprite ] );
	
	// go next
	_checkinSprite++;
};

#endregion

// add object data, here is all the main objects created without a parent
objectData = { };

#region Position, rotation and drawing data of all the objects

// adjust to it
objectPositionData = { };
// update it
objectPositionDataUpdate = function () {
	
	// clear up
	objectPositionData = { };
	
	// get all the data
	var _objectNames = struct_get_names(objectData);
	// one by one
	for (var i = 0; i < array_length(_objectNames); i++) {
		// get it
		var _objectId = objectData[$ _objectNames[i]];
		// must be an object
		if (_objectId.type == eAnimType.object) {
			// yup? add it
			objectPositionData[$ _objectId.id] = eAnimObjectPositionData(_objectId, _objectId.x, _objectId.y);
		};
	};
};

objectPositionDataDraw = function (_camUISize, _dataStart = objectPositionData) {
	
	// get all the data
	var _objectNames = struct_get_names(_dataStart);
	// one by one
	for (var i = 0; i < array_length(_objectNames); i++) {
		// get it
		var _dataOfSelected = _dataStart[$ _objectNames[i]];
		// is not object or sprite?
		if ((_dataOfSelected.type != eAnimType.sprite) && (_dataOfSelected.type != eAnimType.object)) { continue; };
		// draw in main thing
		draw_sprite_ext(sp_ae_cursor, 0, _dataOfSelected.mainX, _dataOfSelected.mainY, _dataOfSelected.mainXScale * _camUISize, _dataOfSelected.mainYScale * _camUISize, _dataOfSelected.mainAngle, c_white, 0.5);
		// loop for elements
		objectPositionDataDraw(_camUISize, _dataOfSelected.elements);
	};
};
// and search for it
objectPositionDataGetSelected = function () {
	
	// do exists?
	if (!objectSelectedExists()) { return -1; };
	
	// last object selected
	var _lastSelectedObject = objectPositionData;
	//show_debug_message("search pos:" + string(objectSelected));
	
	var _maxRange = array_length(objectSelected);
	// go inside the thing here
	for (var i = 0; i < _maxRange; i++) {
		// get the ID
		var _nameId = objectSelected[i];
		// is the last one?
		if (i == (_maxRange - 1)) {
			
			return _lastSelectedObject[$ _nameId];
		} else {
			
			// enter there
			_lastSelectedObject = _lastSelectedObject[$ _nameId].elements;
		};
	};
	
	return -1;
};

objectPositionDataSelectedExists = function () {
	// do exists?
	if (!objectSelectedExists()) { return false; };
	
	// last object selected
	var _lastSelectedObject = objectPositionData;
	//show_debug_message("search pos:" + string(objectSelected));
	
	var _maxRange = array_length(objectSelected);
	// go inside the thing here
	for (var i = 0; i < _maxRange; i++) {
		// get the ID
		var _nameId = objectSelected[i];
		// doesnt exists?
		if (!struct_exists(_lastSelectedObject, _nameId)) { return false; };
		// is the last one?
		if (i == (_maxRange - 1)) {
			// exists?
			return true;
		} else {
			
			// enter there
			_lastSelectedObject = _lastSelectedObject[$ _nameId].elements;
		};
	};
	
	return false;
};

#endregion

// an array with depths of the object
objectSelected = [ ];
// and a selected array for animations, works the same as objectSelected
animationSelected = [ ];
// if the curve is selected
animationChannelSelected = ""; // the name of the curve
// save it all
objectMainButtons = [ ];

/// @description Deselect animations
animationSelectedDeselect = function () { array_delete(animationSelected, 0, array_length(animationSelected)); };
/// @description Verifies if the animation selected exists, if the array is valid, if not, deselects it
animationSelectedExists = function () {

	// last object selected
	var _lastSelectedObject = objectData;
	// do have?
	if (array_length(animationSelected) <= 0) { return false; };
	
	var _maxRange = array_length(animationSelected);
	// go inside the thing here
	for (var i = 0; i < _maxRange; i++) {
		// get the ID
		var _nameId = animationSelected[i];
		// is the last one?
		if ((i == (_maxRange - 1)) && (struct_exists(_lastSelectedObject, _nameId))) { return true; };
		
		// go inside the tree
		if (struct_exists(_lastSelectedObject, _nameId)) {
			// what is it?
			_lastSelectedObject = _lastSelectedObject[$ _nameId].elements;
			// continue
			continue;
			
		} else {
			// reset up
			animationSelectedDeselect();
			// error when selecting
			show_debug_message("Anim Editor: NO ANIMATION SELECTED, NOT FOUND");
			
			return false;
		};
	};
	
	return true;
};

animationChannelSelect = function (_channelId) {
	
	// is there a selected animation curve?
	if (!animationSelectedExists()) { exit; };
	// get it
	var _animCurve = animationSelectedGetId().mainCurve;
	
	// does channel exists?
	if (_animCurve.channelExists(_channelId)) {
		
		// select it
		animationChannelSelected = _channelId;
		// select the channel up
		animcurveHandler.kAnimCurveChannel = _animCurve.channelGet(_channelId);
		// clear up
		animcurveHandler.restoreValues();
	};
};

animationChannelDeselect = function () {
	
	// has anim curve holding
	if (animcurveHandler.kAnimCurveChannel != -1) {
		// deselect it
		animcurveHandler.kAnimCurveChannel = -1;
		animcurveHandler.restoreValues();
	};
	// restart this up
	animationChannelSelected = "";
	
};

animationChannelSelectedExists = function () {
	
	// is there a selected animation curve?
	if (!animationSelectedExists()) { animationChannelDeselect(); return false; };
	// get it
	var _animCurve = animationSelectedGetId().mainCurve;
	// doesn't channel exists?
	if (!_animCurve.channelExists(animationChannelSelected)) {
		// reset it
		animationChannelDeselect();
		return false;
	};
	// now verify for last
	return (animationChannelSelected != "");
};

animationChannelSelectedGetId = function () {
	
	// is there a selected animation curve and channel?
	if (!animationChannelSelectedExists()) { return; };
	
	// return the selected channel
	return animationSelectedGetId().mainCurve.channelGet(animationChannelSelected);
};





// for animations
objectAnimationCompatible = function (_objectId) {
	
	// has animation selected?
	if (!animationSelectedExists()) { return false; };
	
	// finally, the same parent
	return ((_objectId.parent) == (animationSelectedGetId().parent));
};
// is with animation id
objectSelectedAnimationCompatible = function () {
	
	// does exists?
	if (!objectSelectedExists()) { return false; };
	// has animation selected?
	if (!animationSelectedExists()) { return false; };
	
	// finally, the same parent
	return ((objectSelectedGetId().parent) == (animationSelectedGetId().parent));
};

/// @description How many parents do have?
objectSelectedParentCount = function () { return array_length(objectSelected) - 1; };
/// deselect
objectSelectedDeselect = function () { array_delete(objectSelected, 0, array_length(objectSelected)); };
/// @description If the object selected data works as intented
objectSelectedExists = function () {
	
	// last object selected
	var _lastSelectedObject = objectData;
	// do have?
	if (array_length(objectSelected) <= 0) { return false; };
	
	var _maxRange = array_length(objectSelected);
	// go inside the thing here
	for (var i = 0; i < _maxRange; i++) {
		// get the ID
		var _nameId = objectSelected[i];
		// is the last one?
		if ((i == (_maxRange - 1)) && (struct_exists(_lastSelectedObject, _nameId))) { return true; };
		
		// go inside the tree
		if (struct_exists(_lastSelectedObject, _nameId)) {
			// what is it?
			_lastSelectedObject = _lastSelectedObject[$ _nameId].elements;
			// continue
			continue;
			
		} else {
			// reset up
			objectSelectedDeselect();
			// error when selecting
			show_debug_message("Anim Editor: NO OBJECT SELECTED, NOT FOUND");
			
			return false;
		};
	};
	
	return true;
};



/// @description returns the eAnim object Id, not the button id
objectSelectedGetId = function () {
	
	// do exists?
	if (!objectSelectedExists()) { return -1; };
	
	// last object selected
	var _lastSelectedObject = objectData;
	// go inside the thing here
	for (var i = 0; i < array_length(objectSelected); i++) {
		// get the ID
		var _nameId = objectSelected[i];
		// is the last one?
		if (i == objectSelectedParentCount()) {
			
			return _lastSelectedObject[$ _nameId].mySelf;
		} else {
			
			// what is it?
			//if (_lastSelectedObject[$ _nameId].type == eAnimType.object) { _lastSelectedObject = _lastSelectedObject[$ _nameId].elements; } else
			//if (_lastSelectedObject[$ _nameId].type == eAnimType.sprite) { _lastSelectedObject = _lastSelectedObject[$ _nameId].animations; } else
			//{ _lastSelectedObject = _lastSelectedObject[$ _nameId].elements; };
			_lastSelectedObject = _lastSelectedObject[$ _nameId].elements;
		};
	};
	
	return -1;
};
/// @description returns the eAnim object Id, not the button id of the animation selected
animationSelectedGetId = function () {
	
	// do exists?
	if (!animationSelectedExists()) { return -1; };
	
	// last object selected
	var _lastSelectedObject = objectData;
	var _maxLength = array_length(animationSelected);
	// go inside the thing here
	for (var i = 0; i < _maxLength; i++) {
		// get the ID
		var _nameId = animationSelected[i];
		// is the last one?
		if (i == (_maxLength - 1)) {
			
			return _lastSelectedObject[$ _nameId].mySelf;
		} else {
			
			// what is it?
			_lastSelectedObject = _lastSelectedObject[$ _nameId].elements;
		};
	};
	
	return -1;
};
/// @description returns the eAnim object Id of the global animation, we get this by getting a constant of full or play values
animationSelectedGetGlobalParentId = function () {
	
	// do exists?
	if (!animationSelectedExists()) { return -1; };
	// and get it
	var _lastSelected = animationSelectedGetId();
	
	// scale up
	while (eAnimExists(_lastSelected.linkValueTo)) {
		// full or play
		if (((_lastSelected.linkType == eAnimLinkType.aFull) || (_lastSelected.linkType == eAnimLinkType.aPlay)) ||
			((_lastSelected.linkType == eAnimLinkType.aValue) && _lastSelected.linkValueTo.isPlaying)) {
			
			// change it
			_lastSelected = _lastSelected.linkValueTo;
			
		} else { break; };
	};
	
	return _lastSelected;
};
// adjust for object delete
objectDelete = function (_objectId, _deleteStruct = true) {
	
	// is this selected?
	if (objectSelectedGetId() == _objectId) { objectSelectedDeselect(); };
	
	// get object tree
	var _objectTree = objectGetTree(_objectId);
	// has it?
	if (array_length(_objectTree) > 1) {
		// type of element
		switch (_objectId.parent.type) {
			
			case eAnimType.object:
				// delete from parent
				_objectId.parent.elementDelete(_objectId.id);
			break;
			
			case eAnimType.sprite:
				// delete from parent
				_objectId.parent.animDelete(_objectId.id);
			break;
		};
	} else {
		// quit from three
		struct_remove(objectData, _objectId.id);
	};
	
	// quit out
	if (_deleteStruct) { delete _objectId; };
};



///@description Get all the parents of the object till reach the end, sends the path of how get to the object from the list
objectGetTree = function (_objectId) {
	
	// selected
	var _checkinObject = _objectId;
	var _selectedDepth = [ _objectId.id ];
	// while it has parent
	while (eAnimExists(_checkinObject.parent)) {
		// increase here
		array_push(_selectedDepth, _checkinObject.parent.id);
		// again
		_checkinObject = _checkinObject.parent;
	};
	
	// last one returned the object tree but the first was the last object, so lets inverse it up
	
	// set up it
	var _inverseDepth = [ ];
	// and select this
	for (var i = (array_length(_selectedDepth) - 1); i >= 0; i--) {
		// add it
		array_push(_inverseDepth, _selectedDepth[i]);
	};
	// set it up
	return _inverseDepth;
};
///@description  Select the mentioned object, works setting up the tree on the variable
objectSelect = function (_objectId) {
	
	// quit
	objectSelectedDeselect();
	// set it
	objectSelected = objectGetTree(_objectId);
	// is an animation?
	if (_objectId.type == eAnimType.animation) {
		
		// was selecting animation? stop the anim if playing
		if (animationSelectedExists()) {
			// get the global id
			var _animationId = animationSelectedGetId();
			// so, if its playing stop it
			if (_animationId.isPlaying) {
				// play that shit
				_animationId.animStop();
			};
		};
		
		
		animationSelected = objectGetTree(_objectId);
		// also selected animation
		show_debug_message("Anim Editor: SELECTED ANIMATION, DATA: " + string(animationSelected));
		// update
		updateNextFrame = true;//objectUpdateList();
	};
	
	// selected object
	show_debug_message("Anim Editor: SELECTED OBJECT, DATA: " + string(objectSelected));
};


objectUpdateSearch = function (_buttonIns) {
	
	var _elementsObtained = { buttons : { }, opened : _buttonIns.opened };
	
	var _totalButtons = array_length(_buttonIns.myButtons);
	
	// search it all
	for (var i = 0; i < _totalButtons; i++) {
		// get button ID
		var _buttonInside = _buttonIns.myButtons[i];
		// is curve?
		if (_buttonInside.animationType == eAnimType.objectChannelAnimation) { continue; };
		
		show_debug_message("LIST: Saving up Secondary button button (" + string(_buttonInside.animationOriginalObject.id) + ")");
		// For each button
		_elementsObtained.buttons[$ _buttonInside.animationId] = objectUpdateSearch(_buttonInside);
	};
	
	return _elementsObtained;
};

// update object
objectUpdateList = function () {
	
	// clear mouse clic
	
	var _savingUp = { };
	// ge the roignla
	var _selectedOb = objectSelectedGetId();
	// get a save through
	for (var i = 0; i < array_length(objectMainButtons); i++) {
		
		show_debug_message("LIST: Saving up Main button (" + string(i) + ")");
		
		_savingUp[$ objectMainButtons[i].animationId] = objectUpdateSearch(objectMainButtons[i]);
	};
	// delete each option
	for (var i = 0; i < array_length(objectMainButtons); i++) {
		// delete all options
		objectList.optionDelete(objectMainButtons[i].listOId);
		// updating step event
		show_debug_message("LIST: Updating List in Closing buttons");
		// update it
		objectList.stepEvent();
	};
	
	
	// reset it
	if (array_length(objectMainButtons) > 0) { array_delete(objectMainButtons, 0, array_length(objectMainButtons)); };
	
	// create all the options here
	var _dataNames = struct_get_names(objectData);
	for (var i = 0; i < array_length(_dataNames); i++) {
		// This is the real object in the world space, not an UI element
		var _elementId = objectData[$ _dataNames[i]];
		// create the option that holds the new object created
		var _optionCreated = objectList.optionAdd({
			internalOptionId : i,
			
			animationType : _elementId.type,
			originalObject : _elementId.mySelf });
		// save it up
		objectMainButtons = array_concat(objectMainButtons, _optionCreated);
		
		// updaet it
		objectList.stepEvent();
		// exists?
		if (struct_exists(_savingUp, _elementId.id)) {
			
			show_debug_message("LIST: Update Open button Id: " + string(_elementId.id));
			
			// get it here
			objectUpdateOpen(_optionCreated[0], _savingUp[$ _elementId.id], _selectedOb);
			// updaet it
			objectList.stepEvent();
			// show it
			show_debug_message("Found element button data: " + string(_elementId.id));
		};
	};
	// deselect
	//objectSelectedDeselect();
	objectSelectedExists();
	
	show_debug_message("Anim Editor: Updated object list, Finish");
};


objectUpdateOpen = function (_parentButtonIns, _structData, _selectedOb) {
	
	// was opened?
	if (_structData.opened || (_parentButtonIns.animationOriginalObject == _selectedOb)) {
		
		// update to get all the buttons it should have
		_parentButtonIns.stepUserEvent();
		// updaet it
		objectList.stepEvent();
		// open the button
		_parentButtonIns.callback();
		_parentButtonIns.isPressed = true;
		// updaet it
		objectList.stepEvent();
		
		show_debug_message("Opened button: " + string(_parentButtonIns.name));
		
		
		// loop for all of it
		for (var i = 0; i < array_length(_parentButtonIns.myButtons); i++) {
			var _childrenButtonId = _parentButtonIns.myButtons[i];
			// is a other
			if (_childrenButtonId.animationType == eAnimType.objectChannelAnimation) { continue; };
			// exists?
			if (struct_exists(_structData.buttons, _childrenButtonId.animationId)) {
				// get it here
				objectUpdateOpen(_childrenButtonId, _structData.buttons[$ _childrenButtonId.animationId], _selectedOb);
			};
			// updaet it
			objectList.stepEvent();
		};
	};
};

updateNextFrame = false;


objectSearchObjectType = function (_searchingType, _startingFrom = objectData) {
	
	var _returnArray = [ ];
	
	// start loop
	var _structNames = struct_get_names(_startingFrom);
	for (var i = 0; i < array_length(_structNames); i++) {
		// get the object id
		var _objectId = _startingFrom[$ _structNames[i]];
		
		// if what should be
		if ((_objectId.type == eAnimType.object) || (_objectId.type == eAnimType.sprite)) {
			
			var _theArray = objectSearchObjectType(_searchingType, _objectId.elements);
			// return it
			_returnArray = array_concat(_returnArray, _theArray);
			
			continue;
		} else if (_objectId.type == eAnimType.animation) {
			
			// push in
			array_push(_returnArray, [ _objectId, ob_animation_editor.objectGetTree(_objectId) ]);
			
			continue;
		};
		
	};
	
	return _returnArray;
};