

global._kuiDepth = 0;
global._kuiUsingButton = noone;
global._kuiBounds = [ 0, 0, 0, 0 ];

global.kuiActiveButtons = true;

// enumerate input types
enum KUI_INPUT_TYPE {
	
	stringType,
	floatType,
	integerType,
	hexType
};

// requires sc_extra_function and sc_file_handling
// note: elements on array, due to use depth? should i use structs? oh i know, two arrays, thats it

/// @param {real}  x		X vector
/// @param {real}  y		Y vector
/// @description Creates a vector2
function kuiVec2(xV, yV) constructor {
	// Set X
	x = xV;
	// Set Y
	y = yV;
	
	/// @param {struct}  _vec2  The vector2 to add
	/// @description Do the Add operation
	static add = function (_vec2) {
		// Add X
		x += _vec2.x;
		// Add Y
		y += _vec2.y;
	};
	/// @param {struct}  _vec2  The vector2 to substract
	/// @description Do the Substract operation
	static subtract = function (_vec2) {
		// Substract X
		x -= _vec2.x;
		// Substract Y
		y -= _vec2.y;
	};
	
	/// @param {struct}  _vec2  The vector2 to multiply with
	/// @description Do the Multiply operation
	static multitiply = function (_vec2) {
		// Multiply X
		x *= _vec2.x;
		// Multiply Y
		y *= _vec2.y;
	};
	/// @param {struct}  _vec2  The vector2 to divide with
	/// @description Do the Divide operation
	static divide = function (_vec2) {
		// Divide X
		x /= _vec2.x;
		// Divide Y
		y /= _vec2.y;
	};
};

/// @param {real}  sOffset	offset
/// @param {real}  sScale	scale
/// @description Creates a UI vector
function kuiUIVec(sOffset, sScale) constructor {
	// Set offset and scale
	offset = sOffset;
	scale = sScale;
	
	/// @param {struct}  _uiVec   The UI vector to add
	/// @description              Do the Add operation
	static add = function (_uiVec) {
		// Add offset and scale
		offset	 += _uiVec.offset;
		scale	 += _uiVec.scale;
	};
	/// @param {struct}  _uiVec   The UI vector to substract
	/// @description              Do the Substract operation
	static subtract = function (_uiVec) {
		// Subtract offset and scale
		offset	 -= _uiVec.offset;
		scale	 -= _uiVec.scale;
	};
	
	/// @param {struct}  _uiVec   The UI vector to multiply with
	/// @description              Do the Multiply operation
	static multitiply = function (_uiVec) {
		// Multiply offset and scale
		offset	 *= _uiVec2.offset;
		scale	 *= _uiVec2.scale;
	};
	/// @param {struct}  _uiVec   The UI vector to divide with
	/// @description              Do the Divide operation
	static divide = function (_uiVec) {
		// Divide offset and scale
		offset	 /= _uiVec2.offset;
		scale	 /= _uiVec2.scale;
	};
};

/// @param {real}  xOff		X offset
/// @param {real}  xSc		X scale
/// @param {real}  yOff		Y offset
/// @param {real}  ySc		Y scale
/// @description Creates a UI vector2
function kuiUIVec2(xOff, xSc, yOff, ySc) constructor {
	// Set X offset and scale
	x = new kuiUIVec(xOff, xSc);
	// Set Y offset and scale
	y = new kuiUIVec(yOff, ySc);
	
	/// @param {struct}  _uiVec2  The UI vector2 to add
	/// @description              Do the Add operation
	static add = function (_uiVec2) {
		// Add offset and scale in X
		x.add(_uiVec2.x);
		// Add offset and scale in Y
		y.add(_uiVec2.y);
	};
	/// @param {struct}  _uiVec2  The UI vector2 to substract
	/// @description              Do the Substract operation
	static subtract = function (_uiVec2) {
		// Substract offset and scale in X
		x.subtract(_uiVec2.x);
		// Substract offset and scale in Y
		y.subtract(_uiVec2.y);
	};
	
	/// @param {struct}  _uiVec2  The UI vector2 to multiply with
	/// @description              Do the Multiply operation
	static multitiply = function (_uiVec2) {
		// Multitiply offset and scale in X
		x.multitiply(_uiVec2.x);
		// Multitiply offset and scale in Y
		y.multitiply(_uiVec2.y);
	};
	/// @param {struct}  _uiVec2  The UI vector2 to divide with
	/// @description              Do the Divide operation
	static divide = function (_uiVec2) {
		// Divide offset and scale in X
		x.divide(_uiVec2.x);
		// Divide offset and scale in Y
		y.divide(_uiVec2.y);
	};
};

function kuiArrayGetNames(_arr) {
	var _names = [];
	// loop for all
	for (var i = 0; i < array_length(_arr); i++) {
		// return
		_names[i] = _arr[i].name;
	};
	
	// so return it
	return _names;
};

/// @description Active bounds shader or update it
function kuiSetBoundsShader() {

// Shader being used
var currentShader = shader_current();
// Is not self shader
if (currentShader != sh_clip) {
	// If using some shader
	if (currentShader != -1) { shader_reset(); };
	// Set clip shader
	shader_set(sh_clip);
};
// Get bounds uniform
var u_bounds = shader_get_uniform(sh_clip, "u_bounds");


// Set bounds limit
shader_set_uniform_f(u_bounds, global._kuiBounds[0], global._kuiBounds[1], global._kuiBounds[2], global._kuiBounds[3]);

};
/// @description Ends bound shader work
function kuiResetBoundsShader() {

// Shader being used
var currentShader = shader_current();
// Is not self shader
if (currentShader == sh_clip) { shader_reset(); };

};

/// @description deafult callback
function kuiDCall() { return; };

/// @description If the mentioned element is indeed an element
function kuiExists(_kuiElement) { return is_struct(_kuiElement) && !structRead(_kuiElement, "destroyed", false); };

