/// @description set up buttons
depth = -30;

musicDeleteAll();
//display_set_gui_size(round(window_get_width() / 2), round(window_get_height() / 2));
display_set_gui_size(screen.width * 2, screen.height * 2);

mainCore = new kuiCore("main", new kuiUIVec2(0, 0, 0, 0), new kuiUIVec2(display_get_gui_width(), 0, display_get_gui_height(), 0)); 
mainCore.parent = id;
mainCore.globalParent = id;

var _window0 = new kuiMoveWindow("window", new kuiUIVec2(5, 0, 5, 0), new kuiUIVec2(200, 0, 137, 0), "", false);

var _button0 = new kuiButton("button", new kuiUIVec2(3, 0, 22, 0), new kuiUIVec2(80, 0, 14, 0));
_button0.elementAdd(new kuiText("text", new kuiUIVec2(0, 0, 0, 0), new kuiUIVec2(0, 1, 0, 1), "WACHIN GEI", c_white, fa_center, fa_middle));
_button0.callbackSet(function () {
	
	var _moveWindow0 = new kuiMoveWindow("moveable", new kuiUIVec2(5, 0, 5, 0), new kuiUIVec2(270, 0, 200, 0), "Testing Window", true);
	_moveWindow0.resizeableActive(270, 200, 800, 800);
	
	_moveWindow0.elementAdd(new kuiButton("button", new kuiUIVec2(3, 0, 13, 0), new kuiUIVec2(80, 0, 14, 0)));
	
	var _radio_array = new kuiRadioArray("radio", new kuiUIVec2(3, 0, 30, 0), new kuiUIVec2(-6, 1, -30, 1), "Choose a flavor", 0);
	_moveWindow0.elementAdd(_radio_array);
	
	_radio_array.setColumnCapacity(2);
	_radio_array.addOptions("cinnamon", "excreo", "notso", "wachin");
	
	
	var _openList = new kuiListButton("buttonList", new kuiUIVec2(3, 0, 86, 0), new kuiUIVec2(80, 0, 14, 0), "theList", 40,
					function (_oId, _listParent, _infoStruct, _oX, _oY, _oW, _oH) {
						
						var _buttonListIns = new kuiButtonSkinList(string(_oId) + "button", new kuiUIVec2(0, 0, 0, 0), new kuiUIVec2(_oW, 0, _oH, 0), function () {
							// Set NPC
							parent.originalButton.elements.textUI.setText(elements.textUI.getText());
							parent.selfDestroy();
							//parent.originalButton.elements[$].setText(content[1].getText());
							// Destroy the fucking list
							//instance_destroy(handler);
						});
						// Add content to this shit
						_buttonListIns.elementAdd(new kuiText("textUI", new kuiUIVec2(_oH, 0, 1, 0), new kuiUIVec2(-10, 1, _oH - 2, 0), "npc-" + string(_oId)));
						
						// Add content to list
						_listParent.optionAddElement(_oId, _buttonListIns);
						
					}, [ {}, {}, {} ]); 
	
	var _inputFloat = new kuiInput("inputFloat", new kuiUIVec2(-123, 1, 86, 0), new kuiUIVec2(120, 0, 14, 0), "set here float", "", 50, false, KUI_INPUT_TYPE.floatType);
	
	var _inputInteger = new kuiInput("inputInteger", new kuiUIVec2(-123, 1, 102, 0), new kuiUIVec2(120, 0, 14, 0), "set here integer", "", 50, false, KUI_INPUT_TYPE.integerType);
	
	var _inputString = new kuiInput("inputString", new kuiUIVec2(-123, 1, 118, 0), new kuiUIVec2(120, 0, 14, 0), "put here ur name", environment_get_variable("USERNAME"), 50, false, KUI_INPUT_TYPE.stringType);
	
	_moveWindow0.elementAdd(_openList, _inputFloat, _inputInteger, _inputString);
	
	var _inputABaskara = new kuiInput("aBaskara", new kuiUIVec2(3, 0, -17, 1), new kuiUIVec2(40, 0, 14, 0), "a", string(globalParent.baskaraParameters.a), 20, false, KUI_INPUT_TYPE.floatType, function () {
		// set up this
		globalParent.baskaraParameters.a = storedNumber;
	});
	_inputABaskara.userSetCheckout(function (_stringR) { return (real(_stringR) != 0); });
	var _inputBBaskara = new kuiInput("bBaskara", new kuiUIVec2(46, 0, -17, 1), new kuiUIVec2(40, 0, 14, 0), "b", string(globalParent.baskaraParameters.b), 20, false, KUI_INPUT_TYPE.floatType, function () {
		// set up this
		globalParent.baskaraParameters.b = storedNumber;
	});
	var _inputCBaskara = new kuiInput("cBaskara", new kuiUIVec2(89, 0, -17, 1), new kuiUIVec2(40, 0, 14, 0), "c", string(globalParent.baskaraParameters.c), 20, false, KUI_INPUT_TYPE.floatType, function () {
		// set up this
		globalParent.baskaraParameters.c = storedNumber;
	});
	var _buttonBaskara = new kuiButtonText("baskaraResolve", new kuiUIVec2(132, 0, -17, 1), new kuiUIVec2(80, 0, 14, 0), "Resolve square", function () {
		
		var _triangleH = algComplexString(algResolve(globalParent.baskaraTriangle, globalParent.baskaraParameters));
		
		show_debug_message("--- SOLVING ROOT 1 ---");
		var _root1 = algComplexString(algResolve(globalParent.baskaraRoot1, globalParent.baskaraParameters));
		show_debug_message("--- SOLVING ROOT 2 ---");
		var _root2 = algComplexString(algResolve(globalParent.baskaraRoot2, globalParent.baskaraParameters));
		
		show_debug_message("b ^ 2: " + algComplexString(algResolve(
			new algVariable("b", 2),
			globalParent.baskaraParameters
		)));
		
		show_debug_message("-4ac: " + algComplexString(algResolve(
			new algMonomial(
				[new algVariable("c"), new algVariable("a")] , -4),
			globalParent.baskaraParameters
		)));
		
		show_message(json_stringify(globalParent.baskaraParameters, true) + "\n\ntriangle: " + _triangleH + ",\nx 1: " + _root1 + ",\nx 2: " + _root2);
	});
	
	
	
	var _inputACubic = new kuiInput("aCubic", new kuiUIVec2(3, 0, -34, 1), new kuiUIVec2(40, 0, 14, 0), "a", string(globalParent.cubicParameters.a), 20, false, KUI_INPUT_TYPE.floatType, function () {
		// set up this
		globalParent.cubicParameters.a = storedNumber;
	});
	_inputACubic.userSetCheckout(function (_stringR) { return (real(_stringR) != 0); });
	var _inputBCubic = new kuiInput("bCubic", new kuiUIVec2(46, 0, -34, 1), new kuiUIVec2(40, 0, 14, 0), "b", string(globalParent.cubicParameters.b), 20, false, KUI_INPUT_TYPE.floatType, function () {
		// set up this
		globalParent.cubicParameters.b = storedNumber;
	});
	var _inputCCubic = new kuiInput("cCubic", new kuiUIVec2(89, 0, -34, 1), new kuiUIVec2(40, 0, 14, 0), "c", string(globalParent.cubicParameters.c), 20, false, KUI_INPUT_TYPE.floatType, function () {
		// set up this
		globalParent.cubicParameters.c = storedNumber;
	});
	var _inputDCubic = new kuiInput("dCubic", new kuiUIVec2(132, 0, -34, 1), new kuiUIVec2(40, 0, 14, 0), "d", string(globalParent.cubicParameters.d), 20, false, KUI_INPUT_TYPE.floatType, function () {
		// set up this
		globalParent.cubicParameters.d = storedNumber;
	});
	
	var _buttonCubic = new kuiButtonText("cubicResolve", new kuiUIVec2(175, 0, -34, 1), new kuiUIVec2(80, 0, 14, 0), "Resolve cubic", function () {
		
		var _c1	 = algResolve(globalParent.cubicNegCubeBOver27CubeA, globalParent.cubicParameters);
		var _c2	 = algResolve(globalParent.cubicNegSquareBOver9SquareA, globalParent.cubicParameters);
		var _c3	 = algResolve(globalParent.cubicBCOver6SquareA, globalParent.cubicParameters);
		var _c4	 = algResolve(globalParent.cubicNegDOver2A, globalParent.cubicParameters);
		var _c5	 = algResolve(globalParent.cubicCOver3A, globalParent.cubicParameters);
		var _c6	 = algResolve(globalParent.cubicRootRootTermA, globalParent.cubicParameters);
		var _c7	 = algResolve(globalParent.cubicRootRootTermB, globalParent.cubicParameters);
		var _c8	 = algResolve(globalParent.cubicRootRoot, globalParent.cubicParameters);
		var _c9	 = algResolve(globalParent.cubicRootRootNeg, globalParent.cubicParameters);
		var _c10 = algResolve(globalParent.cubicRootTermA, globalParent.cubicParameters);
		var _c11 = algResolve(globalParent.cubicRootTermB, globalParent.cubicParameters);
		var _c12 = algResolve(globalParent.cubicRootTermC, globalParent.cubicParameters);
		var _c13 = algResolve(globalParent.cubicRoot2ObtainA, globalParent.cubicParameters);
		var _c14 = algResolve(globalParent.cubicRoot2ObtainB, globalParent.cubicParameters);
		
		
		
		show_debug_message("--- SOLVING ROOT 1 ---");
		global.resolveHere = "";
		var _root1 = algComplexString(algResolve(globalParent.cubicSol1, globalParent.cubicParameters));
		show_debug_message(global.resolveHere);
		show_debug_message("--- SOLVING ROOT 2 ---");
		var _root2 = algComplexString(algResolve(globalParent.cubicSol2, globalParent.cubicParameters));
		show_debug_message("--- SOLVING ROOT 3 ---");
		var _root3 = algComplexString(algResolve(globalParent.cubicSol3, globalParent.cubicParameters));
		
		
		show_debug_message("(cubicNegCubeBOver27CubeA): "		 + algComplexString(_c1));
		show_debug_message("(cubicNegSquareBOver9SquareA): "	 + algComplexString(_c2));
		show_debug_message("(cubicBCOver6SquareA): "			 + algComplexString(_c3));
		show_debug_message("(cubicNegDOver2A): "				 + algComplexString(_c4));
		show_debug_message("(cubicCOver3A): "					 + algComplexString(_c5));
		show_debug_message("(cubicRootRootTermA): "				 + algComplexString(_c6));
		show_debug_message("(cubicRootRootTermB): "				 + algComplexString(_c7));
		show_debug_message("(cubicRootRoot): "					 + algComplexString(_c8));
		show_debug_message("(cubicRootRootNeg): "				 + algComplexString(_c9));
		show_debug_message("(cubicRootTermA): "					 + algComplexString(_c10));
		show_debug_message("(cubicRootTermB): "					 + algComplexString(_c11));
		show_debug_message("(cubicRootTermC): "					 + algComplexString(_c12));
		show_debug_message("(cubicRoot2ObtainA): "				 + algComplexString(_c13));
		show_debug_message("(cubicRoot2ObtainB): "				 + algComplexString(_c14));
		
		
		show_message(json_stringify(globalParent.cubicParameters, true) + "\n\nx 1: " + _root1 + ",\nx 2: " + _root2 + ",\nx 3: " + _root3);
	});
	
	
	
	_moveWindow0.elementAdd(_inputABaskara, _inputBBaskara, _inputCBaskara, _buttonBaskara);
	
	_moveWindow0.elementAdd(_inputACubic, _inputBCubic, _inputCCubic, _inputDCubic, _buttonCubic);
	
	parent.parent.elementAdd(_moveWindow0);
});

