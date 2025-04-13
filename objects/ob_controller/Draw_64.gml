/// @description 
drawPreset("general");

if (game_is_compiled()) {
	draw_set_alpha(0.55);
	draw_set_halign(fa_right);
	draw_text_transformed(screen.width - 3, 3, "KesoAzul", 1, 1, 0);
	draw_set_halign(fa_left);
	draw_set_valign(fa_bottom);
	draw_text_transformed(2, screen.height - 2, string(GM_version) + " 2024|DEV BUILD", 1, 1, 0);
	drawReset();
};

if (global.debugMode) {
	
	drawPreset("small");
	draw_set_valign(fa_bottom);
	
	draw_text_outline(1, screen.height - 1, 
						"G + F1 - show/hide log" + "\n" +
						"T + F1 - delete config file" + "\n" +
						"T + F2 - forced reset" + "\n" +
						"W + F3 - screen size up" + "\n" +
						"S + F3 - screen size down" + "\n" +
						"DEBUG MODE F9");
	
	drawReset();
};


// Adjust escape timer
if (escapeKeyTimer > 0) {
	
	var _limitAlpha, _dots;
	_limitAlpha = clamp(remap(escapeKeyTimer, timerGet(0.35), timerGet(0.55), 0, 1), 0, 1);
	_dots = remap(escapeKeyTimer, 0, escapeKeyTimerMax, 0, 4);
	// Adjust alpha
	draw_set_alpha(_limitAlpha);
	var _drawT = languageGet("quitting_msg");
	repeat (_dots) { _drawT += "."; };
	draw_text_outline(2, 2, _drawT);
	drawReset();
};

drawPreset("general");

//drawTextSpecial(2, 2, "hola putos /w|2|LOL/w|1|/e/h|2|me pican los cocos /p|SHIFT|/e/h|1|/s5hola mamá/s0");