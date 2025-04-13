/// @description 
if (!drawCan()) { exit; };

// set it up
draw_primitive_begin(pr_linestrip);
draw_set_color(c_red);


// and loop
for (var i = 0; i <= 1; i += tShift) {
	
	// get the first three semi points
	
	var _finalPoint = beizerPointsGet(i,
					new beizerVec2(point1Ins.x, point1Ins.y),
					new beizerVec2(point2Ins.x, point2Ins.y),
					new beizerVec2(point3Ins.x, point3Ins.y),
					new beizerVec2(point4Ins.x, point4Ins.y));
	var _finalX = _finalPoint.x;
	var _finalY = _finalPoint.y;
	
	// and add vertex
	draw_vertex(_finalX, _finalY);
};

// and end it
draw_primitive_end();


// draw white points
draw_set_color(c_white);
draw_line(point1Ins.x, point1Ins.y, point2Ins.x, point2Ins.y);
draw_line(point3Ins.x, point3Ins.y, point4Ins.x, point4Ins.y);

// get teh solver
var _aForX = ((3 * point2Ins.x) - (3 * point3Ins.x) + point4Ins.x - point1Ins.x);
var _bForX = 3 * (point1Ins.x - (2 * point2Ins.x) + point3Ins.x);
var _cForX = 3 * (point2Ins.x - point1Ins.x);
var _dForX = point1Ins.x - mouseGetX();
// and solve for it
var _solutions = algCubicFormulaResolveForRealRoots(_aForX, _bForX, _cForX, _dForX);
// and read here
for (var i = 0; i < array_length(_solutions); i++) {
	//show_debug_message(stringFormatDecimal(_solutions[i], 6));
	var _appliedPoint = beizerPointsGet(_solutions[i],
					new beizerVec2(point1Ins.x, point1Ins.y),
					new beizerVec2(point2Ins.x, point2Ins.y),
					new beizerVec2(point3Ins.x, point3Ins.y),
					new beizerVec2(point4Ins.x, point4Ins.y));
	
	draw_sprite_ext(sp_11box, 0,
				_appliedPoint.x - 1,
				_appliedPoint.y - 1,
				2, 2, 0, c_blue, 1);
};