var _window1 = new kuiSectionWindow("sectionWindow", new kuiUIVec2(-215, 1, 5, 0), new kuiUIVec2(210, 0, 145, 0), [ "Pepe el mago", "caca de soya", "seh" ]); 

//_window0.elementAdd(new kuiChecker("checker", new kuiUIVec2(3, 0, 41, 0), "hola homos"),
//					_button0);

_window1.sectionGetCore(0).elementAdd(new kuiChecker("checker", new kuiUIVec2(3, 0, 41, 0), "hola homos"),
					_button0);

mainCore.elementAdd(_window0, _window1);


// set up baskara formula
baskaraTriangle =
	new algRoot(
		new algPolynomial([ 
			new algVariable("b", 2),
			new algMonomial(
				[new algVariable("c"), new algVariable("a")] , -4) ])
	, 2);

baskaraParameters = { a : 1, b : 0, c : -1 };

baskaraRoot1 = new algFraction(new algPolynomial([ new algMonomial(new algVariable("b"), -1), new algMonomial(baskaraTriangle, 1) ]), new algMonomial(new algVariable("a"), 2));
baskaraRoot2 = new algFraction(new algPolynomial([ new algMonomial(new algVariable("b"), -1), new algMonomial(baskaraTriangle, -1) ]), new algMonomial(new algVariable("a"), 2)); 

