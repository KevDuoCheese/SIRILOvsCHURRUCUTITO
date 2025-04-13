
enum algType {
	constant,
	variable,
	monomial,
	polynomial,
	fraction,
	root
};

global.resolveHere = "";

function algCore(powerTo = 1) constructor {
	
	mySelf = self;
	type = -1;
	
	// this can be any monomium, a variable, constant, or anything (1 means that is just one)
	powerV = powerTo;
	
	reduceCheck = function () {
		
		
	};
	
	static reduceCheckCall = function () {
		// check on power
		if (!algIsConstant(powerV)) {
			powerV.reduceCheckCall();
		};
		
		// do the reduce check
		reduceCheck();
	};
};

function algCompareTypes(_elementA, _elementB, _typeA, _typeB) {
	
	// is one or anything like that
	if (is_real(_elementA)) { _elementA = { type : algType.constant }; };
	if (is_real(_elementB)) { _elementB = { type : algType.constant }; };
	// return it
	return (((_elementA.type == _typeA) && (_elementB.type == _typeB)) || ((_elementA.type == _typeB) && (_elementB.type == _typeA)));
}; 

/// @description check if it is
function algCheck(_element) {
	// is one
	if (is_real(_element)) {
		// set it up as a constant
		_element = new algConstant(1); 
	};
	
	return _element;
};

function algCompareEqual(_elementA, _elementB) {
	// one is constant and other 1?
	if (algIsConstant(_elementA) || algIsConstant(_elementB)) {
		// check out for it
		return algGetConstantValue(_elementA) == algGetConstantValue(_elementB);
	} else {
		// return a literal comparison
		return _elementB == _elementA;
	};
};

function algIsConstant(_element) {
	
	// is it?
	return ((is_struct(_element) && _element.type == algType.constant) || is_real(_element));
};

function algGetConstantValue(_element) {
	// is one?
	if (is_real(_element)) { return _element; };
	
	return _element.constantV;
};

function algComplexString(_complex) {
	// get the first part
	var _resolveP = "";
	
	// both are 0
	if (_complex[0] == 0 && _complex[1] == 0) { return "0"; };
	
	// check out
	if (_complex[0] != 0) { _resolveP += stringFormatDecimal(_complex[0], 5); };
	// show it
	if (_complex[0] != 0 && _complex[1] != 0) { _resolveP += (_complex[1] > 0) ? " + " : " - "; };
	// check out
	if (_complex[1] != 0) { _resolveP += stringFormatDecimal(abs(_complex[1]), 5) + "i"; };
	
	return _resolveP;
};

/// @description return the root of the numbers (n answers)
function algComplexNumberRoot(_complex, _rootIndex) {
	
	var _real, _imaginary;
	_real = _complex[0];
	_imaginary = _complex[1];
	
	// get teh angle
	var _zAngle = algComplexNumberAngle(_complex);
	// get the radio
	var _zAbs = algComplexNumberAbs(_complex);
	
	// return it all
	var _roots = [];
	var _newImg, _newReal, _newAbs;
	for (var i = 1; i <= _rootIndex; i++) {
		_newImg = sin((_zAngle + (2 * (pi * i))) / _rootIndex);
		_newReal = cos((_zAngle + (2 * (pi * i))) / _rootIndex);
		_newAbs = power(_zAbs, 1 / _rootIndex);
		
		var _newComplex = algComplexNumberCreate(_newReal * _newAbs, _newImg * _newAbs);
		// add it
		array_push(_roots, _newComplex);
	};
	var _adjustPrincipal = false;
	// find the "principal" root
	for (var i = 0; i < _rootIndex; i++) {
		// found an only real
		if (_roots[i][1] == 0) {
			// copy this one
			var _ocThing = [];
			array_copy(_ocThing, 0, _roots, i, 1);
			// copy here
			array_copy(_roots, i, _roots, 0, 1);
			// and set it again
			array_copy(_roots, 0, _ocThing, 0, 1);
			
			_adjustPrincipal = true;
			break;
		};
	};
	// here
	if (!_adjustPrincipal) {
		// find the "principal" root, again
		for (var i = 0; i < _rootIndex; i++) {
			// found an only imaginry
			if (_roots[i][0] == 0) {
				// copy this one
				var _ocThing = [];
				array_copy(_ocThing, 0, _roots, i, 1);
				// copy here
				array_copy(_roots, i, _roots, 0, 1);
				// and set it again
				array_copy(_roots, 0, _ocThing, 0, 1);
				
				_adjustPrincipal = true;
				break;
			};
		};
	};
	
	// find the "principal" root, again
	//for (var i = 0; i < _rootIndex; i++) {
		
		//show_debug_message("		" + string(_rootIndex) + " root " + string(i + 1) + " of " + algComplexString(_complex) + ": " + algComplexString(_roots[i]));
	//};
	
	return _roots;
};
/// @description return the square root of the complex number (2 anwsers
function algComplexNumberSqrt(_complex) {
	
	var _real, _imaginary;
	_real = _complex[0];
	_imaginary = _complex[1];
	
	// get the mod
	var _absOfZ = sqrt(power(_real, 2) + power(_imaginary, 2));
	// and calculate it
	var _termA = sqrt(_absOfZ + _real) / 2;
	var _termB = sign(_imaginary) * sqrt(_absOfZ - _real) / 2;
	// return the two values
	return [ [ _termA, _termB ], [ -_termA, -_termB ] ];
	
};

