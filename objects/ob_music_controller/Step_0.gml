/// @description 

// Get the length of this shit
var musicListLength = array_length(musicList);

// Has length on it
if (musicListLength > 0) {
	
	// Get last music ID variables
	var musicData = musicList[musicListLength - 1];
	
	// Last music ID is not own
	if (musicLastId != musicData[0]) { musicInitPhase = 0; musicLastId = musicData[0]; if (audio_is_playing(musicPlayingId)) { audio_stop_sound(musicPlayingId); }; };
	// Audio is stopped or not
	if (musicStop) { if (audio_is_playing(musicPlayingId)) { audio_stop_sound(musicPlayingId); }; musicInitPhase = 0; } else {
		
		// Get playing music
		var musicToPlay;
		// Hasn't init
		if (musicData[1] == -1) { musicInitPhase = 2; };
		// IS on first lists
		if (musicInitPhase < 2) { musicToPlay = musicData[1]; } else { musicToPlay = musicData[0]; };
		
		// Is not playing
		if (!audio_is_playing(musicToPlay)) {
			
			// Is on init playing
			if (musicInitPhase == 1) {
				
				// Add init phase
				musicInitPhase++;
				// Update to play music
				musicToPlay = musicData[0];
				// Play next song
				musicPlayingId = audio_replay_sound(musicToPlay, 100, true, musicGain, 0, musicPitch);
				musicPlayingAsset = musicToPlay;
			} else {
				
				// Is the init phase
				if (musicInitPhase == 0) {
					
					// Play start part of the song, no looping
					musicPlayingId = audio_replay_sound(musicToPlay, 100, false, musicGain, 0, musicPitch);
					// Next phase
					musicInitPhase = 1;
				} else {
					
					// Play wanted song
					musicPlayingId = audio_replay_sound(musicToPlay, 100, true, musicGain, 0, musicPitch);
				};
				
				// Update playing asset
				musicPlayingAsset = musicToPlay;
			};
		};
		
		// Music ID is not what we wanted
		if (musicPlayingAsset != musicToPlay) {
			// Stop music ID
			audio_stop_sound(musicPlayingId);
			// Is the init phase
			if (musicInitPhase == 0) {
				
				// Play start part of the song, no looping
				musicPlayingId = audio_replay_sound(musicToPlay, 100, false, musicGain, 0, musicPitch);
				// Next phase
				musicInitPhase = 1;
			} else {
					
				// Play wanted song
				musicPlayingId = audio_replay_sound(musicToPlay, 100, true, musicGain, 0, musicPitch);
			};
			// Update playing asset
			musicPlayingAsset = musicToPlay;
		};
	};
	
} else {
	
	// Stop playing music
	if (audio_is_playing(musicPlayingId)) { audio_stop_sound(musicPlayingId); };
};

// Is playing?
if (audio_is_playing(musicPlayingId)) {
	// Changed gain
	if (musicLastGain != musicGain) {
		audio_sound_gain(musicPlayingId, musicGain, 0)
		musicLastGain = musicGain;
	};
	// Changed pitch
	if (musicLastPitch != musicPitch) {
		audio_sound_pitch(musicPlayingId, musicPitch);
		musicLastPitch = musicPitch;
	};
};


