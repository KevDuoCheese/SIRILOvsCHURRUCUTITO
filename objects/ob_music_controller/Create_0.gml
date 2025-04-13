/// @description Adjust main variables

// Create the music list, higher value, first song to play
musicList = [ /*[ repeat music, init ]*/ ];

// Last repeat music ID
musicLastId = -1;
// If playing the init part
musicInitPhase = 0;
/*
0 - Just to play the sound
1 - Sound, playing
2 - Ended
*/

// Playing music instance ID
musicPlayingId = -1;
// Playing asset my man
musicPlayingAsset = -1;

// If the music is stopped
musicStop = false;


// To make effect or something on music layers
musicPitch = 1;
// Adjust "volume" of music
musicGain = 1;

// To avoid changing always
musicLastPitch = musicPitch;
musicLastGain = musicGain;





