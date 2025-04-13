
enum eAnimType {
    object,
    sprite,
    animationSprite,
    animation,
	objectChannelAnimation
};

enum eAnimAnimType {
    groupAnimcurve,
	groupKCurve,
};

enum eAnimRepeatType {
    endloop,
    loop,
    backloop
};

enum eAnimAnimSpriteType {
    endloop,
    loop,
    backloop
};

enum eAnimLinkType {
	aValue,
	aFull,
	aPlay
};

global._eAnimTypeTranslation = [];
// add all to it
global._eAnimTypeTranslation[eAnimType.object]					 = "object";
global._eAnimTypeTranslation[eAnimType.sprite]					 = "sprite";
global._eAnimTypeTranslation[eAnimType.animationSprite]			 = "animationSprite";
global._eAnimTypeTranslation[eAnimType.animation]				 = "animation";
global._eAnimTypeTranslation[eAnimType.objectChannelAnimation]	 = "objectChannelAnimation";

global._eAnimDepthList = ds_priority_create();

function structSaveUpNoRepetitions(_struct) {
	
	// set up the return struct
	var _returnStruct = { };
	
	// get all the names
	var _structNames = struct_get_names(_struct);
	// loop for each one
	for (var i = 0; i < array_length(_structNames); i++) {
		
		// is not self or parent
		if (_structNames[i] == "mySelf") { _returnStruct[$ "HAS_SELF_VALUE"] = true; };
		if (_structNames[i] == "parent") { _returnStruct[$ "HAS_PARENT_VALUE"] = true; };
		// is slements
		if (_structNames[i] == "elements") {
			
			// set that
			_returnStruct.elements = { };
			// get the names
			var _elementsNames = struct_get_names(_struct.elements);
			// save up each one
			for (var n = 0; n < array_length(_elementsNames); n++) {
				// set that up
				_returnStruct.elements[$ _elementsNames[n]] = _struct.elements[$ _elementsNames[n]];
			};
			
			continue;
			
		// is hat
		} else if (_structNames[i] == "linkChildren") {
			
			
		} else {
			
			var _theValue = _struct[$ _structNames[i]];
			
			// check if its struct
			if (is_struct(_theValue)) {
				// save up
				_returnStruct[$ _structNames[i]] = structSaveUpNoRepetitions(_theValue);
			} else {
				// just paste in
				
			};
		};
	};
};

function structRestoreUpNoRepetitions(_struct) {
	
	// set up the return struct
	var _returnStruct = { };
	
	// get all the names
	var _structNames = struct_get_names(_struct);
	// loop for each one
	for (var i = 0; i < array_length(_structNames); i++) {
		
		// loop here
		if (_structNames[i] == "parent") { _returnStruct[$ "HAS_PARENT_VALUE"] = true; continue; };
		
	};
	
	// is not self or parent
	if (struct_exists(_struct, "HAS_SELF_VALUE")) { _returnStruct[$ "mySelf"] = _returnStruct; };
	// has elements here
	
};

/// @description this works to show if an element has been created
function eAnimDebugCreation(_generalType) {
	
	// has that
	if (debugVGetValue("showEAnimCreation", false)) {
		// show up
		show_debug_message("EANIM " + _generalType + " CREATED (" + string(currentFrame() / 60) + "s)");
	};
};

/// @description If the mentioned element is indeed an element
function eAnimExists(_eElement) { return is_struct(_eElement); };

/// @description Creates an animation object
function eAnimObjectCreate(_id, _x, _y) constructor {
    
	eAnimDebugCreation("OBJECT");
	//show_debug_message("ENMY OBJECT CREATED (" + string(currentFrame() / 60) + "s)")
	// Empty struct which will contain all elements of the object
    elements = {};
    mySelf = self;
    // Where it is?
    x = _x;
    y = _y;
    angle = 0;
    alpha = 1;
	
    xScale = 1;
    yScale = 1;
	eScale = 1;
	
	hide = false;
    // Set all X and Y shifts
    xShift = 0;
    yShift = 0;
	
    depthShift = 0;
	
    angleShift = 0;
    alphaShift = 1;
	
    xScaleShift = 1;
    yScaleShift = 1;
	eScaleShift = 1;
    //myDepth = _depth;
    // As a name
    id = _id;
    parent = noone;
    type = eAnimType.object;
	
	// set up transition animation
	transition = false;
	transitionValue = 2; // has it goes from 0 to 1
	transitionShift = 1 / timerGet(0.5);
	
	transitionAnimValue = 2;
	transitionAnim = -1; // animcurve for transition, -1 is just linear
	
	// save up each var, combines up shift and value
	
	// position
	transitionX = 0; // x + shift
	transitionY = 0;
	transitionXShift = 0;
	transitionYShift = 0;
	// scales
	transitionXScale = 1;
	transitionYScale = 1;
	transitionEScale = 1;
	// depth
	transitionDepth = 0;
	transitionAlpha = 1;
	transitionAngle = 0;
	
	// random
	transitionSaveStruct = { };
	
	
	
	
    
    static elementAdd = function (_eAnimElement) {
        // Set it on
        struct_set(elements, _eAnimElement.id, _eAnimElement);
        // Me as the parent
        _eAnimElement.parent = mySelf;
    };
    static elementDelete = function (_id) {
        // Reset the parent
        struct_get(elements, _id).parent = noone;
        // Delete struct
        struct_remove(elements, _id);
    };
	
	static selfDestroy = function () {
		//
	};
	
	
	
	static transitionActive = function (_durationInSeconds, _animId = -1) {
		// save up this
		transition = true;
		transitionAnim = _animId;
		// set up shift
		transitionShift = 1 / timerGet(_durationInSeconds);
	};
	
	static transitionSave = function () {
		
		// position
		transitionX = x;  // x + shift
		transitionY = y;
		transitionXShift = xShift;
		transitionYShift = yShift;
		// scales
		transitionXScale = xScale * xScaleShift;
		transitionYScale = yScale * yScaleShift;
		transitionEScale = eScale * eScaleShift;
		// depth
		transitionDepth = depthShift;
		transitionAlpha = alpha * alphaShift;
		transitionAngle = angle * angleShift;
		
		// set up each thing
		transitionSaveStruct = {
			x : x,
			y : y,
			
			xShift : xShift,
			yShift : yShift,
			
			xScale : xScale * xScaleShift,
			yScale : yScale * yScaleShift,
			eScale : eScale * eScaleShift,
			
			myDepth : depthShift,
			alpha : alpha * alphaShift,
			angle : angle * angleShift,
			
			elements : { }
		};
		
		 // Get all the elements
        var _elementNames = struct_get_names(elements);
        // Loop through all
        for (var i = 0; i < array_length(_elementNames); i++) {
            // Make his step event run
            var _elementId = struct_get(elements, _elementNames[i]);
			// Is sprite
			if ((_elementId.type == eAnimType.sprite) || (_elementId.type == eAnimType.object)) {
				// save up this
				transitionSaveStruct.elements[$ _elementId.id] = _elementId.transitionSave();
			};
        };
		
		return transitionSaveStruct;
	};
	
	static transitionPlay = function () {
		// turn on
		transitionValue = 0;
		transitionAnimValue = 0;
	};
    
    static stepEvent = function () {
		
		// has transition?
		if (transitionValue < 1) { transitionValue += transitionShift; };
		// set up
		if (transitionAnim != -1) { transitionAnimValue = animcurveRead(transitionAnim, "value", transitionValue, transitionValue); }
		else { transitionAnimValue = transitionValue; };
		
        // Get all the elements
        var _elementNames = struct_get_names(elements);
        // Loop through all
        for (var i = 0; i < array_length(_elementNames); i++) {
            // Make his step event run
            var _elementId = struct_get(elements, _elementNames[i]);
            _elementId.stepEvent();
        };
    };
};