/// @description The main handler of UI elements
function kuiCore(_name, _posUIVec2, _sizeUIVec2, _callbackF = kuiDCall) constructor {
	//show_debug_message("UI ELEMENT CREATED (" + string(currentFrame() / 60) + "s)")
	// has that
	if (debugVGetValue("showUICreation", false)) { show_debug_message("UI ELEMENT CREATED (" + string(currentFrame() / 60) + "s)"); };
	
	// the sprite
	mainSprite = -1;
	// call my self struct
	mySelf = self;//method_get_self(self);
	parent = noone;
	globalParent = noone;
	// to flag it in
	destroyed = false;
	
	// Mouse is inside button
	mouseInside = false;
	inheritParentDepth = true;
	parentDepthOffset = 0;
	// needs one?
	requieriesCursor = -1;
	childrenCursorInside = false;
	
	
	// the core has this strange looking thing
	x = _posUIVec2.x.offset;
	y = _posUIVec2.y.offset;
	// the name
	name = _name;
	
	
	// if hide or inside handler
	hide = false;
	activeUI = true;
	insideHandler = true;
	
	drawOutAll = false;
	
	wasInZone = false;
	wasUseable = false;
	
	// the depth of this
	uiDepth = global._kuiDepth;
	
	// Anchor position
	anchorPosition = new kuiVec2(0, 0);
	
	// yeah, this
	width = _sizeUIVec2.x.offset;
	height = _sizeUIVec2.y.offset;
	
	// the complete understading of this
	size = _sizeUIVec2;
	position = _posUIVec2;
	// for offsets
	uiBorderOff = 0;
	uiDrawBorderOff = 0;
	
	
	
	
	// and here pick up the elements
	elements = {};
	// this will save the elements and set it a draw order
	elementsDrawOrder = [];
	
	
	static uiActive = function () { activeUI = true; };
	
	static uiDeactive = function () { activeUI = false; };
	
	// get element
	static elementGet = function (elementName) { return struct_get(elements, elementName); };
	// get draw order
	static elementGetDrawOrder = function (elementName) { return arrayFind(elementsDrawOrder, elementName); };
	
	// adjust the draw event here
	onAddEvent = function () { };
	onAddUserEvent = function () { };
	
	static userSetOnAddEvent = function (_newFunction) {
		// set up this
		onAddUserEvent = method(mySelf, _newFunction);
	};
	
	// add elements
	static elementAdd = function (elementIns) {
		
		// adad all the elements
		for (var i = 0; i < argument_count; i++) {
			
			var _elementIns = argument[i];
			
			// set up
			if (_elementIns.inheritParentDepth) { _elementIns.uiDepth = uiDepth + _elementIns.parentDepthOffset; };
			// add to struct
			struct_set(elements, _elementIns.name, _elementIns);
			// and to draw order
			array_push(elementsDrawOrder, _elementIns.name);
			// set parent
			_elementIns.parent = mySelf;
			
			// set this up
			_elementIns.onAddEvent();
			_elementIns.onAddUserEvent();
		};
		
		// update UI
		updateUI();
	};
	// delete
	static elementDelete = function (elementName) {
		
		// quit parenting
		elements[$ elementName].parent = noone;
		
		var _drawOrderIndex = arrayFind(elementsDrawOrder, elementName);
		// remove from array
		if (_drawOrderIndex >= 0) { array_delete(elementsDrawOrder, _drawOrderIndex, 1); };
		// quit out
		struct_remove(elements, elementName);
		
		// update UI
		updateUI();
	};
	
	static elementLoop = function (_loopFunction) {
		// grab all elements
		var _elementList = struct_get_names(elements);
		for (var i = 0; i < array_length(_elementList); i++) {
			// set up this
			_loopFunction(elements[$ _elementList[i]]);
		};
	};
	
	static selfDestroy = function () {
		
		// do this
		destroyEvent();
		// set up the uswer event
		destroyUserEvent();
		
		// destry elelents
		elementLoop(function (_elementIns) { show_debug_message("Destroying Children First"); _elementIns.selfDestroy(); });
		// has parent?
		if (hasParent()) {
			// dleete it
			parent.elementDelete(name);
		};
		// active this
		destroyed = true;
		// delete myself
		if (is_struct(mySelf)) { delete mySelf; };
		
		// has that
		if (debugVGetValue("showUICreation", false)) { show_debug_message("UI ELEMENT DELETED (" + string(currentFrame() / 60) + "s)"); };
		exit;
	};
	
	// custom destroy event
	destroyEvent = function () { };
	destroyUserEvent = function () { };
	
	static userSetDestroyEvent = function (_newFunction) {
		// set up this
		destroyUserEvent = method(mySelf, _newFunction);
	};
	
	
	static hasParent = function () { return kuiExists(parent); };
	
	// to set bounds
	static setBounds = function (_offset = 0) {
		
		// Has parent
		if (hasParent()) {
			
			// Top left borders
			global._kuiBounds[0] = max(global._kuiBounds[0], x + _offset);
			global._kuiBounds[1] = max(global._kuiBounds[1], y + _offset);
			// Limit on top borders
			global._kuiBounds[2] = min(global._kuiBounds[2], (x + width) - _offset);
			global._kuiBounds[3] = min(global._kuiBounds[3], (y + height) - _offset);
		} else {
			// Top left borders
			global._kuiBounds[0] = x;
			global._kuiBounds[1] = y;
			// Limit on top borders
			global._kuiBounds[2] = x + width;
			global._kuiBounds[3] = y + height;
		};
	};
	static resetBoundsOffset = function (_offset) {
		
		// Top left borders
		global._kuiBounds[0] = global._kuiBounds[0] - _offset;
		global._kuiBounds[1] = global._kuiBounds[1] - _offset;
		// Limit on top borders
		global._kuiBounds[2] = global._kuiBounds[2] + _offset;
		global._kuiBounds[3] = global._kuiBounds[3] + _offset;
	};
	
	static setPosition = function (_uiVec2) {
		// set up position
		position = _uiVec2;
		
		updateUI();
	};
	
	static setSize = function (_uiVec2) {
		// set up size
		size = _uiVec2;
		
		updateUI();
	};
	
	// end in case of emergency
	useEnd = function () { };
	// in case of use
	static useStart = function () {
		// set up this
		if (kuiExists(global._kuiUsingButton) && (global._kuiUsingButton != mySelf)) {
			// end up that
			global._kuiUsingButton.useEnd();
			global._kuiUsingButton = noone;
		};
	};
	
	static useableElement = function () {
		// If can use the element instance
		//return ((global._kuiUsingButton == noone) || (global._kuiUsingButton == id)) && global.kuiActiveButtons && (global._kuiDepth == uiDepth);
		return global.kuiActiveButtons && (!hide) && (global._kuiDepth == uiDepth) && (!kuiExists(global._kuiUsingButton) || (global._kuiUsingButton == mySelf));
	};
	
	// adjust the draw event here
	drawEvent = function () { };
	drawUserEvent = function () { };
	
	static userSetDrawEvent = function (_newFunction) {
		// set up this
		drawUserEvent = method(mySelf, _newFunction);
	};
	
	static drawCall = function () {
		// set bounds now
		if (insideHandler) { setBounds(0); };
		// set bounds
		if (drawOutAll) { global._kuiBounds = [ -1, -1, display_get_gui_width() + 1, display_get_gui_height() + 1 ]; }
		// update bounds shader
		kuiSetBoundsShader();
		
		// Do the draw evet
		drawEvent();
		drawUserEvent();
		
		// reset bounds shader
		kuiResetBoundsShader();
		
		// set bounds now
		if (insideHandler) { setBounds(uiDrawBorderOff); };
		// Save up bounds here
		var _bounds;
		_bounds = arrayDuplicate(global._kuiBounds);
		
		// and loop for each one of my elements
		for (var i = 0; i < array_length(elementsDrawOrder); i++) {
			var _elementIns = elements[$ elementsDrawOrder[i]];
			
			// is hidding
			if (_elementIns.hide || (!_elementIns.activeUI)) { continue; };
			
			var _drawOutAll = _elementIns.drawOutAll;
			
			// update bounds shader
			global._kuiBounds = arrayDuplicate(_bounds);
			kuiSetBoundsShader();
			
			// not hiding
			if ((!_elementIns.hide) && _elementIns.activeUI) {
				
				// set it draw call
				_elementIns.drawCall();
			};
			// 
			
			// reset bounds shader
			kuiResetBoundsShader();
		};
	};
	
	// adjust the draw event here
	stepEvent = function () { };
	stepUserEvent = function () { };
	
	static userSetStepEvent = function (_newFunction) {
		// set up this
		stepUserEvent = method(mySelf, _newFunction);
	};
	
	static stepCall = function () {
		
		// Boot up
		childrenCursorInside = false;
		
		var _bSave = [];
		// set bounds now
		if (insideHandler) {
			setBounds(0);
			// save it
			_bSave = arrayDuplicate(global._kuiBounds);
		};
		// set bounds
		if (drawOutAll) { global._kuiBounds = [ -1, -1, display_get_gui_width() + 1, display_get_gui_height() + 1 ]; }
		
		// setup
		mouseInside = mouseInGUI(x, y, x + width, y + height);
		requieriesCursor = -1;
		// update this
		wasInZone = inZone();
		wasUseable = useableElement();
		
		// update this
		stepEvent();
		stepUserEvent();//*/
		
		
		// set bounds now
		if (insideHandler) { setBounds(uiDrawBorderOff); };
		// Save up bounds here
		_tempStepBounds = arrayDuplicate(global._kuiBounds);
		
		// loop elements
		elementLoop(function (_elementIns) {
			
			// do the step too
			if (kuiExists(_elementIns)) {
				// set up the
				_elementIns.globalParent = globalParent;
				// Is active?
				if (_elementIns.activeUI) {
					// update bounds shader
					global._kuiBounds = arrayDuplicate(_tempStepBounds);
					
					_elementIns.stepCall();
					// Update children
					childrenCursorInside = _elementIns.mouseInside || childrenCursorInside;
				};
			};
		});
		
		//delete _tempStepBounds;
		
		// get bounds now
		/*if (insideHandler) {
			// recover it
			global._kuiBounds = arrayDuplicate(_bSave);
		};
		// set bounds
		if (drawOutAll) { global._kuiBounds = [ -1, -1, display_get_gui_width() + 1, display_get_gui_height() + 1 ]; }
		
		
		// update this
		stepEvent();
		stepUserEvent();//*/
		
		// set moise inside
		mouseInside = mouseInside || childrenCursorInside;
		
		// has parent
		if (hasParent()) {
			// set up cursor
			if (requieriesCursor != -1) { parent.requieriesCursor = requieriesCursor; };
		} else {
			// now does?
			if (requieriesCursor != -1) {
				// set it up
				window_set_cursor(requieriesCursor);
			} else {
				// set it to default
				window_set_cursor(cr_default);
			};
		};
	};
	
	
	/// @description To update inside elements
	updateUIElements = function () {
		
		// Update elements
		elementLoop(function (_elementIns) {
			// update this too
			_elementIns.updateUI();
		});
	};
	
	// for update IU values
	static updateUI = function () {
		
		// Has cusstom?
		if (updateUICustomActive) {
			
			// Set up custom UI event
			updateUICustom();
			
		} else {
			// Has parent
			if (hasParent()) {
				
				//show_debug_message("updating with parent: " + string(name) + ", parent: " + string(parent.name));
				// Update X and Y scale
				width	 = ((parent.width - (uiBorderOff * 2)) * size.x.scale) + (size.x.offset);
				height	 = ((parent.height - (uiBorderOff * 2)) * size.y.scale) + (size.y.offset);
				// Update X and Y position
				x		 = parent.x + uiBorderOff + ((parent.width - (uiBorderOff * 2))	 * position.x.scale) + position.x.offset;
				y		 = parent.y + uiBorderOff + ((parent.height - (uiBorderOff * 2)) * position.y.scale) + position.y.offset;
				// Add anchor position
				x		 -= (width * anchorPosition.x);
				y		 -= (height * anchorPosition.y);
				
			} else {
				//show_debug_message("updating without parent: " + string(name));
				// Update X and Y scale
				width	 = size.x.offset;
				height	 = size.y.offset;
				// Update X and Y position
				x		 = position.x.offset - (width * anchorPosition.x);
				y		 = position.y.offset - (height * anchorPosition.y);
			};
			// event
			updateUIEvent();
			// to update elments
			updateUIElements();
			
			// update after elements adjust
			updateUIPostElementsEvent();
		};
	};
	// in parent zone
	static inZone = function () {
		
		return mouseInGUI(global._kuiBounds[0], global._kuiBounds[1], global._kuiBounds[2], global._kuiBounds[3]);
		
		// If it's in zone
		if (hasParent()) {
			//show_debug_message("poraent szone checkout " + string(name))
			// If it's in zone 
			/*return	 ((windowGetMouseX() >= parent.x) && (windowGetMouseX() < (parent.x + parent.width))) &&
					 ((windowGetMouseY() >= parent.y) && (windowGetMouseY() < (parent.y + parent.height)));//*/
			return script_execute_ext(mouseInGUI, global._kuiBounds);
		};
		
		return true;
	};
	
	static depthIncrease = function () { uiDepth--; global._kuiDepth--; };
	static depthDecrease = function () { uiDepth++; global._kuiDepth++; };
	
	
	updateUIPostElementsEvent = function () { };
	updateUIEvent = function () { };
	
	updateUICustom = function () { };
	updateUICustomActive = false;
	// this works for 
	callback = method(mySelf, _callbackF);
	// and to set the callback function
	static callbackSet = function (_newFunction) { callback = method(mySelf, _newFunction); };
};