show_debug_message("RESULT " + algComplexString(algResolve(new algPolynomial([ new algFraction(1, 2), new algMonomial(new algVariable("i"), 3) ]), baskaraParameters)));

cubicParameters = { a : 1, b : 0, c : 0, d : -27 };

// the real deal
cubicNegCubeBOver27CubeA = new algFraction(
	new algMonomial(
		new algVariable("b", 3), -1),
		
	new algMonomial(new algVariable("a", 3), 27)
);
cubicNegSquareBOver9SquareA = new algFraction(
	new algMonomial(new algVariable("b", 2), -1),
	new algMonomial(new algVariable("a", 2), 9)
);
cubicBCOver6SquareA = new algFraction(
	new algMonomial([
		new algVariable("b"), 
		new algVariable("c") ]), 
	new algMonomial(
		new algVariable("a", 2), 6)
);
cubicNegDOver2A = new algFraction(
	new algMonomial(
		new algVariable("d"), -1),
	new algMonomial(
		new algVariable("a"), 2)
);
cubicCOver3A = new algFraction(
	new algMonomial(
		new algVariable("c")),
	new algMonomial(
		new algVariable("a"), 3)
);


cubicRootRootTermA = new algPolynomial([ cubicNegCubeBOver27CubeA, cubicBCOver6SquareA, cubicNegDOver2A ]);
cubicRootRootTermB = new algPolynomial([ cubicNegSquareBOver9SquareA, cubicCOver3A ]);