function eAnimSpriteCreate(_id, _x, _y, _spriteId, _depth) constructor {
    
	eAnimDebugCreation("SPRITE");
	
    elements = { };
    mySelf = self;
    
    spriteId = _spriteId;
    // Where it is?
    x = _x;
    y = _y;
	
    angle = 0;
    alpha = 1;
	
    xScale = 1;
    yScale = 1;
	eScale = 1;
	
    myDepth = _depth;
	hide = false;
    // Set all X and Y shifts
    xShift = 0;
    yShift = 0;
	
    depthShift = 0;
	
    angleShift = 0;
    alphaShift = 1;
	
    xScaleShift = 1;
    yScaleShift = 1;
	eScaleShift = 1;
    // As a name
    id = _id;
    parent = noone;
    type = eAnimType.sprite;
	
	// set up transition animation
	transition = false;
	transitionValue = 2; // has it goes from 0 to 1
	transitionShift = 1 / timerGet(0.5);
	
	transitionAnimValue = 2;
	transitionAnim = -1; // animcurve for transition, -1 is just linear
	// this will save em all
	transitionSaveStruct = { };
	
	// save up each var, combines up shift and value
	
	// position
	transitionX = 0; // x + shift
	transitionY = 0;
	transitionXShift = 0;
	transitionYShift = 0;
	// scales
	transitionXScale = 1;
	transitionYScale = 1;
	transitionEScale = 1;
	// depth
	transitionDepth = 0;
	transitionAlpha = 1;
	transitionAngle = 0;
	
    
    // This works for step one
    animIndex = 0;
    animValue = 0;
    animShift = 0;
    imageSpeed = 1;
    // Needs the ID for it
    animPlaying = "";
    
	static transitionSave = function () {
		
		// position
		transitionX = x; // x + shift
		transitionY = y;
		transitionXShift = xShift;
		transitionYShift = yShift;
		// scales
		transitionXScale = xScale * xScaleShift;
		transitionYScale = yScale * yScaleShift;
		transitionEScale = eScale * eScaleShift;
		// depth
		transitionDepth = myDepth + depthShift;
		transitionAlpha = alpha * alphaShift;
		transitionAngle = angle * angleShift;
		// set up each thing
		transitionSaveStruct = {
			x : x,
			y : y,
			
			xShift : xShift,
			yShift : yShift,
			
			xScale : xScale * xScaleShift,
			yScale : yScale * yScaleShift,
			eScale : eScale * eScaleShift,
			
			myDepth : myDepth + depthShift,
			alpha : alpha * alphaShift,
			angle : angle * angleShift
		};
		
		return transitionSaveStruct;
	};
	
    static animAdd = function (_eAnimAnimId) {
        
        // Add to my animations
        struct_set(elements, _eAnimAnimId.id, _eAnimAnimId);
        _eAnimAnimId.parent = mySelf;
    };
	
    static animDelete = function (_id) {
        // Reset the parent
        struct_get(elements, _id).parent = noone;
        // Delete struct
        struct_remove(animations, _id);
    };
    
    static animPlay = function (_animAnimSId) {
        
        // Does it exists?
        if (struct_exists(elements, _animAnimSId)) {
            
            var _animAnimS = struct_get(elements, _animAnimSId);
            
            // Set the animation shift
            animShift = _animAnimS.animSpeed / timerGet(1);
            animValue = 0;
            
            // And set the animation playing
            animPlaying = _animAnimSId;
			
			_animAnimS.functionStart();
        };
    };
    
	static animSetSpeed = function (_newSpeed) { imageSpeed = _newSpeed; };
	
    static animIsPlaying = function () {
        return struct_exists(elements, animPlaying);
    };
    
    static animStop = function (resetIndex = true) {
        // is not clear
        if (struct_exists(elements, animPlaying)) {
			
			elements[$ animPlaying].functionEnd();
			
            animValue = 0;
            animShift = 0;
            
            animPlaying = "";
            
            if (resetIndex)
                { animIndex = 0; };
            
            return;
        };
        return;
    };
    
    static stepEvent = function () {
        
		// has transition?
		if (transitionValue < 1) { transitionValue += transitionShift; };
		// set up
		if (transitionAnim != -1) { transitionAnimValue = animcurveRead(transitionAnim, "value", transitionValue, transitionValue); }
		else { transitionAnimValue = transitionValue; };
		
        // It does exists in animation?
        if (struct_exists(elements, animPlaying)) {
            // Get the playing animation struct
            var _eAnimAnimS = struct_get(elements, animPlaying);
            var _eAnimAnimSMax = array_length(_eAnimAnimS.animThread);
            // Increase anim valure
            animValue += animShift * imageSpeed;
            
            // Reaches max
            if ((animValue >= (_eAnimAnimSMax - 0.5)) && ((animShift * imageSpeed) > 0)) {
                switch (_eAnimAnimS.animType) {
                    case eAnimAnimSpriteType.loop:
                        while (animValue >= (_eAnimAnimSMax - 0.5)) {
                            // Set the first one
                            animValue = animValue - _eAnimAnimSMax;
							
							_eAnimAnimS.functionLoop();
                        };
                    break;
                    
                    case eAnimAnimSpriteType.endloop:
                        // Set the last one
                        animValue = _eAnimAnimSMax - 1;
                        // Quit the playing animation
                        animPlaying = "";
						
						_eAnimAnimS.functionEnd();
                    break;
                    
                    case eAnimAnimSpriteType.backloop:
                        // Set it up here
                        animShift *= -1;
						
						_eAnimAnimS.functionBackloop();
                    break;
                };
            };
            // Reached min
            if ((animValue <= -0.5) && ((animShift * imageSpeed) < 0)) {
                switch (_eAnimAnimS.animType) {
                    case eAnimAnimSpriteType.loop:
                        while (animValue <= -0.5) {
                            // Set the last one
                            animValue = _eAnimAnimSMax + animValue;
							
							_eAnimAnimS.functionLoop();
                        };
                    break;
                    
                    case eAnimAnimSpriteType.endloop:
                        // Set the first one
                        animValue = 0;
                        // Quit the playing animation
                        animPlaying = "";
						
						_eAnimAnimS.functionEnd();
                    break;
                    
                    case eAnimAnimSpriteType.backloop:
                        // Set it up here
                        animShift *= -1;
						
						_eAnimAnimS.functionBackloop();
                    break;
                };
            };
            
            // Set the rounded one
            var _roundedOne = round(animValue);
            // Over the limits
            while (_roundedOne < 0)
            { _roundedOne = _eAnimAnimSMax + _roundedOne; }; 
            while (_roundedOne >= _eAnimAnimSMax)
            { _roundedOne = _roundedOne - _eAnimAnimSMax; };
            
            animIndex = _eAnimAnimS.animThread[_roundedOne];
			
			_eAnimAnimS.functionPlaying();
        };
    };
};

