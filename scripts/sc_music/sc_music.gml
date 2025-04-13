
/// @description Stops music, if played again, starts from init
function musicResetStop() {

// Activate object music stop
ob_music_controller.musicStop = true;

};

/// @description If music is stopped, this resumes it
function musicResetResume() {

// Reactivate the music man
ob_music_controller.musicStop = false;

};

/// @description If music is stopped, this resumes it
function musicPause() {

// Pause the current playing song
audio_pause_sound(ob_music_controller.musicPlayingId);

};

/// @description Resume the music if paused
function musicResume() {

// Only if audio is paused
if (audio_is_paused(ob_music_controller.musicPlayingId)) {
	// resume the audio
	audio_resume_sound(ob_music_controller.musicPlayingId);
};

};

/// @description Get last music layer added
function musicGetLastLayer() {

// Get music list length
return array_length(ob_music_controller.musicList) - 1;

};

/// @description Add layer to music
/// @param {asset.GMSound}		 musicId	 Music Asset ID
/// @param {asset.GMSound}		 initId		 Start part of the song
function musicAddLayer(musicId, initId = -1) {

// Add a new layer on it
array_push(ob_music_controller.musicList, [ musicId, initId ]);
return array_length(ob_music_controller.musicList) - 1;

};

/// @description Change music in layer
/// @param {real}				 layerId	 Layer to change
/// @param {asset.GMSound}		 musicId	 Music Asset ID
/// @param {asset.GMSound}		 initId		 Start part of the song
function musicChangeLayer(layerId, musicId, initId = -1) {

// Get array ID
var allMusicList = ob_music_controller.musicList;

// Layer doesn't exists
if (array_length(allMusicList) <= layerId) {
	
	// Add empty layer till reach own
	repeat (layerId - array_length(allMusicList)) { musicAddLayer(-1, -1); };
	// Add layer to music my man
	musicAddLayer(musicId, initId);
} else {
	
	// Modify that layer
	allMusicList[layerId][0] = musicId;
	// Change init part
	allMusicList[layerId][1] = initId;
};

};

/// @description Deletes a music layer
function musicDeleteLayer(layerId) {

// Get array ID
var allMusicList = ob_music_controller.musicList;

// Layer indeed, exists
if (array_length(allMusicList) > layerId) {
	
	// Delete that layer
	array_delete(allMusicList, layerId, 1);
};

};

/// @description Delete last layer
function musicDeleteLast() {

// Get array ID
var musicListLength = array_length(ob_music_controller.musicList);

// Delete last layer anyways
if (musicListLength > 0) { musicDeleteLayer(musicListLength - 1); };

};

/// @description Delete all existent layers
function musicDeleteAll() {

// Get array ID
var musicListLength = array_length(ob_music_controller.musicList);
// Delete each one of them
repeat (musicListLength) { musicDeleteLast(); };

};

/// @description Adjust music sound pitch
function musicSetPitch(newPitch) {

// Set to asked pitch
ob_music_controller.musicPitch = newPitch;

};

/// @description Adjust music sound gain (volume)
function musicSetGain(newGain) {

// Set to asked gain
ob_music_controller.musicGain = newGain;

};

/// @description Obtain actual gain from playing music
function musicGetGain() { return ob_music_controller.musicGain; };
/// @description Obtain actual pitch from playing music
function musicGetPitch() { return ob_music_controller.musicPitch; };

function musicIsPlaying() {

return audio_is_playing(ob_music_controller.musicPlayingId);

};

function musicGetTrackPosition() {

// Only if is playing return time
if (audio_is_playing(ob_music_controller.musicPlayingId)) {
	return audio_sound_get_track_position(ob_music_controller.musicPlayingId);
};

return 0;

};

function musicSetTrackPosition(newTrackPos) {

// Set the playing music time
if (audio_is_playing(ob_music_controller.musicPlayingId)) {
	audio_sound_set_track_position(ob_music_controller.musicPlayingId, newTrackPos);
};

};