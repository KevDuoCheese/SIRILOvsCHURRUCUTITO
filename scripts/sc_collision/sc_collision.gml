 

#region Basic math to make all the collision function

function customPointDirection(x1, y1, x2, y2) {

// Get the dude angle ma boy
return radtodeg(arctan2(y1 - y2, x2 - x1));

};

/// @function Vec2(x, y);
/// @description 2-dimension vector
/// @param {real} xPos
/// @param {real} yPos
function Vec2(xPos, yPos) constructor {
	// Vector 2 position
	x = xPos;
	y = yPos;
};

/// @description If but more confortable than : ?
function iif(condition, value1, value2) {

// Condition
if (condition) {
	// Condition value
    return value1;
} else {
	// Else value
    return value2;
};

};


/// @description Checks if two lines insersect, returns if true
function lines_intersect(x1, y1, x2, y2, x3, y3, x4, y4, segment) {

var ua, ub, ud, ux, uy, vx, vy, wx, wy;
ua = 0;
ux = x2 - x1;
uy = y2 - y1;
vx = x4 - x3;
vy = y4 - y3;
wx = x1 - x3;
wy = y1 - y3;
ud = vy * ux - vx * uy;
if (ud != 0) {
	
    ua = (vx * wy - vy * wx) / ud;
    if (segment)  {
		
        ub = (ux * wy - uy * wx) / ud;
        if (ua < 0 || ua > 1 || ub < 0 || ub > 1) ua = 0;
    };
};
//return ua;
// Ig has been collision
return (ua > 0) && (ua <= 1);

};

/// @description Check if two lines intersect, if true, returns the interaction position
function lines_intersect_pos(x1, y1, x2, y2, x3, y3, x4, y4, segment) {

var ua, ub, ud, ux, uy, vx, vy, wx, wy;
ua = 0;
ux = x2 - x1;
uy = y2 - y1;
vx = x4 - x3;
vy = y4 - y3;
wx = x1 - x3;
wy = y1 - y3;
ud = vy * ux - vx * uy;
if (ud != 0) {
	
    ua = (vx * wy - vy * wx) / ud;
    if (segment)  {
		
        ub = (ux * wy - uy * wx) / ud;
        if (ua < 0 || ua > 1 || ub < 0 || ub > 1) ua = 0;
    };
};
//return ua;

return new Vec2(x1 + (ua * (x2 - x1)), y1 + (ua * (y2 - y1)));

};


/// @description Checks if a point is inside a polygon
function point_in_polygon(pointX, pointY, colPoints) {

var pSize = array_length(colPoints);
var count = 0;

// Loop for points
for (var i = 0; i < pSize; i++) {
	
	var side = {
		
		a : {
			
			x : colPoints[i].x,
			y : colPoints[i].y
		},
		b : {
			
			x : colPoints[(i + 1) mod pSize].x,
			y : colPoints[(i + 1) mod pSize].y
		}
	};
	
	var x1 = side.a.x,
		x2 = side.b.x,
		y1 = side.a.y,
		y2 = side.b.y;
	
	if (
		((pointY < y1) != (pointY < y2)) &&
		(pointX < ((x2 - x1) * (pointY - y1) / (y2 - y1) + x1))
	) {
		// Add to count
		count++;
	};
};

return bool(count % 2);

};

/// @description Maybe a little unoptimized?? but it works
function polygon_intersect_polygon(p1Points, p2Points) {

// Get two size my man
var p1Size = array_length(p1Points), p2Size = array_length(p2Points);

// For all frist polygon collision points
for (var i = 0; i < p1Size; i++) {
	
	// get point X and Y
	var point1X, point1Y;
	point1X = p1Points[i].x;
	point1Y = p1Points[i].y;
	// get next point X and Y
	var point1NextX, point1NextY;
	point1NextX = p1Points[(i + 1) mod p1Size].x;
	point1NextY = p1Points[(i + 1) mod p1Size].y;
	
	// Next one collision point
	for (var n = 0; n < p2Size; n++) {
		
		// get point X and Y
		var point2X, point2Y;
		point2X = p2Points[n].x;
		point2Y = p2Points[n].y;
		// get next point X and Y
		var point2NextX, point2NextY;
		point2NextX = p2Points[(n + 1) mod p2Size].x;
		point2NextY = p2Points[(n + 1) mod p2Size].y;
		
		// Check if there is an intersection line
		if (lines_intersect(point1X, point1Y, point1NextX, point1NextY, point2X, point2Y, point2NextX, point2NextY, true)) {
			// Yes, there was an intersection
			return true;
			break;
		};
	};
};

// No??? Then check all first polygon points on other
for (var i = 0; i < p1Size; i++) {
	
	// get point X and Y
	var pointX, pointY;
	pointX = p1Points[i].x;
	pointY = p1Points[i].y;
	// It's inside the other
	if (point_in_polygon(pointX, pointY, p2Points)) {
		// Thank you gay
		return true;
		break;
	};
};

// My last fucking try, on second polygon
for (var i = 0; i < p2Size; i++) {
	
	// get point X and Y
	var pointX, pointY;
	pointX = p2Points[i].x;
	pointY = p2Points[i].y;
	// It's inside the other
	if (point_in_polygon(pointX, pointY, p1Points)) {
		// YEEES
		return true;
		break;
	};
};

// :(
return false;

};