/// @param {function}       doFunction       (elementIns, elementIndex)
function eAnimParentElementsLoop(doFunction, restrictiveType = -1) {
    
    // Get parent all elements
    var _parentElements = struct_get_names(parent.elements);
	var _saveUp = [ ];
    for (var i = 0; i < array_length(_parentElements); i++) {
        var _elementIns = struct_get(parent.elements, _parentElements[i]);
        
        // Is an sprite?
        if ((restrictiveType != -1) ? (_elementIns.type == restrictiveType) : (true)) {
            // Setup the function
            array_push(_saveUp, doFunction(_elementIns, i));
        };
    };
	
	return _saveUp;
};

/// @description Get an array of all mentioned elements on an animation curve
function eAnimAnimationCurveGetMentionedElements(_animCurveId) {
	
	// is the?
	var _animChannels = animcurve_get(_animCurveId).channels;
	var _mentionedElements = [ ];
	// read all
	for (var i = 0; i < array_length(_animChannels); i++) {
		var _channelName = _animChannels[i].name;
		// is shift?
		if (_channelName != "shift") {
			// check out of _
			for (var n = string_length(_channelName); n >= 2; n--) {
				// is _?
				if (string_char_at(_channelName, n) == "_") {
					var _toPush = string_copy(_channelName, 1, n - 1);
					// show it as mentioned
					if (arrayFind(_mentionedElements, _toPush) == -1) {
						array_push(_mentionedElements, _toPush);
					};
				};
			};
		};
	};
	
	show_debug_message(json_stringify(animcurve_get(_animCurveId), true));
	
	return _mentionedElements;
};

/// @description Get an array of all mentioned elements on an k curve
function eAnimKCurveGetMentionedElements(_animCurveId) {
	
	// is the?
	var _animChannels = _animCurveId.channels;
	var _mentionedElements = [ ];
	// read all
	for (var i = 0; i < array_length(_animChannels); i++) {
		var _channelName = _animChannels[i].name;
		// is shift?
		if (_channelName != "shift") {
			// check out of _
			for (var n = string_length(_channelName); n >= 2; n--) {
				// is _?
				if (string_char_at(_channelName, n) == "_") {
					var _toPush = string_copy(_channelName, 1, n - 1);
					// show it as mentioned
					if (arrayFind(_mentionedElements, _toPush) == -1) {
						array_push(_mentionedElements, _toPush);
					};
				};
			};
		};
	};
	
	return _mentionedElements;
};

/// @description Get an array with each mentioned value from an object in the animation curve
function eAnimKCurveGetMentionedValues(_animCurveId, _objectName) {
	
	// is the?
	var _animChannels = _animCurveId.channels;
	var _mentionedElements = [ ];
	// read all
	for (var i = 0; i < array_length(_animChannels); i++) {
		var _channelName = _animChannels[i].name;
		// is shift?
		if (_channelName != "shift") {
			// check out of _
			for (var n = string_length(_channelName); n >= 2; n--) {
				// is _?
				if (string_char_at(_channelName, n) == "_") {
					var _toPush = string_copy(_channelName, 1, n - 1);
					// show it as mentioned
					if (_toPush == _objectName) {
						array_push(_mentionedElements, 
							string_copy(_channelName, n + 1, string_length(_channelName) - n));
					};
				};
			};
		};
	};
	
	return _mentionedElements;
};