/// @description Keep organized on a convenient tab
function kuiWindow(_name, _posUIVec2, _sizeUIVec2) : kuiCore(_name, _posUIVec2, _sizeUIVec2) constructor {
	
	mainSprite = sp_kui_window;
	uiDrawBorderOff = 1;
	
	// set up this
	drawEvent = method(mySelf, function () {
		
		// draw it here
		draw_sprite_stretched(mainSprite, 0, x, y, width, height);
	});
};

function kuiInternalTab(_name, _posUIVec2, _sizeUIVec2) : kuiWindow(_name, _posUIVec2, _sizeUIVec2) constructor {
	
	mainSprite = sp_kui_internal_tab;
};

function kuiWindowInternal(_name, _posUIVec2, _sizeUIVec2) : kuiWindow(_name, _posUIVec2, _sizeUIVec2) constructor {
	
	mainSprite = sp_kui_slider_bg;
};

/// @description Image entity
function kuiImage(_name, _imageId, _imageIndex, _posUIVec2, _sizeUIVec2, _callbackF = kuiDCall) : kuiCore(_name, _posUIVec2, _sizeUIVec2, _callbackF) constructor {
	
	imageId		 = _imageId;
	imageIndex	 = _imageIndex;
	
	static setImageIndex = function (_newImgIndex) { imageIndex = _newImgIndex; };
	
	// set up this
	drawEvent = method(mySelf, function () {
		
		// Get sprite variables
		var spriteSize, spriteWidth, spriteHeight;
		spriteWidth = sprite_get_width(imageId);
		spriteHeight = sprite_get_height(imageId);
		
		// If width is bigger than height
		if (spriteWidth > spriteHeight) {
			
			// Get width to preview width
			spriteSize = width / spriteWidth;
			// But height is more than rectnagle
			if ((spriteHeight * spriteSize) > height) { spriteSize = height / spriteHeight; };
			
		} else { // Height is bigger or same size
			
			// Get height to preview height
			spriteSize = height / spriteHeight;
			// But width is more than rectnagle
			if ((spriteWidth * spriteSize) > width) { spriteSize = width / spriteWidth; };
		};
		
		var _finalWidth, _finalHeight;
		_finalWidth		 = spriteWidth * spriteSize;
		_finalHeight	 = spriteHeight * spriteSize;
		
		// Draw sprite
		draw_sprite_stretched(imageId, imageIndex, (x + (width/2)) - (_finalWidth / 2), (y + (height/2)) - (_finalHeight / 2), _finalWidth, _finalHeight);
	});
};


/// @description A normal button
function kuiButton(_name, _posUIVec2, _sizeUIVec2, _callbackF = kuiDCall) : kuiCore(_name, _posUIVec2, _sizeUIVec2, _callbackF) constructor {
	
	// Pressing animation
	pressedTimerMax = 5;
	pressedTimer = 0;
	// Button phase
	phase = 0;
	
	mainSprite = sp_kui_button;
	
	// Step event of the button
	stepEvent = method(mySelf, function() {
		
		// Reduce timer
		if (pressedTimer > 0) { pressedTimer -= 1; };
		// Play do a clic on it
		if (mouseInside && useableElement() && inZone()) {
			requieriesCursor = cr_handpoint;
			
			// active it
			if (mouse_check_button_pressed(mb_left)) {
				// Do the callback function
				callback();
				// Update pressed timer
				pressedTimer = pressedTimerMax;
				exit;
			};
		};
	});
	
	// set up this
	drawEvent = method(mySelf, function () {
		
		// Draw the button
		draw_sprite_stretched(mainSprite, max(mouseInside * useableElement() * inZone(), (pressedTimer > 0) * 2), x, y, width, height);
	});
};

function kuiButtonSkinList(_name, _posUIVec2, _sizeUIVec2, _callbackF = kuiDCall) : kuiButton(_name, _posUIVec2, _sizeUIVec2, _callbackF) constructor {
	
	mainSprite = sp_kui_list;
};

/// @description A checker button
function kuiCheckerButton(_name, _posUIVec2, _sizeUIVec2, _callbackF = kuiDCall, _unpressCallbackF = kuiDCall, _pressCondition = function () { return false; }) : kuiCore(_name, _posUIVec2, _sizeUIVec2, _callbackF) constructor {
	
	mainSprite = sp_kui_button;
	// Pressing animation
	isPressed = false;

	// Mouse is inside button
	mouseInside = false;
	// Button phase
	phase = 0;

	// If player can unpress it
	canBeUnpressedByPlayer = true;

	// To has pressed sprite condition
	pressCondition = method(mySelf, _pressCondition);

	unpressCallback = method(mySelf, _unpressCallbackF);
	
	
	static setCanBeUnpressed = function (_canBe) { canBeUnpressedByPlayer = _canBe; };
	
	static setPressCondition = function (_newFunction) { pressCondition = method(mySelf, _newFunction); };
	
	static setUnpressCallback = function (_newFunction) { unpressCallback = method(mySelf, _newFunction); };
	// Step event of the button
	stepEvent = method(mySelf, function() {
		
		// Pressed condition
		isPressed = pressCondition();
		
		// Play do a clic on it
		if (mouseInside  && useableElement() && inZone()) {
			requieriesCursor = cr_handpoint;
			
			// active it
			if (mouse_check_button_pressed(mb_left)) {
				// is pressed or not
				if (isPressed) {
					
					// if can be unpressed
					if (canBeUnpressedByPlayer) {
					
						// Not pressed anymore
						isPressed = false;
						// Alternative callback function
						unpressCallback();
					};
				} else {
					
					// Do the callback function
					callback();
					// Now it's pressed
					isPressed = true;
					exit;
				};
			};
		};
	});
	
	// set up this
	drawEvent = method(mySelf, function () {
		
		// Draw the button
		draw_sprite_stretched(mainSprite, max(mouseInside * useableElement() * inZone(), (isPressed) * 2), x, y, width, height);
	});
};


