
/// @description Load in square formula
function algSquareFormulaLoadIn(_a = 1, _b = 1, _c = 1) {

// set up baskara formula
global._baskaraTriangle =
	new algRoot(
		new algPolynomial([ 
			new algVariable("b", 2),
			new algMonomial(
				[new algVariable("c"), new algVariable("a")] , -4) ])
	, 2);

global._baskaraParameters = { a : _a, b : _b, c : _c };

global._baskaraRoot1 = new algFraction(new algPolynomial([ new algMonomial(new algVariable("b"), -1), new algMonomial(global._baskaraTriangle, 1) ]), new algMonomial(new algVariable("a"), 2));
global._baskaraRoot2 = new algFraction(new algPolynomial([ new algMonomial(new algVariable("b"), -1), new algMonomial(global._baskaraTriangle, -1) ]), new algMonomial(new algVariable("a"), 2)); 

};
algSquareFormulaLoadIn();

/// @description resolve the freaking shit here
function algSquareFormulaResolve(_a, _b, _c) {

// update this
global._baskaraParameters.a = _a;
global._baskaraParameters.b = _b;
global._baskaraParameters.c = _c;


// Solve each root for one one
//show_debug_message("--- SOLVING ROOT 1 ---");
var _root1 = algResolve(global._baskaraRoot1, global._baskaraParameters);
// Solve two two two two
//show_debug_message("--- SOLVING ROOT 2 ---");
var _root2 = algResolve(global._baskaraRoot2, global._baskaraParameters);

// return here
return [ _root1, _root2 ];

};

/// @description get roots
function algSquareFormulaResolveForRealRoots(_a, _b, _c) {

// update this
var _ocRoots = algSquareFormulaResolve(_a, _b, _c);
var _finalRoots = [];
// and read each one
for (var i = 0; i < array_length(_ocRoots); i++) {
	// and get here the shit out
	if (_ocRoots[i][1] == 0) {
		// push in
		array_push(_finalRoots, _ocRoots[i][0]);
	};
};

return _finalRoots;

};

/// @description Load in cubic
function algCubicFormulaLoadIn(_a = 1, _b = 1, _c = 1, _d = 1) {

// get in here
global._cubicParameters = { a : _a, b : _b, c : _c, d : _d };

// the real deal
global._cubicNegCubeBOver27CubeA = new algFraction(
	new algMonomial(
		new algVariable("b", 3), -1),
		
	new algMonomial(new algVariable("a", 3), 27)
);
global._cubicNegSquareBOver9SquareA = new algFraction(
	new algMonomial(new algVariable("b", 2), -1),
	new algMonomial(new algVariable("a", 2), 9)
);
global._cubicBCOver6SquareA = new algFraction(
	new algMonomial([
		new algVariable("b"), 
		new algVariable("c") ]), 
	new algMonomial(
		new algVariable("a", 2), 6)
);
global._cubicNegDOver2A = new algFraction(
	new algMonomial(
		new algVariable("d"), -1),
	new algMonomial(
		new algVariable("a"), 2)
);
global._cubicCOver3A = new algFraction(
	new algMonomial(
		new algVariable("c")),
	new algMonomial(
		new algVariable("a"), 3)
);


global._cubicRootRootTermA = new algPolynomial([ global._cubicNegCubeBOver27CubeA, global._cubicBCOver6SquareA, global._cubicNegDOver2A ]);
global._cubicRootRootTermB = new algPolynomial([ global._cubicNegSquareBOver9SquareA, global._cubicCOver3A ]);

global._cubicRootRoot = new algRoot(new algPolynomial([ new algMonomial(global._cubicRootRootTermA, 1, 2), new algMonomial(global._cubicRootRootTermB, 1, 3) ]), 2);
global._cubicRootRootNeg = new algMonomial(global._cubicRootRoot, -1);


global._cubicRootTermA = new algRoot(new algPolynomial([ global._cubicRootRootTermA, global._cubicRootRoot ]), 3);
global._cubicRootTermB = new algRoot(new algPolynomial([ global._cubicRootRootTermA, global._cubicRootRootNeg ]), 3);
global._cubicRootTermC = new algFraction(new algVariable("b"), new algMonomial(new algVariable("a"), -3));


global._cubicRoot2ObtainA = new algPolynomial([ new algFraction(-1, 2), new algFraction(new algMonomial(new algVariable("i"), sqrt(3), 1), 2) ]);
global._cubicRoot2ObtainB = new algPolynomial([ new algFraction(-1, 2), new algFraction(new algMonomial(new algVariable("i"), -sqrt(3), 1), 2) ]);


global._cubicSol1 = new algPolynomial([ global._cubicRootTermA, global._cubicRootTermB, global._cubicRootTermC ]);
global._cubicSol2 = new algPolynomial([ new algMonomial([ global._cubicRootTermA, global._cubicRoot2ObtainA ]), new algMonomial([ global._cubicRootTermB, global._cubicRoot2ObtainB ]), global._cubicRootTermC ]);
global._cubicSol3 = new algPolynomial([ new algMonomial([ global._cubicRootTermA, global._cubicRoot2ObtainB ]), new algMonomial([ global._cubicRootTermB, global._cubicRoot2ObtainA ]), global._cubicRootTermC ]);

};
algCubicFormulaLoadIn();

/// @description resolve the freaking shit here
function algCubicFormulaResolve(_a, _b, _c, _d) {

// update this
global._cubicParameters.a = _a;
global._cubicParameters.b = _b;
global._cubicParameters.c = _c;
global._cubicParameters.d = _d;


// Solve each root for one one
//show_debug_message("--- SOLVING ROOT 1 ---");
var _root1 = algResolve(global._cubicSol1, global._cubicParameters);
// Solve two two two two
//show_debug_message("--- SOLVING ROOT 2 ---");
var _root2 = algResolve(global._cubicSol2, global._cubicParameters);
// And the final three three three
//show_debug_message("--- SOLVING ROOT 3 ---");
var _root3 = algResolve(global._cubicSol3, global._cubicParameters);

// return here
return [ _root1, _root2, _root3 ];

};

/// @description get roots
function algCubicFormulaResolveForRealRoots(_a, _b, _c, _d) {

// update this
var _ocRoots = algCubicFormulaResolve(_a, _b, _c, _d);
var _finalRoots = [];
// and read each one
for (var i = 0; i < array_length(_ocRoots); i++) {
	// and get here the shit out
	if (_ocRoots[i][1] == 0) {
		// push in
		array_push(_finalRoots, _ocRoots[i][0]);
	};
};

return _finalRoots;

};