/// @param {string}  _id                     The ID (name) of this
/// @param {real}    _animType               The type of animation, the next arguments depends on this
/// @param {real}    mainCurve               On groupAnimcurve: mainCurve
/// @param {bool}    hideNotMentioned        On groupAnimcurve: hideNotMentioned
/// @param {real}    repeatType              On groupAnimcurve: repeatType
function eAnimAnimationCreate(_id, _animType) constructor {
    
	eAnimDebugCreation("ANIMATION");
	
	// As a name
    id = _id;
    parent = noone;
    type = eAnimType.animation;
    
    mySelf = self;
    
    isPlaying = false;
	isPaused = false;
    
    functionPlaying = function () { return };
    functionStart = function () { return; };
    functionEnd = function () { return; };
	functionBackloop = function () { return; };
	functionLoop = function () { return; };
    
	linkValueTo = noone;
	linkType = eAnimLinkType.aFull;
	// full - if that animation starts i start too
	// value - only links value if that anim is playing
	// play - links start and end
	
	linkChildren = [ ];
	
	
	// if end all others
	animEndSiblings = true;
    // Goes from 0 to 1
    animValue = 0;
	// hw fast it goed to maximun
    animShift = 0;
	animSpeed = 1; // the speed of the animation in percentage
    
    animType = _animType;
    switch (animType) {
        case eAnimAnimType.groupAnimcurve: case eAnimAnimType.groupKCurve:
            // Set that as main curve
            mainCurve = argument[2];
            // Hide not mentioned sprites
            hideNotMentioned = argument[3];
			hiddenElements = [ ];
            // Animation type
            animLoopType = argument[4];
        break;
    };
    
	static animSetEndAllOthers = function (_endAllOthers) {
		// update this
		animEndSiblings = _endAllOthers;
	};
	
    static animSetFunctionStart = function (_newFunction) {
        
        functionStart = method(mySelf, _newFunction);
    };
    
    static animSetFunctionEnd = function (_newFunction) {
            
        functionEnd = method(mySelf, _newFunction);
    };
    
    static animSetFunctionPlaying = function (_newFunction) {
            
        functionPlaying = method(mySelf, _newFunction);
    };
	
	static animSetFunctionLoop = function (_newFunction) {
            
        functionLoop = method(mySelf, _newFunction);
    };
	
	static animSetFunctionBackloop = function (_newFunction) {
            
        functionBackloop = method(mySelf, _newFunction);
    };
	
	static animUpdate = function () {
		switch (animType) {
            case eAnimAnimType.groupAnimcurve:
                eAnimParentElementsLoop(function (_elementIns) {
					
                    if (_elementIns.type == eAnimType.sprite || _elementIns.type == eAnimType.object) {
                        
						// Search for it in animcurve
						_elementIns.xShift = animcurveRead(mainCurve, string(_elementIns.id) + "_x", animValue, 0);
						_elementIns.yShift = animcurveRead(mainCurve, string(_elementIns.id) + "_y", animValue, 0);
						// Now the scale too
						_elementIns.xScaleShift = animcurveRead(mainCurve, string(_elementIns.id) + "_xScale", animValue, 1);
						_elementIns.yScaleShift = animcurveRead(mainCurve, string(_elementIns.id) + "_yScale", animValue, 1);
						_elementIns.eScaleShift = animcurveRead(mainCurve, string(_elementIns.id) + "_eScale", animValue, 1);
						// Extra values
						_elementIns.alphaShift = animcurveRead(mainCurve, string(_elementIns.id) + "_alpha", animValue, 1);
						_elementIns.angleShift = animcurveRead(mainCurve, string(_elementIns.id) + "_angle", animValue, 0);
                        // Deptgh
                        _elementIns.depthShift = animcurveRead(mainCurve, string(_elementIns.id) + "_depth", animValue, 0);
					};
                });
			break;
			
			case eAnimAnimType.groupKCurve:
                eAnimParentElementsLoop(function (_elementIns) {
					
                    if (_elementIns.type == eAnimType.sprite || _elementIns.type == eAnimType.object) {
                        
						// Search for it in animcurve
						_elementIns.xShift = mainCurve.channelRead(string(_elementIns.id) + "_x", animValue, 0);
						_elementIns.yShift = mainCurve.channelRead(string(_elementIns.id) + "_y", animValue, 0);
						// Now the scale too
						_elementIns.xScaleShift = mainCurve.channelRead(string(_elementIns.id) + "_xScale", animValue, 1);
						_elementIns.yScaleShift = mainCurve.channelRead(string(_elementIns.id) + "_yScale", animValue, 1);
						_elementIns.eScaleShift = mainCurve.channelRead(string(_elementIns.id) + "_eScale", animValue, 1);
						// Extra values
						_elementIns.alphaShift = mainCurve.channelRead(string(_elementIns.id) + "_alpha", animValue, 1);
						_elementIns.angleShift = mainCurve.channelRead(string(_elementIns.id) + "_angle", animValue, 0);
                        // Deptgh
                        _elementIns.depthShift = mainCurve.channelRead(string(_elementIns.id) + "_depth", animValue, 0);
					};
                });
			break;
        };
	};
	
	static animLinkValueToAnim = function (_animIns, _linkType = eAnimLinkType.aValue) {
		
		// is linked
		if (eAnimExists(linkValueTo)) {
			// unlink
			animUnlinkValueToAnim();
		};
		
		// set it up
		linkValueTo = _animIns;
		linkType = _linkType;
		// add to link children
		array_push(_animIns.linkChildren, mySelf);
	};
	
	static animUnlinkValueToAnim = function () {
		// delete from children
		var _search = arrayFind(linkValueTo.linkChildren, mySelf);
		if (_search != -1) {
			array_delete(linkValueTo.linkChildren, _search, 1);
		};
		// unlink
		linkValueTo = noone; 
	};
	
	static animReset = function () {
		switch (animType) {
			case eAnimAnimType.groupAnimcurve:
				// Only works if it's playing
				if (!isPlaying)
                    { break; };
				
				// Reset value
				animValue = 0;
				// Update animation
				animUpdate();
				
			break;
		};
	};
    
    static animPlay = function (_endAllOthers = animEndSiblings) {
        switch (animType) {
            case eAnimAnimType.groupAnimcurve: case eAnimAnimType.groupKCurve:
                
				// hide not mentioned?
				if (hideNotMentioned) {
					// get all mentioned elements
					var _mentionedElements = 
						(animType == eAnimAnimType.groupAnimcurve) ? eAnimAnimationCurveGetMentionedElements(mainCurve) : eAnimKCurveGetMentionedElements(mainCurve);
					// search for it
					var _parentElements = parent.elements;
					for (var i = 0; i < array_length(_mentionedElements); i++) {
						if (struct_exists(_parentElements, _mentionedElements[i])) {
							// set it
							array_push(hiddenElements, [ _mentionedElements[i], _parentElements[$ _mentionedElements[i]].hide ]);
							_parentElements[@ _mentionedElements[i]].hide = true;
						};
					};
				};
				
				// End all other aniamtions
				if (_endAllOthers) {
	                var _saveUp = eAnimParentElementsLoop(function (_elementIns) {
	                    // Is playing?
	                    if (_elementIns.isPlaying) {
	                        // Sotp it
	                        _elementIns.animStop();
							
							return true;
	                    };
						
						return false;
	                }, eAnimType.animation);
					// was playing
					if (parent.transition && (arrayFind(_saveUp, true) != -1)) {
						
						// save up transition
						parent.transitionSave();
						parent.transitionPlay();
					};
				};
				
				
				// loop for all
				for (var i = 0; i < array_length(linkChildren); i++) {
					var _linkType = linkChildren[i].linkType;
					if (_linkType == eAnimLinkType.aFull || _linkType == eAnimLinkType.aPlay) {
						linkChildren[i].animPlay();
					};
				};
                
				// if the curve is
				if (animType == eAnimAnimType.groupAnimcurve) {
	                // Get shift from it
	                animShift = animcurveRead(mainCurve, "shift", 0, 0);
				} else {
					 // Get shift from it
	                animShift = mainCurve.channelRead("shift", 0, 0);
				};
                // Reset anim value
                animValue = 0;
                isPlaying = true;
				isPaused = false;
                show_debug_message("ANIMATION PLAYING (" + string(id) + ") (" + string(parent.id) + ")");
                
            
                eAnimParentElementsLoop(function (_elementIns) {
                    
                    show_debug_message("on all elements animation + " + string(_elementIns.id));
                    
                    if (_elementIns.type == eAnimType.sprite || _elementIns.type == eAnimType.object) {
                        // Search for it in animcurve
                        _elementIns.xShift = 0;
                        _elementIns.yShift = 0;
                        // Now the scale too
                        _elementIns.xScaleShift = 1;
                        _elementIns.yScaleShift = 1;
                        // Extra values
                        _elementIns.alphaShift = 1;
                        _elementIns.angleShift = 0;
                        // Depth shift
                        _elementIns.depthShift = 0;
                    };
                    if (_elementIns.type == eAnimType.sprite) { _elementIns.animPlay("default"); };
                });
                
                stepEvent();
                animValue = 0;
            
                functionStart();
            break;
        };
    };
    
    static animPause = function () {
        // Now is paused
        isPaused = true;
		// loop for all
		for (var i = 0; i < array_length(linkChildren); i++) {
			var _linkType = linkChildren[i].linkType;
			if (_linkType == eAnimLinkType.aFull || _linkType == eAnimLinkType.aPlay) {
				linkChildren[i].animPause();
			};
		};
    };
    static animResume = function () {
        // Resume playing
        isPaused = false;
		// loop for all
		for (var i = 0; i < array_length(linkChildren); i++) {
			var _linkType = linkChildren[i].linkType;
			if (_linkType == eAnimLinkType.aFull || _linkType == eAnimLinkType.aPlay) {
				linkChildren[i].animResume();
			};
		};
    };
    
	static animSetSpeed = function (_newSpeed) { animSpeed = _newSpeed; };
	
    static animStop = function () {
        // Not playing anymore
        isPlaying = false;
		// back up
		isPaused = false;
        // loop for all
		for (var i = 0; i < array_length(linkChildren); i++) {
			var _linkType = linkChildren[i].linkType;
			if (_linkType == eAnimLinkType.aFull || _linkType == eAnimLinkType.aPlay) {
				linkChildren[i].animStop();
			};
		};
		
		// hide not mentioned?
		if (hideNotMentioned) {
			// search for it
			var _parentElements = parent.elements;
			for (var i = 0; i < array_length(hiddenElements); i++) {
				if (struct_exists(_parentElements, hiddenElements[i][0])) {
					// set it to original value
					_parentElements[$ hiddenElements[i][0]].hide = hiddenElements[i][1];
				};
			};
		};
		
		
        eAnimParentElementsLoop(function (_elementIns) {
            
            if (_elementIns.type == eAnimType.sprite || _elementIns.type == eAnimType.object) {
                  // Search for it in animcurve
                  _elementIns.xShift = 0;
                  _elementIns.yShift = 0;
                  // Now the scale too
                  _elementIns.xScaleShift = 1;
                  _elementIns.yScaleShift = 1;
				  _elementIns.eScaleShift = 1;
                  // Extra values
                  _elementIns.alphaShift = 1;
                  _elementIns.angleShift = 0;
                // Depth shift
                _elementIns.depthShift = 0;
            };
        });
        
        // set it up
        functionEnd();
    };
    
    static stepEvent = function () {
        switch (animType) {
            case eAnimAnimType.groupAnimcurve: case eAnimAnimType.groupKCurve:
                // Is not playing?
                if (!isPlaying)
                    { break; };
                // Update animation here
                animUpdate();
                // Is npaused>
                if (isPaused)
                    { break; };
				
                
				// Is linked to
				if ((linkValueTo != noone) && (linkType == eAnimLinkType.aValue || linkType == eAnimLinkType.aFull) && (linkValueTo.isPlaying)) {
					// Set it up
					animValue = linkValueTo.animValue;
					
				} else {
					
		            // Increase shift
		            animValue += animShift * animSpeed;
		            // Reaches max
		            if ((animValue > 1) && ((animShift * animSpeed) > 0)) {
		                switch (animLoopType) {
		                    case eAnimRepeatType.loop:
		                        while (animValue > 1) {
		                            // Set the first one
		                            animValue = animValue - 1;
									// set loop
									functionLoop();
		                        };
		                    break;
                        
		                    case eAnimRepeatType.endloop:
		                        // Set the last one
		                        animValue = 1;
		                        // Quit the playing animation
		                        animStop();
		                    break;
                        
		                    case eAnimRepeatType.backloop:
		                        // Set it up here
		                        animShift *= -1;
								
								functionBackloop();
		                    break;
		                };
		            };
		            // Reached min
		            if ((animValue < 0) && ((animShift * animSpeed) < 0)) {
		                switch (animLoopType) {
		                    case eAnimRepeatType.loop:
		                        while (animValue < 0) {
		                            // Set the last one
		                            animValue = 1 + animValue;
									// set loop
									functionLoop();
		                        };
		                    break;
                        
		                    case eAnimRepeatType.endloop:
		                        // Set the first one
		                        animValue = 0;
		                        // Quit the playing animation
		                        animStop();
		                    break;
                        
		                    case eAnimRepeatType.backloop:
		                        // Set it up here
		                        animShift *= -1;
								
								functionBackloop();
		                    break;
		                };
		            };
				};
                // while playing
                functionPlaying();
            break;
        };
    };
};