/// @description A normal button
function kuiInput(_name, _posUIVec2, _sizeUIVec2, _helpText = "", _initText = "", _characterLimit = 50, _multiLine = false, _inputType = KUI_INPUT_TYPE.stringType, _callbackF = kuiDCall, _hAlign = fa_center, _vAlign = fa_middle, _noInputControl = function () { }) : kuiCore(_name, _posUIVec2, _sizeUIVec2, _callbackF) constructor {
	
	mainSprite = sp_kui_input;
	// Pressing animation
	pressedTimerMax = 5;
	pressedTimer = 0;
	uiDrawBorderOff = 1;
	
	// Mouse is inside button
	mouseInside = false;
	// Button phase
	writingIn = false;
	// Text inside
	textIn = _initText;
	storedNumber = 0;
	isCompatibleText = false;
	// Help text
	helpText = _helpText;
	
	// No multiline
	multiLine = _multiLine;
	// checkout
	floatPrecision = 3;
	
	// Character limit
	characterLimit = _characterLimit;
	// Input type
	inputType = _inputType;
	// set up
	switch (inputType) {
		
		case KUI_INPUT_TYPE.floatType: case KUI_INPUT_TYPE.integerType: if (textIn != "") { storedNumber = real(textIn); } else { storedNumber = 0; }; break;
	};
	
	textUI = new kuiText("textUI", new kuiUIVec2(2, 0, 1, 0), new kuiUIVec2(-4, 1, -2, 1), textIn, c_black, _hAlign, _vAlign, 1, fo_ui);
	
	noInputControl = method(mySelf, _noInputControl);
	// Add to text
	elementAdd(textUI);
	
	
	// taht
	checkoutUserEvent = function () { return true; };
	
	/// @description function(stringInput) -> true/false
	static userSetCheckout = function(_newFunction) { checkoutUserEvent = method(mySelf, _newFunction); };
	
	static setFloatPrecision = function(_newPrecision = 3) { floatPrecision = _newPrecision; };
	
	static setStoredNumber = function (_storedNumber = 0) { storedNumber = _storedNumber; textIn = string(storedNumber); };
	
	static setMultiLine = function (_multiLine = false) { multiLine = _multiLine; };
	
	static getText = function () { return textIn; };
	
	static setNoInputControl = function (_newFunc) { noInputControl = method(mySelf, _newFunc) };
	
	static getInputType = function () { return inputType; };
	
	// Step event of the button
	stepEvent = method(mySelf, function() {
		
		// Is not writing in
		if (!writingIn) {
			
			noInputControl();
			// Compatible text
			isCompatibleText = true;
			
			// is flkoat]
			if (inputType == KUI_INPUT_TYPE.floatType)
				{ textIn = stringFormatDecimal(storedNumber, floatPrecision); };
			
			// Player do a clic on it
			if (mouseInside && useableElement() && inZone()) {
				requieriesCursor = cr_handpoint;
				if (mouse_check_button_pressed(mb_left)) {
					// Set keyboard text
					keyboard_string = textIn;
					// is flkoat]
					if (inputType == KUI_INPUT_TYPE.floatType) 
						//{ keyboard_string = string_format(storedNumber, string_length(string(floor(abs(storedNumber)))), floatPrecision); };
						{ keyboard_string = stringFormatDecimal(storedNumber, floatPrecision); };
					// Now writing in
					writingIn = true;
					// Set usign button
					global._kuiUsingButton = mySelf;
				};
			};
		} else {
			// If reached max
			if (string_length(keyboard_string) > characterLimit) { keyboard_string = string_copy(keyboard_string, 1, characterLimit); };
		
			// Has multiline
			if (multiLine) {
				// Set font
				draw_set_font(textUI.textFont);
				// Multiline
				if (string_width(keyboard_string) >= (width - 2)) {
				
					// Get last thingy
					var lastShit = string_char_at(keyboard_string, string_length(keyboard_string));
					// Add this thing
					var newString = string_copy(keyboard_string, 1, string_length(keyboard_string) - 1);
					// Add one line
					keyboard_string = newString + "\n" + lastShit;
				};
			};
			
			// Compatible text
			isCompatibleText = true;
			// Input type
			switch (inputType) {
				
				case KUI_INPUT_TYPE.floatType:
					
					// If isn't number
					if (!isReal(keyboard_string)) {
						// Not compatiable
						isCompatibleText = false;
					};
				break;
				
				case KUI_INPUT_TYPE.integerType:
					
					// If isn't number
					if (!isReal(keyboard_string)) {
						// Not compatiable
						isCompatibleText = false;
						
					// Is a float number
					} else if (round(real(keyboard_string)) != real(keyboard_string)) {
						
						// Not compatiable
						isCompatibleText = false;
					};
				break;
			};
			// compatible for last time
			if (isCompatibleText) { isCompatibleText = checkoutUserEvent(keyboard_string); };
			
			
			// Enter or clic outside
			if (keyboard_check_pressed(vk_enter) || (mouse_check_button_pressed(mb_left) && !mouseInside)) {
				
				// It's compatible
				if (isCompatibleText) {
					// set up
					switch (inputType) {
						
						case KUI_INPUT_TYPE.floatType: case KUI_INPUT_TYPE.integerType: storedNumber = real(keyboard_string); break;
					};
					// Viseversa
					textIn = keyboard_string;
					// Do the callback function
					callback();
				};
				// Now writing anymore
				writingIn = false;
				// Reset using button
				global._kuiUsingButton = noone;
			};
		};
	});
	
	// set up this
	drawEvent = method(mySelf, function () {
		
		// Draw the button
		draw_sprite_stretched(mainSprite, 0, x, y, width, height);
		// Set font
		draw_set_font(textUI.textFont);
		
		var toDrawText = "", isHelpText = false, extraString = " ";
		// Is not writing in
		if (!writingIn) {
			
			// Thert is text
			if (textIn != "") {
				// Text to draw is inside text
				toDrawText = textIn;
			} else {
				// Text to draw is help text
				toDrawText = helpText;
				isHelpText = true;
			};
		} else {
			
			// Keyboard shit
			toDrawText = keyboard_string;
			// set extra string
			if (floor(currentFrame() / 10) mod 2) { extraString = "|"; };
		};
		// If it's help text
		if (isHelpText) { textUI.textAlpha = 0.5; } else { textUI.textAlpha = 1; };
		// is compatible?
		if (isCompatibleText) { textUI.textColor = c_black; } else { textUI.textColor = c_red; };
		
		// set it max width
		var _textMaxWidth = string_width(toDrawText + "|");
		var _textX = min(0, (width - 4) - _textMaxWidth);
		
		textUI.setPosition(new kuiUIVec2(2 + _textX, 0, textUI.position.y.offset, textUI.position.y.scale));
		textUI.setSize(new kuiUIVec2(max(width - 4, _textMaxWidth), 0, textUI.size.y.offset, textUI.size.y.scale));
		
		// To draw text
		textUI.textContent = toDrawText + extraString;
	});
	
	static setText = function (stringText) {
		// Set the input text
		textIn = stringText;
	};
	
	static getText = function () {
		// Return my text
		return textIn;
	};
};


/// @description This window bottom
function kuiText(_name, _posUIVec2, _sizeUIVec2, _textContent,
				_color = c_black, _hAlign = fa_left, _vAlign = fa_top, _alpha = 1, _font = fo_ui) : kuiCore(_name, _posUIVec2, _sizeUIVec2) constructor {
	
	// Text ajustments
	textContent	 = _textContent;
	textColor	 = _color;
	textFont	 = _font;
	
	textAlpha = _alpha;
	
	textHAlign = _hAlign;
	textVAlign = _vAlign;
	
	static setText		 = function (_newContent) { textContent = _newContent; };
	static getText		 = function () { return textContent; };
	
	static setColor		 = function (_newColor) { textColor = _newColor; };
	
	static setHAlign	 = function (_newHAlign) { textHAlign = _newHAlign; };
	static setVAlign	 = function (_newVAlign) { textHAlign = _newVAlign; };
	
	static setAlpha		 = function (_newAlpha) { textAlpha = _newAlpha; };
	
	static setFont		 = function (_newFont) { textFont = _newFont; };
	
	// set up this
	drawEvent = method(mySelf, function () {
		
		var textX, textY;
		// X position
		switch (textHAlign) {
			// On left position
			case fa_left:		 textX = x; break;
			// In middle position
			case fa_center: case fa_middle:		 textX = x + (width / 2); break;
			// Total right position
			case fa_right:		 textX = x + width; break;
		};
		// Y position
		switch (textVAlign) {
			// On top position
			case fa_top:		 textY = y; break;
			// In middle position
			case fa_middle: case fa_center:		 textY = y + (height / 2); break;
			// On bottom position
			case fa_bottom:		 textY = y + height; break;
		};
		
		// Set color and font
		draw_set_color(textColor);
		draw_set_font(textFont);
		// Set align
		draw_set_halign(textHAlign);
		draw_set_valign(textVAlign);
		// Set alpha
		draw_set_alpha(textAlpha);
		// Draw text
		drawTextSpecial(textX, textY, textContent, false);
		// Reset this text
		drawReset();
	});
};

/// @description This window bottom
function kuiInputText(_name, _posUIVec2, _sizeUIVec2, _backText = "", _backTextWidth = 0, _helpText = "", _initText = "", _characterLimit = 50, _multiLine = false, _inputType = KUI_INPUT_TYPE.stringType, _callbackF = kuiDCall, _hAlign = fa_center, _vAlign = fa_middle, _noInputControl = function () { }, _backColor = c_black, _backHAlign = fa_left, _backVAlign = fa_middle) : kuiInput(_name, _posUIVec2, _sizeUIVec2, _helpText, _initText, _characterLimit, _multiLine, _inputType, _callbackF, _hAlign, _vAlign, _noInputControl) constructor {
	
	// added th
	backTextUI = new kuiText("backTextUI" + _name,
		new kuiUIVec2(_posUIVec2.x.offset, _posUIVec2.x.scale, _posUIVec2.y.offset, _posUIVec2.y.scale),
		new kuiUIVec2(_backTextWidth, 0, _sizeUIVec2.y.offset, _sizeUIVec2.y.scale),
		_backText, _backColor, _backHAlign, _backVAlign);//_backTextWidth
	// adjust this on
	backTextUI._ocButton = mySelf;
	backTextUI.userSetStepEvent(function () { hide = _ocButton.hide; });
	
	// adjust X
	position.x.offset += _backTextWidth;
	
	// modify
	onAddEvent = method(mySelf, function () {
		// add to it
		parent.elementAdd(backTextUI);
	});
};

