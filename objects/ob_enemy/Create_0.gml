/// @description 
depth = 25;

mainAnimationOb = new eAnimObjectCreate("main", 0, 0);
mainAnimationOb.parent = id;

// Create the animation object
animationOb = new eAnimObjectCreate("mainSponge", 0, 0);
mainAnimationOb.elementAdd(animationOb);

moscaHandlerOb = new eAnimObjectCreate("moscaHandler", 0, 0);
mainAnimationOb.elementAdd(moscaHandlerOb);

animationOb.elementAdd(eAnimSpriteCreateDefault("leftLeg", 11, 1, sp_keseso_left_leg, -8)); //16 extra y
animationOb.elementAdd(eAnimSpriteCreateDefault("rightLeg", -13, 4, sp_keseso_right_leg, -8)); //18 extra y

var _moscaSpr = eAnimSpriteCreateDefault("mosca", 0, -70, sp_mosca, -50);
var _mosca2Spr = eAnimSpriteCreateDefault("mosca2", 0, -50, sp_mosca, -50);
moscaHandlerOb.elementAdd(_moscaSpr);
moscaHandlerOb.elementAdd(_mosca2Spr);
_moscaSpr.animPlay("default");
_mosca2Spr.animPlay("default");


// this will take on count too
var _faceOb = new eAnimObjectCreate("faceOb", 0, 0);
_faceOb.elementAdd(eAnimSpriteCreateDefault("mouth", 1, -15, sp_keseso_mouth, -15));
_faceOb.elementAdd(eAnimSpriteCreateDefault("eyes", 2, -33, sp_keseso_eyes, -16));

_faceOb.elements.eyes.animIndex = 1;


var _upperBodyOb = new eAnimObjectCreate("upperBodyOb", -1, -13);
// all upper body parts will take on count the offset : -1, -13, so well add 1 and 13 (inverse)
_upperBodyOb.elementAdd(eAnimSpriteCreateDefault("body", 0, 0, sp_keseso_body, -10));
_upperBodyOb.elementAdd(eAnimSpriteCreateDefault("leftArm", 19, -9, sp_keseso_left_arm, -8));
_upperBodyOb.elementAdd(eAnimSpriteCreateDefault("rightArm", -18, -10, sp_keseso_right_arm, -8)); // this was -19 and -23 :)

_upperBodyOb.elementAdd(_faceOb);
animationOb.elementAdd(_upperBodyOb);


animationOb.elements.upperBodyOb.elements.faceOb.elements.mouth.animPlay("default");

mainAnim = new eAnimAnimationCreate("mainAnim", eAnimAnimType.groupAnimcurve, an_keseso_idle_main, false, eAnimRepeatType.loop);
animationOb.elementAdd(mainAnim);
mainAnim.animPlay();

upperBodyAnim = new eAnimAnimationCreate("upperBodyAnim", eAnimAnimType.groupAnimcurve, an_keseso_idle_upper_body, false, eAnimRepeatType.loop);
_upperBodyOb.elementAdd(upperBodyAnim);

upperBodyAnim.animLinkValueToAnim(mainAnim);
upperBodyAnim.animPlay();

var _moscaAnim = new eAnimAnimationCreate("moscaAnim", eAnimAnimType.groupAnimcurve, an_keseso_idle_mosca, false, eAnimRepeatType.loop);
moscaHandlerOb.elementAdd(_moscaAnim);
_moscaAnim.animPlay();

upperBodyBounceAnim = new eAnimAnimationCreate("upperBodyBounceAnim", eAnimAnimType.groupAnimcurve, an_keseso_bounce_main, false, eAnimRepeatType.endloop);
animationOb.elementAdd(upperBodyBounceAnim);

upperBodyBounceAnim.animSetFunctionEnd(function () {
    
    // play the other
    parent.parent.parent.mainAnim.animPlay();
	//parent.parent.parent.upperBodyAnim.animReset();
});


eyesSpr = _faceOb.elements.eyes;
eyesBef = eyesSpr.animIndex;
eyesTimerMax = 10;
eyesTimer = 0;
eyesTimerActive = false;

// save up health here
healthValueMax = 1000;
healthValue = healthValueMax;
// for the phases now
phase = "idle";

// on hurt mode
hurtHealthSave = 0;
hurtHealthSpeed = 0;
// hurt offset
hurtOffsetX = 0;
hurtOffsetY = -80;

// to hurt enemy
enemyHurt = function (_hurtValue) {
	// to hurt him
	phase = "hurt";
	// play the animation
	animationPlay("hurt");
	
	// create a jumpanimation
	var _jumpNumber = instance_create_depth(x + hurtOffsetX, y + hurtOffsetY + 10, 0, ob_hit_enemy_number, {
		myText : string(_hurtValue)
	});
	
	// on hurt mode
	hurtHealthSave = healthValue;
	// decrease it
	healthValue = approachValue(healthValue, 0, _hurtValue);
	hurtHealthSpeed = (hurtHealthSave - healthValue) / timerGet(1.5);
};



// animation playing
animationPlaying = "idle";
animationPlayingSettings = -1;
// if ended or aomething
animationFlag = false;

animationDefault = {
	"hurt": {
		type: "sprite_only",
		spriteIndex : sp_keseso_hurt,
		imageIndex : 0,
		imageSpeed : 0,
		doFunction: function (_myId) {
			// set effect
			_myId.effectPlaying = "shake";
			_myId.effectShakeTimerMax = timerGet(1.5);
			_myId.effectShakeTimer = _myId.effectShakeTimerMax;
			_myId.effectShakeStrength = 15;
			// change end function
			_myId.effectEndFunction = method(_myId, function () {
				// and back to it
				animationStop();
			});
		}
	},
	
	"idle": {
		type: "animation_play",
		animationOb : mainAnimationOb,
		animationId : 0,
		loops: 1 // yes it loops
	}
};

animationSettings = {
	
};

// no effect playing
effectPlaying = "";
// effect end thing
effectEndFunction = -1;
// fpr shake
effectShakeTimer = 0;
effectShakeTimerMax = 0;
effectShakeStrength = 5;

animationPlay = function (_animId) {
	// what to play bro?
	
	// can be found?
	if (struct_exists(animationSettings, _animId)) {
		// yup
		animationPlayingSettings = animationSettings[$ _animId];
	} else {
		// do the default one
		animationPlayingSettings = animationDefault[$ _animId];
	};
	// exists do function?
	if (struct_exists(animationPlayingSettings, "doFunction")) {
		animationPlayingSettings.doFunction(id);
	};
};

animationStop = function () {
	// just stop it and call the flag
	animationFlag = true;
	// and stop it
	animationPlay("idle");
};

animationIsPlaying = function () {
	// if not playing idle, is playing something
	return (animationPlaying != "idle");
};



// for animations
xDrawOffset = 0;
yDrawOffset = 0;
yDrawScale = 1;
xDrawScale = 1;

// play the idle animation
animationPlay("idle");