function eAnimAnimationSpriteCreate(_id, _animArray, _animSpeed, _animSType) constructor {
    
	eAnimDebugCreation("ANIMATION SPRITE");
	
	// As a name
    id = _id;
    parent = noone;
    type = eAnimType.animationSprite;
    
    mySelf = self;
    
	// Functions to control the animation here
	functionPlaying = function () { return };
    functionStart = function () { return; };
    functionEnd = function () { return; };
	functionBackloop = function () { return; };
	functionLoop = function () { return; };
	
    // Set up the array
    animThread = _animArray;
    // Set up the anim speed
    animSpeed = _animSpeed;
    
    animType = _animSType;
    
    static threadSet = function (_newThread) { animThread = _newThread; };
    
    static speedSet = function (_newSpeed) { animSpeed = _newSpeed; };
	
	static animSetFunctionStart = function (_newFunction) {
        
        functionStart = method(mySelf, _newFunction);
    };
    
    static animSetFunctionEnd = function (_newFunction) {
            
        functionEnd = method(mySelf, _newFunction);
    };
    
    static animSetFunctionPlaying = function (_newFunction) {
            
        functionPlaying = method(mySelf, _newFunction);
    };
	
	static animSetFunctionLoop = function (_newFunction) {
            
        functionLoop = method(mySelf, _newFunction);
    };
	
	static animSetFunctionBackloop = function (_newFunction) {
            
        functionBackloop = method(mySelf, _newFunction);
    };
};