/// @description Common button with simple text inside
function kuiButtonText(_name, _posUIVec2, _sizeUIVec2, _textContent, _callbackF = kuiDCall,
				_hAlign = fa_center, _vAlign = fa_middle, _color = c_black, _alpha = 1, _font = fo_ui) : kuiButton(_name, _posUIVec2, _sizeUIVec2, _callbackF) constructor {
	
	// Add text inside
	var _textUI = new kuiText("textUI", new kuiUIVec2(0, 0, 0, 0), new kuiUIVec2(0, 1, 0, 1), _textContent, _color, _hAlign, _vAlign, _alpha, _font);
	// Add to myself
	elementAdd(_textUI);
};

/// @description Common button with an image inside
function kuiButtonImage(_name, _posUIVec2, _sizeUIVec2, _imageId, _imageIndex, _callbackF = kuiDCall) : kuiButton(_name, _posUIVec2, _sizeUIVec2, _callbackF) constructor {
	
	// Add image inside
	var _imageUI = new kuiImage("imageUI", _imageId, _imageIndex, new kuiUIVec2(3, 0, 3, 0), new kuiUIVec2(-6, 1, -6, 1));
	// Add to myself
	elementAdd(_imageUI);
};

/// @description Common button with simple text inside
function kuiCheckerButtonText(_name, _posUIVec2, _sizeUIVec2, _textContent, _callbackF = kuiDCall, _unpressCallbackF = kuiDCall, _pressCondition = function () { return false; },
				_hAlign = fa_center, _vAlign = fa_middle, _color = c_black, _alpha = 1, _font = fo_ui) : kuiCheckerButton(_name, _posUIVec2, _sizeUIVec2, _callbackF, _unpressCallbackF, _pressCondition) constructor {
	
	// Add text inside
	var _textUI = new kuiText("textUI", new kuiUIVec2(0, 0, 0, 0), new kuiUIVec2(0, 1, 0, 1), _textContent, _color, _hAlign, _vAlign, _alpha, _font);
	// Add to myself
	elementAdd(_textUI);
};

/// @description Common button with an image inside
function kuiCheckerButtonImage(_name, _posUIVec2, _sizeUIVec2, _imageId, _imageIndex, _callbackF = kuiDCall, _unpressCallbackF = kuiDCall, _pressCondition = function () { return false; }) : kuiCheckerButton(_name, _posUIVec2, _sizeUIVec2, _callbackF, _unpressCallbackF, _pressCondition) constructor {
	
	// Add image inside
	var _imageUI = new kuiImage("imageUI", _imageId, _imageIndex, new kuiUIVec2(3, 0, 3, 0), new kuiUIVec2(-6, 1, -6, 1));
	// Add to myself
	elementAdd(_imageUI);
};

/// @description Sections should be only names (rather tho, you can change it by yourself)
function kuiSectionWindow(_name, _posUIVec2, _sizeUIVec2, _sections = [ ], _callbackF = kuiDCall) : kuiCore(_name, _posUIVec2, _sizeUIVec2, _callbackF) constructor {
	
	sectionButtonHeight = 15;
	
	// grab here all the sections core
	sectionsCore = [ ];
	sectionOffX = 0;
	sectionSelected = 0;
	
	// Add the main window here
	var _mWindow = new kuiWindow("window", new kuiUIVec2(0, 0, sectionButtonHeight, 0), new kuiUIVec2(0, 1, -sectionButtonHeight, 1));
	elementAdd(_mWindow);
	
	static sectionUpdate = function () {
		
		// Loop through each section
		for (var i = 0; i < array_length(sectionsCore); i++) {
			// get the core and the button
			var _nCore = elements[$ "sectionCore" + string(i)];
			var _nButton = elements[$ "sectionButton" + string(i)];
			
			// is selected?
			_nCore.activeUI = (sectionSelected == i);
			// same with button
			_nButton.mainSprite = (sectionSelected == i) ? sp_kui_section : sp_kui_section_selected;
		};
	};
	
	static sectionGetCore = function(_sectionId) {
		
		return sectionsCore[_sectionId];
	};
	
	static sectionAdd = function (_sectionsToAdd) {
		// setup
		draw_set_font(fo_ui);
		// loop
		for (var i = 0; i < argument_count; i++) {
			// get the section new id
			var _newSectionId = argument[i];
			var _sectionId = array_length(sectionsCore);
			
			// text size
			var _sectionTextW = string_width(_newSectionId) + 10;
			
			// get new width
			var _newWidth = sectionOffX + 3 + _sectionTextW + 3;
			if (_newWidth > width) { setSize(new kuiUIVec2(_newWidth, 0, size.y.offset, size.y.scale)); };
			// create a new button
			var _nButton = new kuiButtonText("sectionButton" + string(_sectionId),
											new kuiUIVec2(3 + sectionOffX, 0, 0, 0), new kuiUIVec2(_sectionTextW, 0, sectionButtonHeight + 2, 0), _newSectionId, function () {
				
				// set it up
				parent.sectionSelected = mySectionId;
				parent.sectionUpdate();
			});
			_nButton.mySectionId = _sectionId;
			// create a new core
			var _nCore = new kuiCore("sectionCore" + string(_sectionId), new kuiUIVec2(0, 0, sectionButtonHeight, 0), new kuiUIVec2(0, 1, -sectionButtonHeight, 1));
			// add to scale
			sectionOffX += _sectionTextW;
			// add to it
			array_push(sectionsCore, _nCore.mySelf);
			
			// push all
			elementAdd(_nCore, _nButton);
		};
		// update them all
		sectionUpdate();
	};
	
	// add all asked sections
	for (var i = 0; i < array_length(_sections); i++) { sectionAdd(_sections[i]); };
};

/// @description Check for things
function kuiChecker(_name, _posUIVec2, _checkerText = "", _active = false, _callbackF = kuiDCall, _sizeUIVec2 = (new kuiUIVec2(14, 0, 14, 0))) : kuiCore(_name, _posUIVec2, _sizeUIVec2, _callbackF) constructor {
	
	mainSprite = sp_kui_checker;
	
	// If it's active
	activeChecker = _active;
	
	// Mouse is inside button
	mouseInside = false;
	insideHandler = false;
	
	// Add text bro
	textUI = new kuiText("textUI", new kuiUIVec2(16, 0, 0, 0), new kuiUIVec2(specialTextGetWidth(_checkerText), 0, specialTextGetHeight(_checkerText), 0), _checkerText, c_black, fa_left, fa_top, 1, fo_ui);
	elementAdd(textUI);
	
	// Step event of the button
	stepEvent = method(mySelf, function() {
		
		// Play do a clic on it
		if (mouseInside && useableElement() && inZone()) {
			requieriesCursor = cr_handpoint;
			
			// The only thing left is to check the pressed button
			if (mouse_check_button_pressed(mb_left)) {
				// Change active
				activeChecker = !activeChecker;
				// Do the callback function
				callback();
			};
		};
	});
	
	// set up this
	drawEvent = method(mySelf, function () {
		
		// Draw the button
		draw_sprite_stretched(mainSprite, activeChecker, x, y, width, height);
	});
};