/// @description return the N power of the complex
function algComplexNumberPower(_complex, _powerV) {
	
	var _real, _imaginary;
	_real = _complex[0];
	_imaginary = _complex[1];
	// get teh angle
	var _zAngle = algComplexNumberAngle(_complex);
	// get the radio
	var _zAbs = power(algComplexNumberAbs(_complex), _powerV);
	
	// show it here
	//if (!(algIsConstant(_powerV) && algGetConstantValue(_powerV) == 1)) { global.resolveHere += " ^ " + string(_powerV); };
	
	var _resultHere = algComplexNumberCreate(cos(_zAngle * _powerV) * _zAbs, sin(_zAngle * _powerV) * _zAbs);
	
	//show_debug_message("		power " + string(_powerV) + " of " + algComplexString(_complex) + ": " + algComplexString(_resultHere));
	
	// return it
	return _resultHere;
};

/// @description return a complex number
function algComplexNumberCreate(_real, _imaginary) {
	// return it bitch
	return [ _real, _imaginary ];
};
/// @description absolute value of number
function algComplexNumberAbs(_complex) { return sqrt(power(_complex[0], 2) + power(_complex[1], 2)); };
/// @description angle value of number
function algComplexNumberAngle(_complex) {
	// is 0
	//if (_complex[0] == 0) { return (_complex[1] < 0) ? (-pi / 2) : (pi / 2); };
	
	return degtorad(point_direction(0, 0, _complex[0], -_complex[1])); //arctan(_complex[1] / _complex[0]);
};

function algComplexNumberDivide(_complexTop, _complexBottom) {
	var _absBottom = power(algComplexNumberAbs(_complexBottom), 2);
	
	// rrturn it
	return algComplexNumberCreate(((_complexTop[0] * _complexBottom[0]) + (_complexTop[1] * _complexBottom[1])) / _absBottom,
								((_complexTop[1] * _complexBottom[0]) - (_complexTop[0] * _complexBottom[1])) / _absBottom);
};

function algComplexNumberMultiply(_complexA, _complexB) {
	
	// rrturn it
	return algComplexNumberCreate((_complexA[0] * _complexB[0]) - (_complexA[1] * _complexB[1]),
								(_complexA[0] * _complexB[1]) + (_complexA[1] * _complexB[0]));
};

function algComplexMultiplyInverse(_complex) { return algComplexNumberMultiply(algComplexNumberCreate(1, 0), _complex); };

function algComplexAddInverse(_complex) { return algComplexNumberCreate(-_complex[0], -_complex[1]); };
/// @description increase between two numbers
function algComplexNumberAdd(_complexA, _complexB) { return algComplexNumberCreate(_complexA[0] + _complexB[0], _complexA[1] + _complexB[1]); };
/// @description decrease between two numbers
function algComplexNumberRest(_complexA, _complexB) { return algComplexNumberAdd(_complexA, algComplexAddInverse(_complexB)); };

function algResolveConvertPower(_powerV, _variablesStruct) {
	
	// Convert power to a constant number, whatever it is
	var _resolveHere = algResolve(_powerV, _variablesStruct)[0];
	
	return _resolveHere;
};

function algGetTypeString(_element) {
	// is constant?
	if (algIsConstant(_element)) { return string(algGetConstantValue(_element)); };
	// switch types 
	switch (_element.type) {
		case algType.fraction: return "Fraction";
		
		case algType.monomial: return "Monomial";
		
		case algType.polynomial: return "Polynomial";
		
		case algType.root: return "Root";
		
		case algType.variable: return "Variable, " + string(_element.name);
	};
	
	return "WTF is this.";
};