/// @description Returns an array which contains all the sprites images index
function eAnimAnimThreadDefault(_spriteId) {
    
    var _returnArray = [];
    
    // And add here all the images of it
    for (var i = 0; i < sprite_get_number(_spriteId); i++) {
        // Set in there
        array_push(_returnArray, i);
    };
    
    return _returnArray;
};

/// @description Creates an sprite animation in which the thread and speeds corresponds to the sprite, and the ID is default
function eAnimAnimationSpriteCreateDefault(_spriteId, _id = "default") {
    
    // Create an animation sprite
    var _eAnimAnimSprite = new eAnimAnimationSpriteCreate(_id, eAnimAnimThreadDefault(_spriteId), sprite_get_speed(_spriteId), eAnimAnimSpriteType.loop);
    
    return _eAnimAnimSprite;
};

/// @description Creates an sprite which contains a "default" animation
function eAnimSpriteCreateDefault(_id, _x, _y, _spriteId, _depth) {
    // Create it
    var _eAnimSprite = new eAnimSpriteCreate(_id, _x, _y, _spriteId, _depth);
    _eAnimSprite.animAdd(eAnimAnimationSpriteCreateDefault(_spriteId));
    
    return _eAnimSprite;
};

function eAnimDrawStart() {
    // Clear up this
    ds_priority_clear(global._eAnimDepthList);
};

function eAnimTransitionStructMerge(_structA, _structB) {
	
	// conbine it
	var _newStruct = {
		
		x : x,
		y : y,
		
		xShift : xShift,
		yShift : yShift,
		
		xScale : xScale * xScaleShift,
		yScale : yScale * yScaleShift,
		eScale : eScale * eScaleShift,
		
		myDepth : myDepth + depthShift,
		alpha : alpha * alphaShift,
		angle : angle * angleShift
	};
};

