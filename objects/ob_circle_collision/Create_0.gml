/// @description 

var _finalColPoints = [ ];

image_yscale = image_xscale;

circleExRad = 4;
circleRadius = (image_xscale * TILE_SIZE) - circleExRad;
circleIterations = 16;
angleSlice = 360 / circleIterations;

// Internal radius vertex here
for (var i = 0; i <= circleIterations; i++) {
	
	var _an = i * angleSlice;
	
	// Save point to angle
	array_push(_finalColPoints, new Vec2(x + lengthdir_x(circleRadius, _an), y + lengthdir_y(circleRadius, _an)));
};

// External radius vertex then
for (var i = 0; i <= circleIterations; i++) {
	
	var _an = -i * angleSlice;
	
	// Save point to angle
	array_push(_finalColPoints, new Vec2(x + lengthdir_x(circleRadius + circleExRad, _an), y + lengthdir_y(circleRadius + circleExRad, _an)));
};

// And create collision here
script_execute_ext(colCreate, _finalColPoints);
// Update my bro
colUpdate();