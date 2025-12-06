/// @description So, lets check this out
var _pActor = ob_buttons_handler.playerActor;

switch (phase) {
	case 0:
		// prepare plin attack
		_pActor.animPlay("plin_prepare", 0, 1, 1);
		phase = 1;
	break;
	
	case 1:
		// approach
		cameraSetZoom(cameraGetZoom() + camZoomIncrease);
		// did end?
		if (_pActor.playingFlag) {
			// wait a bit for intensity
			phase = 2;
			break;
		};
	break;
	
	case 2:
		// approach
		cameraSetZoom(cameraGetZoom() + camZoomIncrease);
		// wait for it
		if (plinWait > 0) { plinWait--; } else {
			// doesnt exists the buttons handler?
			if (!instance_exists(ob_punch)) {
				// play the PLIN animation
				_pActor.animPlay("plin_attack");
				// play sound
				audio_replay_sound(so_punch_plin, 2, false, 2);
				
				// calculate the final damage
				var _idealDamage = 100;
				// plin power
				var _plinPowerDamage = max(floor((_idealDamage * 0.25) + (power(plinPower, 2) * _idealDamage * 0.75)), 1);
				// play the hurt animation
				global.enemyInstance.enemyHurt(_plinPowerDamage);
				// play the plin sound
				audio_replay_sound(so_enemy_punch_hurt_common, 10, false);
				phase = 3;
				break;
			};
		};
	break;
	
	case 3:
		// did flag?
		if (_pActor.playingFlag) {
			canDestroy = true;
		};
		// now approach back
		cameraSetZoom(approachValue(cameraGetZoom(), camOcZoom, 0.25));
		// reached it?
		if ((cameraGetZoom() == camOcZoom) && canDestroy && (global.enemyInstance.phase != "hurt")) {
			instance_destroy();
			exit;
		};
	break;
};