#endregion


function angleIsCliff(desiredAngle) {

// Limit this
desiredAngle = angle_difference(desiredAngle, 0);

// Convert this to an angle in range
if ((desiredAngle == 90 || desiredAngle == -90) ||
	(!angleInRange(110, 250, desiredAngle) && !angleInRange(-70, 70, desiredAngle))) {
	// Yes it is
	return true;
};

return false;

};

function angleIsSlope(desiredAngle) {

// Limit this
desiredAngle = angle_difference(desiredAngle, 0);

// Convert this to an angle in range
if ((desiredAngle != 0 && desiredAngle != 180 && desiredAngle != -180 && desiredAngle != 90 && desiredAngle != -90) &&
	(angleInRange(110, 250, desiredAngle) || angleInRange(-70, 70, desiredAngle))) {
	// Yes it is
	return true;
};

return false;

};


/// @description Draw the shit on debug mode
function colDebugDraw(polygonColor = c_white) {

var primitiveAlpha = 0.25;

// Draw debug mode
draw_set_color(polygonColor);
// Debug numbers
draw_set_font(global.fontMap[? "debug-num"]);


draw_set_alpha(primitiveAlpha);
shader_set(sh_alpha_surface);
gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);

// Start this
draw_primitive_begin(pr_trianglefan);
// For all my collision points
for (var i = 0; i < colSize; i++) {
	
	// get point X and Y
	var pointX, pointY;
	pointX = colPoints[i].x;
	pointY = colPoints[i].y;
	
	// Add vertex
	draw_vertex(pointX, pointY);
	
	// get next point X and Y
	var pointNextX, pointNextY;
	pointNextX = colPoints[(i + 1) mod colSize].x;
	pointNextY = colPoints[(i + 1) mod colSize].y;
	// It's the last
	//if (i == (colSize - 1)) { draw_vertex(pointNextX, pointNextY); };
	
	// Get line direction
	var lineDirection = angle_difference(point_direction(pointX, pointY, pointNextX, pointNextY), 0);
	// Get true direction
	var realDir = angle_difference(point_direction(pointX, pointY, pointNextX, pointNextY), -90);
	var normalX, normalY, normalLength;
	normalX = (pointX + pointNextX) / 2;
	normalY = (pointY + pointNextY) / 2;
	normalLength = 5;
	// Other
	var normalEndX, normalEndY;
	normalEndX = normalX + (cos(degtorad(realDir)) * normalLength);
	normalEndY = normalY - (sin(degtorad(realDir)) * normalLength);
	// It's more than 90
	if (abs(lineDirection) > 90) { lineDirection = (180 - abs(lineDirection)) * sign(lineDirection); };
	
	// Draw direction
	//draw_sprite_ext(sp_ui_arrowTest, 0, pointX, pointY, 1, 1, 0, c_white, 1);
	
	draw_set_alpha(1);
	// (imCol) { draw_set_color(c_red); };
	// Draw line to next point
	drawLine(pointX, pointY, pointNextX, pointNextY);
	
	///if (global.debugIdNMaskVisible) {
		
		draw_set_color(c_white);
		// Draw number
		draw_text_transformed(pointX, pointY, i, global.screenSizeInv, global.screenSizeInv, 0);
	
		draw_set_color(c_aqua);
		drawLine(normalX, normalY, normalEndX, normalEndY);
	//};
	//draw_arrow(normalX - 1, normalY - 1, normalEndX - 1, normalEndY - 1, 3);
	
	draw_set_color(polygonColor);
	draw_set_alpha(primitiveAlpha);
};


draw_primitive_end();

gpu_set_blendmode(bm_normal);
shader_reset();
draw_set_alpha(1);

};