cubicRootRoot = new algRoot(new algPolynomial([ new algMonomial(cubicRootRootTermA, 1, 2), new algMonomial(cubicRootRootTermB, 1, 3) ]), 2);
cubicRootRootNeg = new algMonomial(cubicRootRoot, -1);


cubicRootTermA = new algRoot(new algPolynomial([ cubicRootRootTermA, cubicRootRoot ]), 3);
cubicRootTermB = new algRoot(new algPolynomial([ cubicRootRootTermA, cubicRootRootNeg ]), 3);
cubicRootTermC = new algFraction(new algVariable("b"), new algMonomial(new algVariable("a"), -3));


cubicRoot2ObtainA = new algPolynomial([ new algFraction(-1, 2), new algFraction(new algMonomial(new algVariable("i"), sqrt(3), 1), 2) ]);
cubicRoot2ObtainB = new algPolynomial([ new algFraction(-1, 2), new algFraction(new algMonomial(new algVariable("i"), -sqrt(3), 1), 2) ]);


cubicSol1 = new algPolynomial([ cubicRootTermA, cubicRootTermB, cubicRootTermC ]);
cubicSol2 = new algPolynomial([ new algMonomial([ cubicRootTermA, cubicRoot2ObtainA ]), new algMonomial([ cubicRootTermB, cubicRoot2ObtainB ]), cubicRootTermC ]);
cubicSol3 = new algPolynomial([ new algMonomial([ cubicRootTermA, cubicRoot2ObtainB ]), new algMonomial([ cubicRootTermB, cubicRoot2ObtainA ]), cubicRootTermC ]);