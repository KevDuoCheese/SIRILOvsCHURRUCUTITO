
/// @description Plays the sound again to avoid overlapping
function audio_replay_sound(index, priority, loops, gain = 1, offset = 0, pitch = 1) {

// Stop sound anyways, if not playing nothing happens
audio_stop_sound(index);
// Play sound again, now with specified data
return audio_play_sound(index, priority, loops, gain, offset, pitch);

};

/// @description Wait to the sound to end before playing it again
function audio_waittoplay_sound(index, priority, loops, gain = 1, offset = 0, pitch = 1) {

// Prepare the return struct
var _returnData = { id: index, could: false };

// Wait till the sound doesn't play anymore
if (!audio_is_playing(index)) {
	
	// Play sound again, now with specified data
	_returnData.id		 = audio_play_sound(index, priority, loops, gain, offset, pitch);
	_returnData.could	 = true;
};

return _returnData;

};