function eAnimObjectPositionData(_objectId, _xOff, _yOff, _xScaleOff = 1, _yScaleOff = 1, _eScaleOff = 1, _angleOff = 0) {
	
	// this thing dude
    var _mainX, _mainY, _mainXScale, _mainYScale, _mainEScale, _mainAngle;
	_mainEScale = _eScaleOff * _objectId.eScale * _objectId.eScaleShift;
    _mainXScale = _xScaleOff * _objectId.xScale * _objectId.xScaleShift;
    _mainYScale = _yScaleOff * _objectId.yScale * _objectId.yScaleShift;
	
    _mainAngle = _angleOff + _objectId.angle + _objectId.angleShift;
    _mainX = _xOff + vector2XAngled(_objectId.xShift * _mainXScale * _mainEScale, _objectId.yShift * _mainYScale * _mainEScale, _mainAngle);
    _mainY = _yOff + vector2YAngled(_objectId.xShift * _mainXScale * _mainEScale, _objectId.yShift * _mainYScale * _mainEScale, _mainAngle);
	
	// set up the return struct
	var _returnStruct = {
		
		name : _objectId.id,
		type : _objectId.type,
		elements : { },
		
		x : _objectId.x,
		y : _objectId.y,
		
		xOff : _xOff,
		yOff : _yOff,
		
		xScale : _objectId.xScale,
		yScale : _objectId.yScale,
		eScale : _objectId.eScale,
		
		xScaleShift : _objectId.xScaleShift,
		yScaleShift : _objectId.yScaleShift,
		eScaleShift : _objectId.eScaleShift,
		
		xScaleOff : _xScaleOff,
		yScaleOff : _yScaleOff,
		eScaleOff : _eScaleOff,
		
		pseudoXScale : _objectId.xScale * _objectId.xScaleShift,
		pseudoYScale : _objectId.yScale * _objectId.yScaleShift,
		
		angle : _objectId.angle,
		angleShift : _objectId.angleShift,
		angleOff : _angleOff,
		
		psudoAngle : _objectId.angle + _objectId.angleShift,
		
		mainEScale : _mainEScale,
		mainXScale : _mainXScale,
		mainYScale : _mainYScale,
		
		mainAngle : _mainAngle,
		
		mainX : _mainX,
		mainY : _mainY
	};
	
	
	// get all elements of this object
    var _elementsName = struct_get_names(_objectId.elements);
    for (var i = 0; i < array_length(_elementsName); i++) {
        // Get element ID
        var _elementIns = struct_get(_objectId.elements, _elementsName[i]);
        switch (_elementIns.type) {
            
            case eAnimType.object:
				// s hidden?
				if (_elementIns.hide) { break; };
				// send it
                _returnStruct.elements[$ _elementIns.id] = eAnimObjectPositionData(_elementIns,
                                _mainX + vector2XAngled(_elementIns.x * _mainXScale * _mainEScale, _elementIns.y * _mainYScale * _mainEScale, _mainAngle),
                                _mainY + vector2YAngled(_elementIns.x * _mainXScale * _mainEScale, _elementIns.y * _mainYScale * _mainEScale, _mainAngle),
                                _mainXScale,
                                _mainYScale,
								_mainEScale,
                                _mainAngle,
                );
            break;
            
            case eAnimType.sprite:
				// s hidden?
				if (_elementIns.hide) { break; };
				var _usingX, _usingY, _usingXScale, _usingYScale, _usingAngle, _usingAlpha, _usingDepth;
				//_usingX = 
				
				
                // Get the variables here
                var _sprX, _sprY, _sprXScale, _sprYScale, _sprAngle, _sprAlpha, _sprDepth;
                _sprX = _mainX + vector2XAngled((_elementIns.x + _elementIns.xShift) * _mainXScale * _mainEScale, (_elementIns.y + _elementIns.yShift) * _mainYScale * _mainEScale, _mainAngle);
                _sprY = _mainY + vector2YAngled((_elementIns.x + _elementIns.xShift) * _mainXScale * _mainEScale, (_elementIns.y + _elementIns.yShift) * _mainYScale * _mainEScale, _mainAngle);
                _sprXScale = _elementIns.xScale * _elementIns.xScaleShift * _elementIns.eScale * _elementIns.eScaleShift * _mainXScale * _mainEScale;
                _sprYScale = _elementIns.yScale * _elementIns.yScaleShift * _elementIns.eScale * _elementIns.eScaleShift * _mainYScale * _mainEScale;
                _sprAngle = _elementIns.angle + _elementIns.angleShift + _mainAngle;
                
				
                // Set up
				_returnStruct.elements[$ _elementIns.id] = {
					
					name : _elementIns.id,
					type : _elementIns.type,
					elements : { },
					
					x : _elementIns.x,
					y : _elementIns.y,
					
					xOff : _mainX,
					yOff : _mainY,
					
					xScale : _elementIns.xScale,
					yScale : _elementIns.yScale,
					eScale : _elementIns.eScale,
					
					xScaleShift : _elementIns.xScaleShift,
					yScaleShift : _elementIns.yScaleShift,
					eScaleShift : _elementIns.eScaleShift,
					
					xScaleOff : _mainXScale,
					yScaleOff : _mainYScale,
					eScaleOff : _mainEScale,
					
					pseudoXScale : _elementIns.xScale * _elementIns.xScaleShift,
					pseudoYScale : _elementIns.yScale * _elementIns.yScaleShift,
					
					angle : _elementIns.angle,
					angleShift : _elementIns.angleShift,
					angleOff : _mainAngle,
					
					psudoAngle : _elementIns.angle + _elementIns.angleShift,
					
					mainEScale : _mainEScale,
					mainXScale : _mainXScale,
					mainYScale : _mainYScale,
					
					mainAngle : _sprAngle,
					
					mainX : _sprX,
					mainY : _sprY
				};
                // loop for internal animations
				var _sprAnimations = _elementIns.elements;
				var _sprAnimNames = struct_get_names(_sprAnimations);
				for (var n = 0; n < array_length(_sprAnimNames); n++) {
					
					var _animId = _sprAnimations[$ _sprAnimNames[n]];
					// Set up
					_returnStruct.elements[$ _elementIns.id].elements[$ _sprAnimNames[n]] = {
						
						name : _animId.id,
						type : _animId.type,
						
						id : _animId.mySelf,
						
						animThread : _animId.animThread,
						animSpeed : _animId.animSpeed,
						animType : _animId.animType
					};
				};
				
            break;
        };
    };
	
	return _returnStruct;
};