/// @description Resolving here
function algResolve(_element, _variablesStruct) {
	
	//show_debug_message(algGetTypeString(_element));
	
	// is constant?
	if (algIsConstant(_element)) {
		
		//global.resolveHere += string(algGetConstantValue(_element));
		
		return algComplexNumberCreate(algGetConstantValue(_element), 0);
	};
	
	
	// switch types 
	switch (_element.type) {
		
		case algType.fraction:
			//show_debug_message("{ A / B: ");
			
			//global.resolveHere += "(";
			var _resolvedTop = algResolve(_element.topPart, _variablesStruct);
			
			
			//show_debug_message("/");
			//global.resolveHere += ") / (";
			
			
			var _resolvedBottom = algResolve(_element.bottomPart, _variablesStruct);
			//global.resolveHere += ")";
			
			var _resultVar = algComplexNumberDivide(_resolvedTop, _resolvedBottom);
			
			//show_debug_message("}");
			
			
			_resultVar = algComplexNumberPower(_resultVar, algResolveConvertPower(_element.powerV, _variablesStruct));
			// return it
			return _resultVar;
		
		case algType.monomial:
			//show_debug_message("{ M(): ");
			// get the constant
			var _constantV = algResolve(_element.constantV, _variablesStruct);
			
			//global.resolveHere += ".";
			
			// create en empty
			var _resultVar = algComplexNumberCreate(1, 0);
			// the variables
			for (var i = 0; i < array_length(_element.variables); i++) {
				// get var element
				var _varElement = algResolve(_element.variables[i], _variablesStruct);
				
				// multiply among numbers
				_resultVar = algComplexNumberMultiply(_resultVar, _varElement);
				
				//show_debug_message("x");
				//if (i < (array_length(_element.variables) - 1)) { show_debug_message("+"); global.resolveHere += "."; };
			};
			
			// power up
			_resultVar = algComplexNumberPower(_resultVar, algResolveConvertPower(_element.powerV, _variablesStruct));
			// multiply
			_resultVar = algComplexNumberMultiply(_resultVar, _constantV);
			
			//show_debug_message("MONIMIAL " + string(algGetConstantValue(_element.constantV)) + " :" + algComplexString(_resultVar));
			
			//show_debug_message("}");
			
		return _resultVar;
			
		case algType.polynomial:
			//show_debug_message("{ P(): ");
			//global.resolveHere += "(";
			
			// create en empty
			var _resultVar = algComplexNumberCreate(0, 0);
			// add between polynomials
			for (var i = 0; i < array_length(_element.monomials); i++) {
				// get var element
				var _varElement = algResolve(_element.monomials[i], _variablesStruct);
				
				// add among numbers
				_resultVar = algComplexNumberAdd(_resultVar, _varElement);
				
				//if (i < (array_length(_element.monomials) - 1)) { show_debug_message("+"); global.resolveHere += "+"; };
			};
			// power up
			_resultVar = algComplexNumberPower(_resultVar, algResolveConvertPower(_element.powerV, _variablesStruct));
			
			//global.resolveHere += ")";
			//show_debug_message("}");
			
		return _resultVar;
		
		case algType.root:
			//show_debug_message("{ Root: ");
			//global.resolveHere += "√" + string(algResolveConvertPower(_element.rootN, _variablesStruct)) + "(";
			
			// get the thing inside
			var _expression = algResolve(_element.expression, _variablesStruct);
			// root
			_expression = algComplexNumberRoot(_expression, algResolveConvertPower(_element.rootN, _variablesStruct))[0];
			
			//global.resolveHere += ")";
			// power up
			_expression = algComplexNumberPower(_expression, algResolveConvertPower(_element.powerV, _variablesStruct));
			
			//show_debug_message("}");
			
		return _expression;
		
		case algType.variable:
			//show_debug_message("Value: ");
			// add it
			//global.resolveHere += _element.name;
			
			// name of the variable
			switch (_element.name) {
				
				case "i":
					
					// create a number
					return algComplexNumberPower(algComplexNumberCreate(0, 1), algResolveConvertPower(_element.powerV, _variablesStruct));
				break;
				
				case "pi":
					// create a number
					return algComplexNumberPower(algComplexNumberCreate(pi, 0), algResolveConvertPower(_element.powerV, _variablesStruct));
				break;
				
				default:
					// create a number
					return algComplexNumberPower(
								algComplexNumberCreate(
									algResolve(structRead(_variablesStruct, _element.name, 1), _variablesStruct)[0],
									0),
								algResolveConvertPower(_element.powerV, _variablesStruct));
				break;
			};
		break;
	};
};

