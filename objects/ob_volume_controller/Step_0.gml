/// @description Control volume animations and itself

// Hide timer is over and hasn't hide yet
if (hideTimer > 0) { hideTimer--; } else {
	
	// Approach Y to 0
	yPos = lerp(yPos, 0, 0.2);
	// Reaching 0
	if (roundDecimal(yPos, 2) <= 0) { yPos = 0; };
};

// Reduce shake timer
if (shakeEffectTimer > 0) { shakeEffectTimer--; };

// Press volume up or down keys
var _volumeShift = keyboard_check_pressed(vk_add) - keyboard_check_pressed(vk_subtract);
// Now adjust it
if (_volumeShift != 0) {
	
	// Change volume value
	global.volumeValue += 0.1 * _volumeShift;
	global.volumeValue = clamp(global.volumeValue, 0, 1);
	// Play sound
	audio_replay_sound(so_volume, 1, false);
	
	// Shake it bro
	if (yPos < 1) { shakeEffectTimer = shakeEffectTimerMax; };
	// Set hide tiemr and Y position
	hideTimer = hideTimerMax;
	yPos = 1;
};