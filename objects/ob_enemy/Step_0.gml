/// @description 

// Update object
mainAnimationOb.stepEvent();

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