/// @description Create a collision point based on BBox
function colCreateBBox() {

// Save angle my man
var oldAngle = image_angle;
image_angle = 0;
// Create collision
colCreate(new Vec2(bbox_left, bbox_top),
		  new Vec2(bbox_right, bbox_top),
		  new Vec2(bbox_right, bbox_bottom),
		  new Vec2(bbox_left, bbox_bottom));

// Back to normality
image_angle = oldAngle;
// Update my bro
colUpdate();

};

/// @description Same as other but on triangles slope
function colCreateBBoxSlope() {

// Save angle my man
var oldAngle = image_angle;
image_angle = 0;

// Inverted totally
if ((image_xscale < 0) && (image_yscale < 0)) {
	// Create collision
	colCreate(new Vec2(bbox_left, bbox_top),
			  new Vec2(bbox_right, bbox_top),
			  new Vec2(bbox_left, bbox_bottom));
			  
} else if (image_xscale < 0) {
	// Create collision
	colCreate(new Vec2(bbox_left, bbox_top),
			  new Vec2(bbox_right, bbox_bottom),
			  new Vec2(bbox_left, bbox_bottom));
} else if (image_yscale < 0) {
	// Create collision
	colCreate(new Vec2(bbox_left, bbox_top),
			  new Vec2(bbox_right, bbox_top),
			  new Vec2(bbox_right, bbox_bottom));
} else {
	// Create collision
	colCreate(new Vec2(bbox_left, bbox_bottom),
			  new Vec2(bbox_right, bbox_top),
			  new Vec2(bbox_right, bbox_bottom));
};

// Back to normality
image_angle = oldAngle;
// Update my bro
colUpdate();

};


/// @description Creates a collision with points
function colCreate() {

// Now active collision
collisionActive = true;

// --- ADD HERE ANY EXTRA INIT VARIABLES ----

// Main speeds my man
xSpeed = 0;
ySpeed = 0;

// ------------------------------------------

// if ignore inside 
colIgnoreInside = false;
// empty collision points
colPoints = [  ];
// Fill points
for (var i = 0; i < argument_count; i++) {
	
	// Add point
	array_push(colPoints, argument[i]);
};
// Get total size
colSize = array_length(colPoints);

colCos = cos(degtorad(image_angle));
colSin = -sin(degtorad(image_angle));

// Save points origin
colPointsOrigin();
// Update collision
colUpdate();

// Create a collision validator function
colFunction = function (rayData, collisionId) {
	
	return true;
};

};


/// @description Get origin points of all points, so can update later
function colPointsOrigin() {

// Create origin array
colOrigin = array_create(colSize);
// colSize of
for (var i = 0; i < colSize; i++) {
	// Points
	var pointD = colPoints[i];
	// Create origin vector
	colOrigin[i] = new Vec2((pointD.x - x) / image_xscale, (pointD.y - y) / image_yscale);
};

};

/// @description Updates collision and points according to scale and angle
function colUpdate() {

// Update cos and sin constant
colCos = cos(degtorad(image_angle));
colSin = -sin(degtorad(image_angle));

// colSize of
for (var i = 0; i < colSize; i++) {
	// Points
	var pointO = colOrigin[i];
	// Get X and Y distance
	var hLength, vLength;
	// Update this shit
	hLength = (pointO.x * image_xscale);
	vLength = (pointO.y * image_yscale);
	
	// Update point
	colPoints[i] = new Vec2(x + lengthdir_x(hLength, image_angle) + lengthdir_x(vLength, image_angle - 90), y + lengthdir_y(hLength, image_angle) + lengthdir_y(vLength, image_angle - 90)); 
};

};

/// @description Creates a 0 length ray
function colPoint(xPos, yPos, collisionArray = [ ob_collision ], ignoreSlope = false) {

// Return position
var rayIns = colRay(xPos, yPos, -45, 1, collisionArray, ignoreSlope);
// Ignore slope
//if (rayIns.found && entityIsSlope(rayIns.angle) && ignoreSlope) { rayIns.found = false; };

return rayIns;

};
/// @description Creates a 0 length ray, and returns only if has collision
function colPointMeeting(xPos, yPos, collisionArray = [ ob_collision ], ignoreSlope = false) {

// Return position
var rayIns = colPoint(xPos, yPos, collisionArray, ignoreSlope);
// Ignore slope
//if (rayIns.found && entityIsSlope(rayIns.angle) && ignoreSlope) { rayIns.found = false; };

return rayIns.found;

};

/// @description Creates a 0 length ray, and only returns the instance ID, avoiding other info
function colPointInstance(xPos, yPos, collisionArray = [ ob_collision ], ignoreSlope = false) {

// Return position
var colIns = colPoint(xPos, yPos, collisionArray, ignoreSlope);

// If has found
return colIns.instance;

};

