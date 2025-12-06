function cubicSolverDLL(a, b, c, d){

// crete a size for the buffer
var _buffSize = 10;
// crae it
var _buffTemp = buffer_create(_buffSize * buffer_sizeof(buffer_f64), buffer_fixed, 1);
// get all the things here
buffer_seek(_buffTemp, buffer_seek_start, 0);
buffer_write(_buffTemp, buffer_f64, a);
buffer_write(_buffTemp, buffer_f64, b);
buffer_write(_buffTemp, buffer_f64, c);
buffer_write(_buffTemp, buffer_f64, d);

// solve it
cubicRootSolverDLLExternal(buffer_get_address(_buffTemp), _buffSize);

// do the three solutions
var _cubicRoots = [ [], [], [] ];

// get all the things here
buffer_seek(_buffTemp, buffer_seek_start, 0);
_cubicRoots[0][0] = buffer_read(_buffTemp, buffer_f64);
_cubicRoots[0][1] = buffer_read(_buffTemp, buffer_f64);
_cubicRoots[1][0] = buffer_read(_buffTemp, buffer_f64);
_cubicRoots[1][1] = buffer_read(_buffTemp, buffer_f64);
_cubicRoots[2][0] = buffer_read(_buffTemp, buffer_f64);
_cubicRoots[2][1] = buffer_read(_buffTemp, buffer_f64);//*/

// delete buffer
buffer_delete(_buffTemp);
return _cubicRoots;

};

function squareSolverDLL(a, b, c){

// crete a size for the buffer
var _buffSize = 10;
// crae it
var _buffTemp = buffer_create(_buffSize * buffer_sizeof(buffer_f64), buffer_fixed, 1);
// get all the things here
buffer_seek(_buffTemp, buffer_seek_start, 0);
buffer_write(_buffTemp, buffer_f64, a);
buffer_write(_buffTemp, buffer_f64, b);
buffer_write(_buffTemp, buffer_f64, c);

// solve it
cubicRootSolverDLLExternal(buffer_get_address(_buffTemp), _buffSize);

// do the three solutions
var _squareRoots = [ [], [] ];

// get all the things here
buffer_seek(_buffTemp, buffer_seek_start, 0);
_squareRoots[0][0] = buffer_read(_buffTemp, buffer_f64);
_squareRoots[0][1] = buffer_read(_buffTemp, buffer_f64);
_squareRoots[1][0] = buffer_read(_buffTemp, buffer_f64);
_squareRoots[1][1] = buffer_read(_buffTemp, buffer_f64);

// delete buffer
buffer_delete(_buffTemp);
return _squareRoots;

};

/// @description Returns all the real only roots.
function cubicSolverRealOnly(a, b, c, d) {

// get the three roots
var _roots = cubicSolverDLL(a, b, c, d);
var _realRoots = [];
// loop seraching
for (var i = 0; i < array_length(_roots); i++) {
	// verify its 0
	if (_roots[i][1] == 0) {
		array_push(_realRoots, _roots[i][0]);
	};
};

// return that
return _realRoots;
};

/// @description Returns all the real only roots.
function squareSolverRealOnly(a, b, c) {

// get the three roots
var _roots = squareSolverDLL(a, b, c);
var _realRoots = [];
// loop seraching
for (var i = 0; i < array_length(_roots); i++) {
	// verify its 0
	if (_roots[i][1] == 0) {
		array_push(_realRoots, _roots[i][0]);
	};
};

// return that
return _realRoots;
};