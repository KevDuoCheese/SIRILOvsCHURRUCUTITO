

function aeLoadInAnimCurve(_struct) {

// create the return struct
var _animCurve = new kesoAnimCurve(_struct.name); 
// look up for channels
var _channels = _struct.channels;
// loop for them
for (var i = 0; i < array_length(_channels); i++) {
	// set it up here
	var _channelId = _channels[i];
	
	// create a channel here
	var _channelCreate = new kesoAnimCurveChannel(_channelId.name, 0, 0, _channelId.pointType);
	// get teh points
	var _points = _channelId.points;
	var _newPoints = [];
	// change them all
	for (var n = 0; n < array_length(_points); n++) {
		
		// ooginal
		var _pointOc = _points[n];
		// create a point
		var _pointIns = new kesoAnimCurvePoint(_pointOc.name, _pointOc.x, _pointOc.y, _pointOc.pointType); 
		
		// set up variables
		_pointIns.lPY = _pointOc.lPY;
		_pointIns.lPX = _pointOc.lPX;
		
		_pointIns.rPY = _pointOc.rPY;
		_pointIns.rPX = _pointOc.rPX;
		
		_pointIns.xMax = _pointOc.xMax;
		_pointIns.xMin = _pointOc.xMin;
		
		_pointIns.lockedX = _pointOc.lockedX;
		
		// and parent
		_pointIns.parent = _channelCreate;
		// push in
		array_push(_newPoints, _pointIns);
	};
	
	// copy limits
	_channelCreate.limitTop = _channelId.limitTop;
	_channelCreate.limitBottom = _channelId.limitBottom;
	
	// set points to channel
	_channelCreate.points = _newPoints;
	// add channel to animation curve
	_animCurve.channelAdd(_channelCreate);
};

return _animCurve;

};

function aeLoadGeneral(_struct) {
	
	// loop here
	global._eAnimLoad = [ ];
	
	// load here
	var _loadedElements = aeLoadElements(_struct);
	
	// loop for all
	for (var i = 0; i < array_length(global._eAnimLoad); i++) {
		
		// get the parent
		var _ocParent = global._eAnimLoad[i][0];
		// get the array
		var _ocArray = global._eAnimLoad[i][1];
		
		var _newArray = [ ];
		// loop
		for (var n = 0; n < array_length(_ocArray); n++) {
			
			// get the children tree
			var _childrenTree = _ocArray[n];
			var _lastOpened = _loadedElements;
			var _loadingItems = 0;
			
			var _childrenTotal = array_length(_childrenTree);
			// open it
			for (var w = 0; w < _childrenTotal; w++) {
				
				// search for it
				if (!struct_exists(_lastOpened, _childrenTree[w])) { break; };
				
				// is the last one?
				if (w == (_childrenTotal - 1)) {
					
					// mention the last one
					_lastOpened = _lastOpened[$ _childrenTree[w]];
					
				} else {
					
					// keep looping in
					_lastOpened = _lastOpened[$ _childrenTree[w]].elements;
				};
				
				
				// increase
				_loadingItems++;
			};
			
			// reached it
			if (_loadingItems == array_length(_childrenTree)) {
				
				// add to it
				array_push(_newArray, _lastOpened.mySelf);
				// set last openned link
				_lastOpened.linkValueTo = _ocParent;
			};
		};
		// set the parent link children
		_ocParent.linkChildren = _newArray;
	};
	
	return _loadedElements;
};

function aeLoadIn(_struct, _parent = noone) {
	
	var _returnStruct = { };
	
	// get the the type we're handling
	var _type = _struct.type;
	// search for it
	var _trueType = arrayFind(global._eAnimTypeTranslation, _type);
	var _structNames = struct_get_names(_struct);
	// switch the type
	switch (_trueType) {
		
		case eAnimType.object:
			
			// create the object in parent
			_returnStruct = new eAnimObjectCreate(_struct.id, _struct.x, _struct.y);
			
		break;
		
		case eAnimType.sprite:
			
			// create the object in parent
			_returnStruct = new eAnimSpriteCreate(_struct.id, _struct.x, _struct.y, asset_get_index(_struct.spriteId), _struct.myDepth);
			
		break;
		
		case eAnimType.animation:
			
			// create the object in parent
			_returnStruct = new eAnimAnimationCreate(_struct.id, _struct.animType, aeLoadInAnimCurve(_struct.mainCurve), _struct.hideNotMentioned, _struct.animLoopType);
			
		break;
		
		case eAnimType.animationSprite:
			
			// create the object in parent
			_returnStruct = new eAnimAnimationSpriteCreate(_struct.id, _struct.animThread, _struct.animSpeed, _struct.animType);
			
		break;
	};
	// set the parent
	_returnStruct.parent = _parent;
	
	// loop to set all the variables
	for (var i = 0; i < array_length(_structNames); i++) {
		
		// get th variable
		var _varIns = _struct[$ _structNames[i]];
		var _varName = _structNames[i];
		
		// is elements
		if (_varName == "elements") {
			
			show_debug_message("LOADING ELEMENTS FOR \"" + string(_returnStruct.id) + "\"")
			_returnStruct.elements = aeLoadElements(_varIns, _returnStruct);
			continue;
		};
		// myself
		if (_varName == "mySelf") { continue; };
		// save up parent
		if (_varName == "parent") { continue; };
		// avoid it
		if (_varName == "type") { continue; };
		
		var _avoid = false;
		
		// what the fuck it is
		switch (_trueType) {
			
			case eAnimType.sprite:
				// the name
				switch (_varName) {
					case "spriteId":
						// search up name
						_returnStruct[$ _varName] = asset_get_index(_varIns);
						_avoid = true;
					break;
				};
			break;
			
			case eAnimType.animation:
				// the name
				switch (_varName) {
					case "mainCurve":
						// search up name
						//_returnStruct[$ _varName] = aeLoadInAnimCurve(_varIns);
						_avoid = true;
					break;
					
					case "linkChildren":
						
						// add to it
						array_push(global._eAnimLoad, [ _returnStruct, _varIns ]);
						_avoid = true;
						
					break;
				};
			break;
		};
		
		// do?
		if (_avoid) { continue; };
		// not?
		if (!_avoid) { _returnStruct[$ _varName] = _varIns; continue; };
	};
	
	return _returnStruct;
};