/// @description Basic collision ray
function colRay(initX, initY, lineAngle, maxDist, collisionArray = [ ob_collision ], ignoreSlope = false) {

var returnStruct = {
	
	initX : initX,
	initY : initY,
	
	endX : 0,
	endY : 0,
	
	// no round
	endTrueX : 0,
	endTrueY : 0,
	
	// Collision edge ID
	edge0 : -1,
	edge1 : -1,
	// Point original ID
	edgeId : -1,
	
	inside : false,
	ibidc : false, // inside_but_ignored_due_condition
	
	normal_angle : 0,
	
	angle : 0,
	distance : 0,
	
	found : false,
	instance : noone
};

// Limit angle
lineAngle = angle_difference(lineAngle, 0);
// Get position of end of ray
var endX, endY, endDist, endAngle = 0, endNormal = 0, hasFound = false, fnlEdgeId = -1, fnlEdge0 = -1, fnlEdge1 = -1;
endX = initX + (cos(degtorad(lineAngle)) * maxDist);
endY = initY + (sin(degtorad(lineAngle)) * -maxDist); // Go negative due going up is nagative and not positive
endDist = point_distance(initX, initY, endX, endY);

// Clear list
ds_list_delete_all(global.colList);
var totalCol = 0;
// Add every collision
for (var i = 0; i < array_length(collisionArray); i++) { totalCol += collision_line_list(initX, initY, endX, endY, collisionArray[i], false, true, global.colList, false); };
// Read all collisions
for (var i = 0; i < totalCol; i++) {
	
	// This collision instance, and if this collision point ignored
	var colIns = global.colList[| i], slopeIgnored = false;
	
	// For all my collision points
	for (var n = 0; n < colIns.colSize; n++) {
		
		// Is not active
		if (!colIns.collisionActive) { slopeIgnored = true; break; };
		// get point X and Y
		var pointX, pointY;
		pointX = colIns.colPoints[n].x;
		pointY = colIns.colPoints[n].y;
		// get next point X and Y
		var pointNextX, pointNextY, pointNextId;
		pointNextId = (n + 1) mod colIns.colSize;
		pointNextX = colIns.colPoints[pointNextId].x;
		pointNextY = colIns.colPoints[pointNextId].y;
		
		
		// Do lines intersect?
		if (lines_intersect(pointX, pointY, pointNextX, pointNextY, initX, initY, endX, endY, true)) {
			// Position of intersection
			var intersecPos = lines_intersect_pos(pointX, pointY, pointNextX, pointNextY, initX, initY, endX, endY, true);
			// Get line direction
			var lineDirection = angle_difference(point_direction(pointX, pointY, pointNextX, pointNextY), 0);
			// It's more than 90
			if (abs(lineDirection) > 90) { lineDirection = (180 - abs(lineDirection)) * sign(lineDirection); };
			// Get normal direction
			var normalDirection = angle_difference(point_direction(pointX, pointY, pointNextX, pointNextY), -90);
			
			// Get collision distance
			var lineDistance = point_distance(intersecPos.x, intersecPos.y, initX, initY);
			
			// Validate collision ray
			var availableCollision = colIns.colFunction({ 
				
				// Original position from ray was shot from
				initX : initX,
				initY : initY,
				// Collision position
				endX : intersecPos.x,
				endY : intersecPos.y,
				
				lineAngle : lineAngle,
				
				// Collision edge ID
				edge0 : [ pointX, pointY ],
				edge1 : [ pointNextX, pointNextY ],
				// Point original ID
				edgeId : [ n, pointNextId ],
				
				// The collision angle
				angle : lineDirection,
				// Normal angle, of this line
				normal_angle : normalDirection,
				// Return this ray distance too
				distance : lineDistance
				
			}, id); // Lo que mata es la humedad
			
			// It's more near than the last line
			if ((lineDistance < endDist) && availableCollision) {
				// For slope
				//if ((!entityIsSlope(lineDirection) && ignoreSlope) || !ignoreSlope) {
					
					// Update point distance
					endDist = point_distance(intersecPos.x, intersecPos.y, initX, initY);
					endX = intersecPos.x;
					endY = intersecPos.y;
					// Set edge positions
					fnlEdge0 = [ pointX, pointY ];
					fnlEdge1 = [ pointNextX, pointNextY ];
					// Point original ID
					fnlEdgeId = [ n, pointNextId ];
					
					// Get end angle of direction
					endAngle = lineDirection;
					endNormal = normalDirection;
					hasFound = true;
					returnStruct.instance = colIns;
					
				// If else statement was caused by slope angle
				//} else if (ignoreSlope) { slopeIgnored = true; };
			};
		};
	};
	// Hasn't been found?
	if (!hasFound && !slopeIgnored && !colIns.colIgnoreInside) {
		
		// Validate collision ray
		var availableCollision = colIns.colFunction({ 
			
			// Original position from ray was shot from
			initX : initX,
			initY : initY,
			// Collision position
			endX : initX,
			endY : initY,
			
			lineAngle : lineAngle,
			
			// Collision edge ID
			edge0 : -1,
			edge1 : -1,
			// Point original ID
			edgeId : -1,
			
			// The collision angle
			angle : 0,
			// Normal angle,
			normal_angle : 0,
			// Return this ray distance too
			distance : 0
			
		}, id); // Llueve sobre la ciudad
		
		// If the two point are inside me
		if (point_in_polygon(initX, initY, colIns.colPoints)) {
			
			// Dude it's inside
			if (availableCollision) {
				
				// Update point distance
				endDist = 0;
				endX = initX;
				endY = initY;
				
				// Get end angle of direction
				endAngle = 0;
				endNormal = 0;
				hasFound = true;
				returnStruct.instance = colIns;
				// It's inside
				returnStruct.inside = true;
				
			} else { // IGnored due the collision is a pussy
				
				// Inside but Ignored due condition
				returnStruct.ibidc = true;
			};
		};
	};
};


// Set end positions
returnStruct.endX = roundSign(endX, initX - endX);
returnStruct.endY = roundSign(endY, initY - endY);
// Set end NOT FUCKING ROUNDED WHY THE FUCK DID YOU ROUNDED IT KEV FROM 2023 positions
returnStruct.endTrueX = endX;
returnStruct.endTrueY = endY;
// Distance and angle
returnStruct.angle = endAngle;
returnStruct.normal_angle = endNormal;
returnStruct.distance = endDist; // endDist (Only if want decimals too)
// Set edege shit
returnStruct.edge0 = fnlEdge0;
returnStruct.edge1 = fnlEdge1;
returnStruct.edgeId = fnlEdgeId;
// Has ground
returnStruct.found = hasFound;
// Return results
return returnStruct;

};