/// @description An especific number
function algConstant(numberValue, powerTo = 1) : algCore(powerTo) constructor {
	type = algType.constant;
	
	// the number value of the constant itself
	constantV = numberValue;
};

/// @description A variable entity
function algVariable(varName, powerTo = 1) : algCore(powerTo) constructor {
	type = algType.variable;
	// the name of the variable itself
	name = varName;
};

/// @description Forms from a variable and a constant, variable can be an element or array of elements, A FRACTION IS A VARIABLE HERE
function algMonomial(variableTo, constantTo = 1, powerTo = 1) : algCore(powerTo) constructor {
	type = algType.monomial;
	
	// the variables inside
	variables = [ ];
	
	// is not array?
	if (!is_array(variableTo)) { variableTo = [ variableTo ]; };
	// read it
	for (var i = 0; i < array_length(variableTo); i++) {
		
		// set in
		array_push(variables, variableTo[i]);
	};
	
	// can be a constant
	constantV = constantTo;
	
	// and do this
	reduceCheck = method(mySelf, function () {
		// no need to check for constant, should be already a constant
		
		// llop for variables
		for (var i = 0; i < array_length(variables); i++) {
			// check for it
			if (!algIsConstant(variables[i])) {
				variables[i].reduceCheckCall();
			};
		};
	});
};

/// @description Top and bottom can be anything
function algFraction(_topPart, _bottomPart, powerTo = 1) : algCore(powerTo) constructor {
	type = algType.fraction;
	
	// set up
	topPart = _topPart;
	bottomPart = _bottomPart;
	
	// and do this
	reduceCheck = method(mySelf, function () {
		// reduce top and bottom
		if (!algIsConstant(topPart)) { topPart.reduceCheckCall(); };
		if (!algIsConstant(bottomPart)) { bottomPart.reduceCheckCall(); };
		
		// compare
		if (algCompareTypes(topPart, bottomPart, algType.monomial, algType.monomial)) {
			// concidences
			var _varCoincidences = [ ];
			
			// compare variables
			for (var i = 0; i < array_length(topPart.variables); i++) {
				// and here
				for (var n = 0; n < bottomPart.variables; n++) {
					// is the same?
					array_push(_varCoincidences,
						[ i, n ]
					);
				};
			};
			// compare exponents
			for (var i = 0; i < array_length(_varCoincidences); i++) {
				var _varName = _varCoincidences[i];
				
				// get the exponent
				var _varExponentTop		 = topPart.variables[$ _varName[i]].powerTo;
				var _varExponentBottom	 = bottomPart.variables[$ _varName[n]].powerTo;
				
				// are the same
				if (_varExponentBottom == _varExponentTop) {
					// no exponeents
					topPart.variables[$ _varName[i]].powerTo	 = 0;
					bottomPart.variables[$ _varName[n]].powerTo	 = 0;
				} else
				// are the two monomials
				if (algCompareTypes(_varExponentTop, _varExponentBottom, algType.monomial, algType.monomial)) {
					
				} else
				// are constant
				if (algCompareTypes(_varExponentTop, _varExponentBottom, algType.constant, algType.constant)) {
					// gwt thw constant value
					var _diffVar = abs(new algConstant(
						min(algGetConstantValue(_varExponentTop), algGetConstantValue(_varExponentBottom)), 1));
					
					// set up this
					topPart.variables[$ _varName[i]].powerTo	 = algGetConstantValue(_varExponentTop) - _diffVar;
					bottomPart.variables[$ _varName[n]].powerTo	 = algGetConstantValue(_varExponentBottom) - _diffVar;
				};
			};
		};
	});
};

// and set up the root
function algRoot(_expression, _rootN = 2, powerTo = 1) : algCore(powerTo) constructor {
	type = algType.root;
	// set up my root
	rootN = _rootN;
	
	// get it
	expression = _expression;
	
	// reduce this up
	reduceCheck = method(mySelf, function () {
		// return this up
		expression.reduceCheckCall();
	});
};

/// @description The sum of monomials
function algPolynomial(_monomials, powerTo = 1) : algCore(powerTo) constructor {
	type = algType.polynomial;
	
	// is not array?
	if (!is_array(_monomials)) { _monomials = [ _monomials ]; };
	// the monimials inside
	monomials = _monomials;
	
	reduceCheck = method(mySelf, function () {
		// check out for similar polynomials
		for (var i = 0; i < array_length(monomials); i++) {
			// do the reduce check
			monomials[i].reduceCheckCall();
		};
	});
};
