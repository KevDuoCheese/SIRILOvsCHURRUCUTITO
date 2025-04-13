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

//show_debug_message(mainAnimationOb)