/// @description Totally unstable
function colMeeting(maskIndex, xPos, yPos, collisionArray = [ ob_collision ]) {

var maskBLeft, maskWidth, maskHeight, maskBTop;
maskBLeft = sprite_get_bbox_left(maskIndex);
maskBTop = sprite_get_bbox_top(maskIndex);
// Get mask size
maskWidth = (sprite_get_bbox_right(maskIndex) + 1) - maskBLeft;
maskHeight = (sprite_get_bbox_bottom(maskIndex) + 1) - maskBTop;

// Get sprite X and Y off
var spXOff, spYOff;
spXOff = sprite_get_xoffset(maskIndex);
spYOff = sprite_get_yoffset(maskIndex);

// Get mask position
var mX1, mY1, mX2, mY2;
mX1 = (xPos - spXOff) + maskBLeft;
mY1 = (yPos - spYOff) + maskBTop;
// Again corners
mX2 = mX1 + maskWidth;
mY2 = mY1 + maskHeight;

// instance points
var _insPoints = [	new Vec2(mX1, mY1),
					new Vec2(mX2, mY1),
					new Vec2(mX2, mY2),
					new Vec2(mX1, mY2) ];

// Clear collision list
ds_list_delete_all(global.colList);
var totalCol = 0, returnBool = false;
// For all collisions
for (var i = 0; i < array_length(collisionArray); i++) { totalCol += collision_rectangle_list(mX1, mY1, mX2, mY2, collisionArray[i], false, true, global.colList, false); };

// Get all collisions
for (var i = 0; i < totalCol; i++) {
	// Get collision ID
	var colIns = global.colList[| i];
	if (!instance_exists(colIns)) { continue; };
	// Top left is in collision
	returnBool = polygon_intersect_polygon(colIns.colPoints, _insPoints);
	if (returnBool) { break; };
	//returnBool = point_in_polygon(mX1, mY1, totalCol.colPoints);
	// Not? right top
	//if (!returnBool) { returnBool = point_in_polygon(mX2, mY1, totalCol.colPoints); };
};

return returnBool;

};

/// @description Basically round function with a little mod
function superRound(value) {

// Get decimal part of the number
var decimalPart = abs(value) - floor(abs(value));

// It's more than 0.5
if (decimalPart > 0.5) { return ceil(value); } else { return floor(value); };

};