/// @description A moveable window
function kuiMoveWindow(_name, _posUIVec2, _sizeUIVec2, _titleString = "", _closeable = true, _changeDepth = true, _callbackF = kuiDCall) : kuiCore(_name, _posUIVec2, _sizeUIVec2, _callbackF) constructor {
	
	if (_changeDepth) { depthIncrease(); };
	hasChangedDepth = _changeDepth;
	
	mainSprite = sp_kui_open_window;
	
	mouseXSave = 0;
	mouseYSave = 0;
	
	windowXSave = 0;
	windowYSave = 0;
	
	windowCloseable = _closeable;
	
	// set the position and size to not be modified by parent
	setPosition	(new kuiUIVec2(x, 0, y, 0));
	setSize		(new kuiUIVec2(width, 0, height, 0));
	
	lateralXOff = 0;
	lateralXSave = width;
	
	lateralYOff = 0;
	lateralYSave = height;
	
	resizeable = false;
	resizeableOffset = 2;
	resizeableMinW = -1;
	resizeableMinH = -1;
	resizeableMaxW = -1;
	resizeableMaxH = -1;
	
	drawOutAll = true;
	
	static resizeableActive = function (_minW, _minH, _maxW, _maxH) {
		// turn on resizeable
		resizeable = true;
		// adjust min and max
		resizeableMinW = _minW; resizeableMaxW = _maxW;
		resizeableMinH = _minH; resizeableMaxH = _maxH;
	};
	
	static resizeableDeactive = function () { resizeable = false; };
	
	
	// Create a text UI
	textUI = new kuiText("textUI", new kuiUIVec2(2, 0, 2, 0), new kuiUIVec2(0, 1, 15, 0), _titleString, c_black, fa_left, fa_top, 1, fo_ui_small);
	elementAdd(textUI);
	
	// Doesn't inherit parent depth
	inheritParentDepth = false;
	
	// Mouse in moving bar
	mouseInBar = false;
	// Button phase
	phase = 0;
	
	// set up this
	mouseOnLateralW = false;
	mouseOnLateralH = false;
	
	// adjust
	destroyEvent = method(mySelf, function () {
		
		// Go back depth
		if (hasChangedDepth) { depthDecrease(); };
	});
	
	// Step event of the button
	stepEvent = method(mySelf, function() {
		
		// Update mouse inside
		mouseInBar = mouseInGUI(x, y, x + width, y + 11);
		// Exit button inside
		var exitButton = mouseInGUI((x + width) - 9, y + 2, (x + width) - 2, y + 9);
		
		// Exit button
		if (exitButton && useableElement() && windowCloseable) {
			requieriesCursor = cr_handpoint;
			
			// This will do it
			if (mouse_check_button_pressed(mb_left)) {
				
				// Destroy the window
				selfDestroy();
				return;
			};
		};
		// Phase of this shit
		switch (phase) {
			
			case 0:
				
				// only update here, to save after
				mouseOnLateralW = mouseInGUI(x + width - resizeableOffset, y + 11, x + width + resizeableOffset, y + height + resizeableOffset);
				mouseOnLateralH = mouseInGUI(x, y + height - resizeableOffset, x + width + resizeableOffset, y + height + resizeableOffset);
				
				// Play do a clic on it
				if (mouseInBar && mouse_check_button_pressed(mb_left) && useableElement()) {
					// Noew using this
					global._kuiUsingButton = mySelf;
					// Get the mouse X and Y on it
					mouseXSave = windowGetMouseX();
					mouseYSave = windowGetMouseY();
					// Window save
					windowXSave = x - mouseXSave;
					windowYSave = y - mouseYSave;
					// Next phase
					phase = 1;
					break;
				};
				// resizeable?
				if (resizeable && useableElement()) {
					
					// set up the icon
					if (mouseOnLateralW && mouseOnLateralH) { requieriesCursor = cr_size_nwse; }
					else if (mouseOnLateralW) { requieriesCursor = cr_size_we; }
					else if (mouseOnLateralH) { requieriesCursor = cr_size_ns; };
					// pressed
					if (mouse_check_button_pressed(mb_left)) {
						
						// Window save
						lateralXOff = (x + width) - windowGetMouseX();
						lateralYOff = (y + height) - windowGetMouseY();
						// Whatever of them
						if (mouseOnLateralW || mouseOnLateralH) {
							
							// Noew using this
							global._kuiUsingButton = mySelf;
							// Next phase
							phase = 2;
							break;
						};
					};
				};
				
			break;
			
			case 2:
				
				// set up
				var _newWidth = width, _newHeight = height;
				
				// update on width
				if (mouseOnLateralW) {
					
					// get the new width
					_newWidth = lateralXOff + windowGetMouseX() - x;
					// clamp this out
					_newWidth = clamp(_newWidth, max(7, resizeableMinW), resizeableMaxW);
				};
				
				// update on height
				if (mouseOnLateralH) {
					
					// get the new height
					_newHeight = lateralYOff + windowGetMouseY() - y;
					// clamp this out
					_newHeight = clamp(_newHeight, max(17, resizeableMinH), resizeableMaxH);
				};
				
				// setup the size
				setSize(new kuiUIVec2(_newWidth, 0, _newHeight, 0));
				
				
				// set up the icon
				if (mouseOnLateralW && mouseOnLateralH) { requieriesCursor = cr_size_nwse; }
				else if (mouseOnLateralW) { requieriesCursor = cr_size_we; }
				else if (mouseOnLateralH) { requieriesCursor = cr_size_ns; };
				// Release the mouse
				if (!mouse_check_button(mb_left)) {
					// Reset using button
					global._kuiUsingButton = noone;
					// Reset phase
					phase = 0;
				};
			break;
			
			case 1:
				
				var newPosX = mouseXSave - x + (windowXSave);
				var newPosY = mouseYSave - y + (windowYSave);
				// Update mouse X and Y
				mouseXSave = windowGetMouseX();
				mouseYSave = windowGetMouseY();
				// Set position of window
				position.add(new kuiUIVec2(newPosX, 0, newPosY, 0));
				//xPos += newPosX;
				//yPos += newPosY;
				// Add position to this thing
				x += newPosX;
				y += newPosY;
				
				requieriesCursor = cr_drag;
				
				// Changed position
				if ((newPosX != 0) || (newPosY != 0)) {
					// Update my children
					updateUI();
				};
				// Do the callback function
				//callback();
				// Release the mouse
				if (!mouse_check_button(mb_left)) {
					// Reset using button
					global._kuiUsingButton = noone;
					// Reset phase
					phase = 0;
				};
				
			break;
		};
	});
	
	// set up this
	drawEvent = method(mySelf, function () {
		
		// Draw background
		draw_sprite_stretched(mainSprite, 0, x, y, width, height);
		// Draw exit button
		if (windowCloseable) { draw_sprite(sp_kui_close_window_button, 0, (x + width) - 9, y + 2); };
	});
};

/// @description Array of options to check
function kuiRadioArray(_name, _posUIVec2, _sizeUIVec2, _titleString, _optionDefId, _callbackF = kuiDCall) : kuiCore(_name, _posUIVec2, _sizeUIVec2, _callbackF) constructor {
	
	insideHandler = false;
	optionId = _optionDefId;
	// Option array
	optionArray = [ ];
	// Options texts
	optionText = [ ];
	// Button phase
	phase = 0;
	
	// Capacity of a column
	columnCapacity = 1;
	// Create a text UI
	textUI = new kuiText("textUI", new kuiUIVec2(0, 0, 0, 0), new kuiUIVec2(0, 1, 15, 0), _titleString);
	elementAdd(textUI);
	
	optionWidth = 0;
	optionHeight = 15;
	
	optionY = 15;
	
	static setColumnCapacity = function (newCapacity) {
		// Less than 0
		if (newCapacity <= 0) { newCapacity = 1; };
		// Capacity of a column
		columnCapacity = newCapacity;
	};
	
	static addOptions = function (addingOptions) {
		
		updateUI();
		
		// Loop to add
		for (var i = 0; i < argument_count; i++) {
			// Add to options
			array_push(optionArray, argument[i]);
			
			// Create a text UI
			var textTempIns = new kuiText("option" + string(array_length(optionArray)), new kuiUIVec2(0, 0, 0, 0), new kuiUIVec2(0, 0, 0, 0), argument[i]);
			// Add to it
			array_push(optionText, textTempIns);
			elementAdd(textTempIns);
		};
		
		updateOptionsUI();
	};
	
	static updateOptionsUI = function () {
		
		var newLength = real(array_length(optionArray));
		// Set new option width
		optionWidth = ceil(newLength / columnCapacity);
		if (optionWidth == 0) { return; };
		optionWidth = real(width) / optionWidth;
		// Loop to add
		for (var i = 0; i < array_length(optionArray); i++) {
			// Add to options
			var lastOptionID = i;
			
			var newX = optionWidth * floor(lastOptionID / columnCapacity);
			var newY = lastOptionID mod columnCapacity;
			// Create a text UI
			var textTempIns = optionText[i];
			// update each of one
			textTempIns.setPosition(new kuiUIVec2(newX + 12, 0, optionY + (newY * optionHeight), 0));
			textTempIns.setSize(new kuiUIVec2(optionWidth, 0, optionHeight, 0));
		};
	};
	
	updateUIEvent = method(mySelf, updateOptionsUI);
	
	static setOptionId = function(newId) {
		// Set selected option ID
		optionId = newId;
	};
	static getOptionId = function() {
		// Return the option ID
		return optionId;
	};
	
	// Step event of the button
	stepEvent = method(mySelf, function() {
		
		// Set font
		draw_set_font(fo_ui);
		// Loop for options
		for (var i = 0; i < array_length(optionArray); i++) {
			
			var newX = x + (optionWidth * floor(i / columnCapacity));
			var newY = y + optionY + ((i mod columnCapacity) * optionHeight);
			
			var stringWidth = string_width(optionArray[i]);
			// Get if mouse is on it
			var mouseInsideOption = mouseInGUI(newX, newY, newX + 12 + stringWidth, newY + 10);
			// If click option
			if (mouseInsideOption && mouse_check_button_pressed(mb_left) && useableElement() && inZone() && (optionId != i)) {
				
				// Set option ID
				optionId = i;
				// Do the callback function
				callback();
			};
		};
	});
	
	// set up this
	drawEvent = method(mySelf, function () {
		
		// Loop for options
		for (var i = 0; i < array_length(optionArray); i++) {
			
			var newX = optionWidth * floor(i / columnCapacity);
			var newY = i mod columnCapacity;
			// Draw the checker
			draw_sprite(sp_kui_radio_checker, (optionId == i), x + newX, y + optionY + (newY * optionHeight));
		};
	});
};


