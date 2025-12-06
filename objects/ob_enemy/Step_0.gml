/// @description 

// switch type
switch (animationPlayingSettings.type) {
	// in case of sprite
	case "sprite_only":
		
		// Do the object animation
		animationPlayingSettings.imageIndex += animationPlayingSettings.imageSpeed;
		// reahed max
		if (animationPlayingSettings.imageIndex >= sprite_get_number(animationPlayingSettings.spriteIndex)) {
			// reset it
			animationPlayingSettings.imageIndex = 0;
		};
	break;
	
	// in case of the thing
	case "animation_play":
		
		// Do the object animation
		animationPlayingSettings.animationOb.stepEvent();
	break;
};

// which effeect are you playing my bro
switch (effectPlaying) {
	case "shake": 
		
		// acoording to shake timer
		xDrawOffset = randomShaking(power(effectShakeTimer / effectShakeTimerMax, 2) * effectShakeStrength);
		// decraese it
		if (effectShakeTimer > 0) { effectShakeTimer--; } else {
			// no more playing
			effectPlaying = 0;
			// reset this
			xDrawOffset = 0;
			// no more playing
			if (effectEndFunction != -1) { effectEndFunction(); };
			break;
		};
	break;
};

// enemy phases
switch (phase) {
	case "idle":
		// do nothing
	break;
	
	case "hurt":
		// in this state we will wait until it does the thing
		// approach hurt save
		hurtHealthSave = approachValue(hurtHealthSave, healthValue, hurtHealthSpeed);
		// reached 0?
		if ((hurtHealthSave == healthValue) && (!animationIsPlaying())) {
			// we can proceed
			phase = "idle";
		};
	break;
};

var _mouthOb = animationOb.elements.upperBodyOb.elements.faceOb.elements.mouth;

if (keyboard_check_pressed(ord("G"))) {
    if (_mouthOb.animIsPlaying()) {
        _mouthOb.animStop(true);
    } else {
        _mouthOb.animPlay("default");
    };
};

if (keyboard_check_pressed(ord("J")) && !eyesTimerActive) {
    eyesTimer = eyesTimerMax;
    eyesTimerActive = true;
    eyesBef = eyesSpr.animIndex;
    eyesSpr.animIndex = 2;
    
    upperBodyBounceAnim.animPlay();
};

if (eyesTimerActive) {
    if (eyesTimer > 0) { eyesTimer--; } else {
        if (eyesBef == 0)
            { eyesSpr.animIndex = 1; }; 
        if (eyesBef == 1)
            { eyesSpr.animIndex = 0; };
        
        
        eyesTimerActive = false;
    };
};
//*/