function aeSaveElements(_structElements) {

var _returnStruct = { };

// loop for all
var _elementsName = struct_get_names(_structElements);
for (var n = 0; n < array_length(_elementsName); n++) {
				
	// set it up
	_returnStruct[$ _elementsName[n]] = aeSaveIn(_structElements[$ _elementsName[n]]);
};

return _returnStruct;

};

function aeLoadElements(_structElements, _parent = noone) {

var _returnStruct = { };

// loop for all
var _elementsName = struct_get_names(_structElements);
for (var n = 0; n < array_length(_elementsName); n++) {
	
	show_debug_message("LOADING ELEMENT \"" + _elementsName[n] + "\"");
	// set it up
	_returnStruct[$ _elementsName[n]] = aeLoadIn(_structElements[$ _elementsName[n]], _parent);
};

return _returnStruct;

};

function aeSaveIn(_struct) {
	
	// srt it
	var _returnStruct = {  };
	
	// get the the type we're handling
	var _type = _struct.type;
	var _structNames = struct_get_names(_struct);
	
	
	// loop for it
	for (var i = 0; i < array_length(_structNames); i++) {
		
		// get th variable
		var _varIns = _struct[$ _structNames[i]];
		var _varName = _structNames[i];
		
		// is that fucker
		if (is_method(_varIns)) { continue; };
		
		// is elements
		if (_varName == "elements") {
			
			_returnStruct.elements = aeSaveElements(_varIns);
			continue;
		};
		// myself
		if (_varName == "mySelf") { _returnStruct[$ _varName] = "SELF"; continue; };
		// save up parent
		if (_varName == "parent") { _returnStruct[$ _varName] = "PARENT"; continue; };
		
		var _avoid = false;
		
		// what the fuck it is
		switch (_type) {
			
			case eAnimType.sprite:
				// the name
				switch (_varName) {
					case "spriteId":
						// search up name
						_returnStruct[$ _varName] = sprite_get_name(_varIns);
						_avoid = true;
					break;
				};
			break;
			
			case eAnimType.animation:
				// the name
				switch (_varName) {
					case "linkChildren":
						
						// save up here
						_returnStruct[$ _varName] = [ ];
						// loop values
						for (var n = 0; n < array_length(_varIns); n++) {
							
							// get the children tree
							array_push(	_returnStruct[$ _varName],
										ob_animation_editor.objectGetTree(_varIns[n]));
						};
						_avoid = true;
					break;
				};
			break;
		};
		
		// do?
		if (_avoid) { continue; };
		// not?
		if (!_avoid) { _returnStruct[$ _varName] = _varIns; continue; };
	};
	
	// save the type
	_returnStruct.type = global._eAnimTypeTranslation[_type];
	
	return _returnStruct;
};

function aeInputSelectedElement(_name, _posUIVec2, _sizeUIVec2, _variableModifier = "", 
								_backText = "", _backTextWidth = 0, _helpText = "", _initText = "", 
								_characterLimit = 50, _inputType = KUI_INPUT_TYPE.stringType, 
								_hAlign = fa_left, _vAlign = fa_middle, 
								_backColor = c_black, 
								_changeValidationFunction = function (_newValue) { return true }, _afterChangeFunction = function () { },
								_keyframeAble = false, _keyframeModifier = "") :
			kuiInputText(_name, _posUIVec2, _sizeUIVec2, _backText, _backTextWidth, _helpText, _initText, _characterLimit, false, _inputType, kuiDCall, _hAlign, _vAlign, kuiDCall, _backColor, fa_left, fa_middle) constructor {
	
	variableModifier = _variableModifier;
	changeValidationFunction = method(mySelf, _changeValidationFunction);
	afterChangeFunction = method(mySelf, _afterChangeFunction);
	
	// set callback
	callback = method(mySelf, function () {
		
		// set it
		if (ob_animation_editor.objectSelectedExists()) {
			// get the data
			var _oId = ob_animation_editor.objectSelectedGetId();
			// according to type
			switch (inputType) {
				
				case KUI_INPUT_TYPE.integerType: case KUI_INPUT_TYPE.floatType:
					
					// set it
					if (changeValidationFunction(storedNumber)) { struct_set(_oId, variableModifier, storedNumber); afterChangeFunction(); };
					
				break;
				
				case KUI_INPUT_TYPE.stringType:
					
					// set it
					if (changeValidationFunction(textIn)) { struct_set(_oId, variableModifier, textIn); afterChangeFunction(); };
					
				break;
			};
		};
	});
	
	setNoInputControl(function () {
		
		// set it
		if (ob_animation_editor.objectSelectedExists()) {
			// get the data
			var _oId = ob_animation_editor.objectSelectedGetId();
			
			// according to type
			switch (inputType) {
				
				case KUI_INPUT_TYPE.integerType: case KUI_INPUT_TYPE.floatType:
					
					// set it
					storedNumber = struct_get(_oId, variableModifier);
					
				break;
				
				case KUI_INPUT_TYPE.stringType:
					
					// set it
					textIn = struct_get(_oId, variableModifier);
				break;
			};
		};
	});
};