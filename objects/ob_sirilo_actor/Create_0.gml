/// @description Do the normal animation
depth = 15;

// set the phase
sprite_index = sp_sirilo_idle;
image_index = 0;
image_speed = 1;

// set the size
image_xscale = 2;
image_yscale = 2;

// and if playing animation
playingAnimation = false;
playingType = 0;
playingFlag = false;
// 0 - end
// 1 - end and quiet
// 2 - loop

animationTree = {
	"idle": sp_sirilo_idle,
	"plin_prepare": sp_sirilo_plin_prepare,
	"plin_attack": sp_sirilo_plin_attack
};

// to play an animation
animPlay = function (_animName, _animIndex = 0, _animSpeed = 1, _animType = 0) {
	
	// set it
	sprite_index = animationTree[$ _animName];
	// yup to be normal here
	image_index = _animIndex;
	image_speed = _animSpeed;
	// and the type
	playingAnimation = true;
	playingType = _animType;
	
	// reset flag
	playingFlag = false;
};

animStop = function () {
	// back to normal
	
	// reset back to idle animation
	sprite_index = animationTree.idle;
	image_index = 0;
	image_speed = 1;
	// not anymore bro
	playingAnimation = false;
};