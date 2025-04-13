/// @description 
wallSize = 5;
depth = 20;

// About scale
image_xscale = TILE_SIZE * 5;
image_yscale = TILE_SIZE * 5;

// Create the walls
wallLeft = instance_create_depth(x - (image_xscale / 2), y - (image_yscale / 2), 0, ob_wall, {
	image_xscale : wallSize,
	image_yscale : image_yscale
});

wallRight = instance_create_depth(x + (image_xscale / 2) - wallSize, y - (image_yscale / 2), 0, ob_wall, {
	image_xscale : wallSize,
	image_yscale : image_yscale
});

wallTop = instance_create_depth(x - (image_xscale / 2), y - (image_yscale / 2), 0, ob_wall, {
	image_xscale : image_xscale,
	image_yscale : wallSize
});

wallBottom = instance_create_depth(x - (image_xscale / 2), y + (image_yscale / 2) - wallSize, 0, ob_wall, {
	image_xscale : image_xscale,
	image_yscale : wallSize
});

fwallUpdate = function (wallId, newX, newY, newAngle) {

with (wallId) {
	if (newY != y) { colMovMoveY(newY - y); };
	if (newX != x) { colMovMoveX(newX - x); };
	if (newAngle != image_angle) { colMovRotate(newAngle - image_angle); };
};

};