/// @description Vertical slider
/// @param	_name			The name to identify it as a struct
/// @param	_sliderPart		A part of the total, it should be always less than the total
/// @param	_sliderTotal	Total internal (not height) of the slider (ej: total height: room height, part height: camera height)
function kuiVerticalSlider(_name, _sliderPart, _sliderTotal, _posUIVec2, _sizeUIVec2, _callbackF = kuiDCall) : kuiCore(_name, _posUIVec2, _sizeUIVec2, _callbackF) constructor {
	
	// Pressing animation
	sliderPosition = 0;
	
	// Part position of the slider
	sliderPart = _sliderPart
	// Total height of the slider (ej: total height: room height, part height: camera height)
	sliderTotal = _sliderTotal;
	
	// to save where it was picked up
	mouseYSave = 0;
	
	
	// Button phase
	phase = 0;
	
	// to update well what it says
	static sliderUpdatePartTotal = function (_sPart, _sTotal) {
		
		// Update each of those
		sliderPart	 = _sPart;
		sliderTotal	 = _sTotal;
		// limi tit
		var _tempSliderHeight = (sliderPart / sliderTotal) * height;
		var _trueHeight = (height - _tempSliderHeight);
		// New position Y
		sliderPosition = clamp(sliderPosition, 0, 1);
		
		// callback
		callback();
	};
	
	// Step event of the button
	stepEvent = method(mySelf, function() {
		
		var _tempSliderHeight = (sliderPart / sliderTotal) * height;
		var _tempSliderPos = y + (sliderPosition * (height - _tempSliderHeight));
		// Update mouse inside
		mouseInside = mouseInGUI(x, _tempSliderPos, x + width, _tempSliderPos + _tempSliderHeight);
		
		// Phase of this shit
		switch (phase) {
			
			case 0:
				
				// Play do a clic on it
				if (mouseInside && useableElement() && inZone()) {
					requieriesCursor = cr_handpoint;
					if (mouse_check_button_pressed(mb_left)) {
						// Noew using this
						global._kuiUsingButton = mySelf;
						// Get the mouse Y on it
						mouseYSave = windowGetMouseY() - _tempSliderPos;
						// Next phase
						phase = 1;
						break;
					};
				};
				
			break;
			
			case 1:
				
				var _newPosY = sliderPosition;
				// If it can be divided
				if ((height - _tempSliderHeight) != 0) {
					// New position Y
					_newPosY = clamp((windowGetMouseY() - mouseYSave) - y, 0, height - _tempSliderHeight) / (height - _tempSliderHeight);
				} else {
					// Old position
					_newPosY = sliderPosition;
				};
				// Set position of slider
				sliderPosition = _newPosY;
				
				// Do the callback function
				callback();
				// Release the mouse
				if (!mouse_check_button(mb_left)) {
					// Reset using button
					global._kuiUsingButton = noone;
					// Reset phase
					phase = 0;
				};
				
			break;
		};
	});
	
	// set up this
	drawEvent = method(mySelf, function () {
		
		var _tempSliderHeight = (sliderPart / sliderTotal) * height;
		var _tempSliderPos = y + (sliderPosition * (height - _tempSliderHeight));
		// Draw background
		draw_sprite_stretched(sp_kui_slider_bg, 0, x, y, width, height);
		// Draw the button
		draw_sprite_stretched(sp_kui_slider_button, max(mouseInside, (phase == 1) * 2), x, _tempSliderPos, width, _tempSliderHeight);
	});
};

/// @description Horizontal slider
/// @param	_name			The name to identify it as a struct
/// @param	_sliderPart		A part of the total, it should be always less than the total
/// @param	_sliderTotal	Total internal (not width) of the slider (ej: total width: room width, part width: camera width)
function kuiHorizontalSlider(_name, _sliderPart, _sliderTotal, _posUIVec2, _sizeUIVec2, _callbackF = kuiDCall) : kuiCore(_name, _posUIVec2, _sizeUIVec2, _callbackF) constructor {
	
	// Pressing animation
	sliderPosition = 0; // from 0 to 1
	
	// Part position of the slider
	sliderPart = _sliderPart
	// Total height of the slider (ej: total width: room width, part width: camera width)
	sliderTotal = _sliderTotal;
	
	// to save where it was picked up
	mouseXSave = 0;
	
	
	// Button phase
	phase = 0;
	
	// Step event of the button
	stepEvent = method(mySelf, function() {
		
		var _tempSliderWidth = (sliderPart / sliderTotal) * width;
		var _tempSliderPos = x + (sliderPosition * (width - _tempSliderWidth));
		// Update mouse inside
		mouseInside = mouseInGUI(_tempSliderPos, y, _tempSliderPos + _tempSliderWidth, y + height);
		
		// Phase of this shit
		switch (phase) {
			
			case 0:
				
				// Play do a clic on it
				if (mouseInside && useableElement() && inZone()) {
					requieriesCursor = cr_handpoint;
					if (mouse_check_button_pressed(mb_left)) {
						// Noew using this
						global._kuiUsingButton = mySelf;
						// Get the mouse X on it
						mouseXSave = windowGetMouseX() - _tempSliderPos;
						// Next phase
						phase = 1;
						break;
					};
				};
				
			break;
			
			case 1:
				
				var _newPosX = sliderPosition;
				// If it can be divided
				if ((width - _tempSliderWidth) != 0) {
					// New position Y
					_newPosX = clamp((windowGetMouseX() - mouseXSave) - x, 0, width - _tempSliderWidth) / (width - _tempSliderWidth);
				} else {
					// Old position
					_newPosX = sliderPosition;
				};
				
				// Set position of slider
				sliderPosition = _newPosX;
				
				// Do the callback function
				callback();
				// Release the mouse
				if (!mouse_check_button(mb_left)) {
					// Reset using button
					global._kuiUsingButton = noone;
					// Reset phase
					phase = 0;
				};
				
			break;
		};
	});
	
	// set up this
	drawEvent = method(mySelf, function () {
		
		var _tempSliderWidth = (sliderPart / sliderTotal) * width;
		var _tempSliderPos = x + (sliderPosition * (width - _tempSliderWidth));
		// Draw background
		draw_sprite_stretched(sp_kui_slider_bg, 0, x, y, width, height);
		// Draw the button
		draw_sprite_stretched(sp_kui_slider_button, max(mouseInside, (phase == 1) * 2), _tempSliderPos, y, _tempSliderWidth, height);
	});
};