function eAnimObjectDrawOrder(_objectId, _xOff, _yOff, _xScaleOff = 1, _yScaleOff = 1, _eScaleOff = 1, _angleOff = 0, _alphaOff = 1, _depthOff = 0,
							 _pTValue = 1, _pTStruct = { }) {
    
	var _tV = 0;
	// has transition?
	if ((!_objectId.transition) || (_objectId.transitionValue > 1)) {
		// no
		_tV = 1;
	} else {
		// yes
		_tV = _objectId.transitionAnimValue;
	};
	// update here
	_tV *= _pTValue;
	
	var _tX, _tY, _tXScale, _tYScale, _tEScale, _tAngle, _tAlpha, _tDepth, _tStruct;
	// construct the struct from parent one
	
	
	// set up
	_tXScale = _objectId.transitionXScale;
	_tYScale = _objectId.transitionYScale;
	_tEScale = _objectId.transitionEScale;
	// set up
	_tAngle = _objectId.transitionAngle;
	_tAlpha = _objectId.transitionAlpha;
	_tDepth = _objectId.transitionDepth;
	
	// positions
	_tX = _objectId.transitionX + vector2XAngled(	_objectId.transitionXShift * _tXScale * _tEScale,
													_objectId.transitionYShift * _tYScale * _tEScale, _tAngle);
	_tY = _objectId.transitionY + vector2YAngled(	_objectId.transitionXShift * _tXScale * _tEScale,
													_objectId.transitionYShift * _tYScale * _tEScale, _tAngle);
	
	
	// this thing dude
    var _mainX, _mainY, _mainXScale, _mainYScale, _mainEScale, _mainAngle, _mainAlpha, _mainDepth;
	_mainEScale = _eScaleOff * _objectId.eScale * _objectId.eScaleShift;
    _mainXScale = _xScaleOff * _objectId.xScale * _objectId.xScaleShift;
    _mainYScale = _yScaleOff * _objectId.yScale * _objectId.yScaleShift;
	
    _mainAngle = _angleOff + _objectId.angle + _objectId.angleShift;
    _mainAlpha = _alphaOff * _objectId.alpha * _objectId.alphaShift;
    _mainX = _xOff + vector2XAngled(_objectId.xShift * _mainXScale * _mainEScale, _objectId.yShift * _mainYScale * _mainEScale, _mainAngle);
    _mainY = _yOff + vector2YAngled(_objectId.xShift * _mainXScale * _mainEScale, _objectId.yShift * _mainYScale * _mainEScale, _mainAngle);
    _mainDepth = _objectId.depthShift + _depthOff;
	
	// and update for transition
	_mainXScale = lerp(_tXScale, _mainXScale, _tV);
	_mainYScale = lerp(_tYScale, _mainYScale, _tV);
	_mainEScale = lerp(_tEScale, _mainEScale, _tV);
	// positions
	_mainX = lerp(_tX, _mainX, _tV);
	_mainY = lerp(_tY, _mainY, _tV);
	// other
	_mainAngle	 = lerp(_tAngle, _mainAngle, _tV);
	_mainAlpha	 = lerp(_tAlpha, _mainAlpha, _tV);
	_mainDepth	 = lerp(_tDepth, _mainDepth, _tV);
	
    
    
    // get all elements of this object
    var _elementsName = struct_get_names(_objectId.elements);
    for (var i = 0; i < array_length(_elementsName); i++) {
        // Get element ID
        var _elementIns = struct_get(_objectId.elements, _elementsName[i]);
        switch (_elementIns.type) {
            
            case eAnimType.object:
				// s hidden?
				if (_elementIns.hide) { break; };
				// send it
                eAnimObjectDrawOrder(_elementIns,
                                _mainX + vector2XAngled(_elementIns.x * _mainXScale * _mainEScale, _elementIns.y * _mainYScale * _mainEScale, _mainAngle),
                                _mainY + vector2YAngled(_elementIns.x * _mainXScale * _mainEScale, _elementIns.y * _mainYScale * _mainEScale, _mainAngle),
                                _mainXScale,
                                _mainYScale,
								_mainEScale,
                                _mainAngle,
                                _mainAlpha,
                                _mainDepth,
								_tV,
                );
            break;
            
            case eAnimType.sprite:
				// s hidden?
				if (_elementIns.hide) { break; };
				var _usingX, _usingY, _usingXScale, _usingYScale, _usingAngle, _usingAlpha, _usingDepth;
				//_usingX = 
				
				
                // Get the variables here
                var _sprX, _sprY, _sprXScale, _sprYScale, _sprAngle, _sprAlpha, _sprDepth;
                _sprX = _mainX + vector2XAngled((_elementIns.x + _elementIns.xShift) * _mainXScale * _mainEScale, (_elementIns.y + _elementIns.yShift) * _mainYScale * _mainEScale, _mainAngle);
                _sprY = _mainY + vector2YAngled((_elementIns.x + _elementIns.xShift) * _mainXScale * _mainEScale, (_elementIns.y + _elementIns.yShift) * _mainYScale * _mainEScale, _mainAngle);
                _sprXScale = _elementIns.xScale * _elementIns.xScaleShift * _elementIns.eScale * _elementIns.eScaleShift * _mainXScale * _mainEScale;
                _sprYScale = _elementIns.yScale * _elementIns.yScaleShift * _elementIns.eScale * _elementIns.eScaleShift * _mainYScale * _mainEScale;
                _sprAngle = _elementIns.angle + _elementIns.angleShift + _mainAngle;
                _sprAlpha = _elementIns.alpha * _elementIns.alphaShift * _mainAlpha;
                _sprDepth = _elementIns.myDepth + _elementIns.depthShift + _mainDepth;
                
				
                // Add to priority list
                ds_priority_add(global._eAnimDepthList,
                    [ _elementIns.spriteId, _elementIns.animIndex,
                                            _sprX, _sprY,
                                            _sprXScale, _sprYScale,
                                            _sprAngle, c_white, _sprAlpha ],
                    _sprDepth);
                
            break;
        };
    };
};

function eAnimDrawEnd() {
    
    // Get the size of the priority list
    var _sizeOfDepth = ds_priority_size(global._eAnimDepthList);
    // Read each of them
    repeat (_sizeOfDepth) {
        // Set the priority value
        var _toDrawSprite = ds_priority_delete_max(global._eAnimDepthList);
        // Draw the sprite
        draw_sprite_ext(_toDrawSprite[0], _toDrawSprite[1],
                        _toDrawSprite[2], _toDrawSprite[3],
                        _toDrawSprite[4], _toDrawSprite[5],
                        _toDrawSprite[6], _toDrawSprite[7], _toDrawSprite[8]);
    };
    
    // Clear the list
    ds_priority_clear(global._eAnimDepthList);
}