/// @description List element
/// @param _name
/// @param _posUIVec2
/// @param _sizeUIVec2
/// @param _optionCreateFunction	Per option added,	 newFunction(_oId, _listParent, _infoStruct, _oX, _oY, _oW, _oH)
/// @param _optionUpdateFunction	Per option update,	 newFunction(_oId, _listParent, _infoStruct, _oX, _oY, _oW, _oH)
function kuiList(_name, _posUIVec2, _sizeUIVec2, _optionCreateFunction, _optionUpdateFunction, _callbackF = kuiDCall) : kuiCore(_name, _posUIVec2, _sizeUIVec2, _callbackF) constructor {
	
	optionArray = [  ];
	// Option height dude
	optionHeight = 15;
	// List position
	sliderPosition = 0;
	
	uiDrawBorderOff = 1;
	
	partHeight = height;
	maxHeight = height;
	
	sliderUI = new kuiVerticalSlider("slider", 1, 1, new kuiUIVec2(-5, 1, 0, 0), new kuiUIVec2(5, 0, 0, 1), function () {
		//show_debug_message(mySelf.name)
		// Update handler slider position
		parent.sliderPosition = (parent.maxHeight - parent.partHeight) * sliderPosition;
	});
	elementAdd(sliderUI);
	
	static optionSetHeight = function (_newHeight) {
		// Updte option height
		optionHeight = _newHeight;
		// then update children
		updateUIElements();
	};
	
	static optionCount = function () { return array_length(optionArray); };
	
	static optionAdd = function (infoStruct) {
		
		var _returnData = [ ];
		
		// Loop to add to this shit
		for (var i = 0; i < argument_count; i++) {
			// It's a struct
			if (is_struct(argument[i])) {
			
				// Create elements array
				argument[i].elements = [ ];
				// Push to the options
				array_push(optionArray, argument[i]);
				// vget teh count
				var _optionCount = array_length(optionArray) - 1;
				// Create option
				array_push(_returnData, optionCreate(_optionCount, mySelf, optionGetInfoStruct(_optionCount), 1, (_optionCount * optionHeight) + 1, (width - 1) - (sliderUI.size.x.offset), optionHeight));
			};
		};
		// Minimun height
		var minheight = height - 2;
		
		partHeight = max(minheight, optionHeight);
		maxHeight = max(minheight, optionHeight * array_length(optionArray));
		// Updaye slider up
		sliderUI.sliderUpdatePartTotal(partHeight, maxHeight);
		
		return _returnData;
	};
	
	static optionAddFrom = function (fromOption, infoStruct) {
		
		var _returnData = [ ];
		
		var _preArray = [ ];
		if (fromOption >= 0) { array_copy(_preArray, 0, optionArray, 0, fromOption + 1); };
		var _postArray = [  ];
		// is enough
		if (fromOption < (array_length(optionArray) - 1))
		{ array_copy(_postArray, 0, optionArray, fromOption + 1, array_length(optionArray) - (fromOption + 1)); };
		
		var _midArray = [ ];
		
		// set up
		optionArray = _preArray;
		var _ocLength = array_length(_preArray);
		
		// Loop to add to this shit
		for (var i = 1; i < argument_count; i++) {
			// It's a struct
			if (is_struct(argument[i])) {
				
				var _finalId = _ocLength + i - 1;
				
				// Create elements array
				argument[i].elements = [ ];
				// Push to the options
				array_push(optionArray, argument[i]);
				// Create option
				array_push(_returnData, optionCreate(_finalId, mySelf, argument[i], 1, (_finalId * optionHeight) + 1, (width - 1) - (sliderUI.size.x.offset), optionHeight));
			};
		};
		
		// end up adding
		optionArray = array_concat(optionArray, _postArray);
		//show_debug_message("optionCount:" + string(array_length(optionArray)));
		// Minimun height
		var minheight = height - 2;
		
		partHeight = max(minheight, optionHeight);
		maxHeight = max(minheight, optionHeight * array_length(optionArray));
		// Updaye slider up
		sliderUI.sliderUpdatePartTotal(partHeight, maxHeight);
		
		return _returnData;
	};
	/// @description Deletes options
	static optionDelete = function (fromOption, lengthSize = 1) {
		
		// get this one
		for (var i = 0; i < lengthSize; i++) {
			var _optionIndex = fromOption + i;
			// get this on
			if (_optionIndex < array_length(optionArray)) {
				// search this here
				var _optionData = optionArray[_optionIndex];
				
				// get all elements
				for (var n = 0; n < array_length(_optionData.elements); n++) {
					// delete each element
					_optionData.elements[n].selfDestroy();
				};
			};
		};
		// and delete each one
		array_delete(optionArray, fromOption, lengthSize);
		
		// Minimun height
		var minheight = height - 2;
		
		partHeight = max(minheight, optionHeight);
		maxHeight = max(minheight, optionHeight * array_length(optionArray));
		// Updaye slider up
		sliderUI.sliderUpdatePartTotal(partHeight, maxHeight);
	};
	
	/// @description Per option create function
	optionCreate = method(mySelf, _optionCreateFunction);//function (oId, listParent, infoStruct, oX, oY, oW, oH) { };
	/// @description Per option update function
	optionUpdate = method(mySelf, _optionUpdateFunction);//function (oId, listParent, infoStruct, oX, oY, _oW, _oH) { };
	
	/// @description Per option added, newFunction(oId, listParent, oX, oY, oW, oH)
	static setUserOptionCreateEvent = function (_newFunction) { optionCreate = method(mySelf, _newFunction); };
	/// @description Per option update, newFunction(oId, listParent, oX, oY)
	static setUserOptionUpdateEvent = function (_newFunction) { optionUpdate = method(mySelf, _newFunction); };
	
	/// @description Get option info struct
	static optionGetInfoStruct = function (oId) {
		
		// Return option info
		return optionArray[oId];
	};
	/// @description add elements to the struct here
	static optionAddElement = function (oId, elementsIns) {
		
		// Loop to add to elements
		for (var i = 1; i < argument_count; i++) {
			var _elementIns = argument[i];
			
			// add elmenet
			elementAdd(_elementIns);
			// Push inside content array
			array_push(optionArray[oId].elements, _elementIns);
		};
		// then update children
		updateUIElements();
	};
	// get that option elements
	static optionGetElements = function (oId) {
		// get the elements arrat
		return optionArray[oId].elements;
	};
	// @description Get an specific element by his name
	static optionGetElement = function (oId, elementName) {
		// get that
		var _elementsArr = optionGetElements(oId);
		// found?
		var _searchUp = arrayFind(_elementsArr, elementName);
		// found?
		if (_searchUp >= 0) {
			return _elementsArr[_searchUp];
		};
		
		return noone;
	};
	
	// Update option position
	updateUIElements = method(mySelf, function (oId) {
		
		// Update my slider
		sliderUI.updateUI();
		
		// Loop for options
		for (var n = 0; n < array_length(optionArray); n++) {
			var _yPos = (y + 1) + ((n * optionHeight) - sliderPosition);
			var _continueAlarm = ((_yPos > (y + height)) || ((_yPos + optionHeight) < y));
			
			// Get all content
			for (var i = 0; i < array_length(optionArray[n].elements); i++) {
				// Get instance ID
				var instanceId = optionArray[n].elements[i];
				// is on range?
				if (_continueAlarm) { instanceId.activeUI = false; continue; };
				
				// Update X and Y scale
				instanceId.width	 = (((width - 1) - (sliderUI.size.x.offset)) * instanceId.size.x.scale) + (instanceId.size.x.offset);
				instanceId.height	 = (optionHeight * instanceId.size.y.scale) + (instanceId.size.y.offset);
				// Update X and Y position
				instanceId.x = (x + 1) + (instanceId.position.x.scale * ((width - 1) - (sliderUI.size.x.offset))) + instanceId.position.x.offset;
				instanceId.y = ((((y + 1) + (n * optionHeight)) + (instanceId.position.y.scale * optionHeight)) - sliderPosition) + instanceId.position.y.offset;
				// Add anchor position
				instanceId.x -= (instanceId.width * instanceId.anchorPosition.x);
				instanceId.y -= (instanceId.height * instanceId.anchorPosition.y);
				
				// update if hidden
				if (((instanceId.x > (x + width)) || ((instanceId.x + instanceId.width) < x)) ||
					((instanceId.y > (y + height)) || ((instanceId.y + instanceId.height) < y))) {
					// set up hide
					instanceId.activeUI = false;
					continue;
					//show_debug_message("unactiving UI")
				} else { instanceId.activeUI = true; };
				
				// Update his children too
				instanceId.updateUIElements();
				
				
				
				//instanceId.uiActive = true;
			};
		};
	});
	
	/// @description Updates buttons but not UI position
	updateOnlyButtons = function () {
		
		// Loop to update all options
		for (var i = 0; i < array_length(optionArray); i++) {
			// Update option variables
			optionUpdate(i, mySelf, optionGetInfoStruct(i), 1, 1 + ((i * optionHeight) - sliderPosition));
		};
	};
	
	// Step event of the button
	stepEvent = method(mySelf, function() {
		
		// Loop to update all options
		for (var i = 0; i < array_length(optionArray); i++) {
			// Update option variables
			optionUpdate(i, mySelf, optionGetInfoStruct(i), 1, 1 + ((i * optionHeight) - sliderPosition));
			// Update this shit
			updateUIElements();
		};
	});
	
	// set up this
	drawEvent = method(mySelf, function () {
		
		// Draw the button
		draw_sprite_stretched(sp_kui_list_inside, 0, x, y, width, height);
		// Set bounds shader earlier
		setBounds(1);
		kuiSetBoundsShader();
		// Loop to draw all options
		for (var i = 0; i < array_length(optionArray); i++) {
			
			var _yPos = (y + 1) + ((i * optionHeight) - sliderPosition);
			// is on range?
			if ((_yPos > (y + height)) || ((_yPos + optionHeight) < y)) { continue; };
			
			// Draw list part
			draw_sprite_stretched(sp_kui_list, 0, x + 1, _yPos, width - 2, optionHeight);
		};
		kuiResetBoundsShader();
		resetBoundsOffset(1);
	});
};

/// @description When pressed, opens up a list
/// @param _name
/// @param _posUIVec2
/// @param _sizeUIVec2
/// @param _initText
/// @param _listHeight
/// @param _optionCreateFunction	Per option added,	 newFunction(_oId, _listParent, _infoStruct, _oX, _oY, _oW, _oH)
/// @param _optionsToAdd
/// @param _optionUpdateFunction	Per option update,	 newFunction(_oId, _listParent, _infoStruct, _oX, _oY)
function kuiListButton(_name, _posUIVec2, _sizeUIVec2, _initText, _listHeight, _optionCreateFunction = function () { }, _optionsToAdd = [ ], _optionUpdateFunction = function () { }, _extraButtonCallback = function () { }) : kuiButtonText(_name, _posUIVec2, _sizeUIVec2, _initText) constructor {
	
	__tempList = noone;
	__listHeight = _listHeight;

	__listCreateFunction = _optionCreateFunction;
	__listUpdateFunction = _optionUpdateFunction;

	__listOptions = _optionsToAdd;
	// A list image
	var _imageList = new kuiImage("imageUI", sp_kui_list_button, 0, new kuiUIVec2(-12, 1, -3.5, 0.5), new kuiUIVec2(7, 0, 7, 0));
	// Add to button
	elementAdd(_imageList);
	
	extraButtonCallback = method(mySelf, _extraButtonCallback);
	
	// Set up the callback
	callbackSet(function () {
		
		// Does exists?
		if (kuiExists(__tempList)) {
			// goodbye list
			__tempList.selfDestroy();
		} else {
			// do this
			extraButtonCallback();
			// increase depth
			depthIncrease();
			
			// create the list
			__tempList = new kuiList("_tempList", new kuiUIVec2(position.x.offset, position.x.scale, position.y.offset + size.y.offset, position.y.scale + size.y.scale), new kuiUIVec2(size.x.offset, size.x.scale, __listHeight, 0), __listCreateFunction, __listUpdateFunction, function () { });
			__tempList.drawOutAll = true;
			with (__tempList) {
				script_execute_ext(optionAdd, other.__listOptions);
			};
			
			__tempList.originalButton = mySelf;
			
			__tempList.destroyEvent = method(__tempList, function () { originalButton.depthDecrease(); });
			parent.elementAdd(__tempList);
		};
	});
};




























