/// @description 
if (!drawCan(viewId.draw)) { exit; };

// switch type
switch (animationPlayingSettings.type) {
	// in case of the thing
	case "animation_play":
		
		eAnimDrawStart();
		
		// Draw the object in the place
		eAnimObjectDrawOrder(animationPlayingSettings.animationOb, x + xDrawOffset, y + yDrawOffset);
		
		eAnimDrawEnd();
	break;
	
	// in case of the sprite
	case "sprite_only":
		
		eAnimDrawStart();
		
		// Draw the object in the place
		draw_sprite_ext(animationPlayingSettings.spriteIndex, animationPlayingSettings.imageIndex, 
						x + xDrawOffset, y + yDrawOffset,
						image_xscale * xDrawScale, image_yscale * yDrawScale,
						image_angle, image_blend, image_alpha);
		
		eAnimDrawEnd();
	break;
};

// enemy phases
switch (phase) {
	// in hurt one?
	case "hurt":
		// draw the bar in position
		var _barX, _barY, _barW, _barH;
		_barW = 80;
		_barH = 10;
		// and the pos
		_barX = (x + hurtOffsetX) - (_barW * 0.5);
		_barY = y + hurtOffsetY;
		
		// and draw here the shit
		draw_sprite_stretched_ext(sp_11box, 0, _barX, _barY, _barW, _barH, COLOR_BLACK, 1);
		draw_sprite_stretched_ext(sp_11box, 0, _barX + 1, _barY + 1, _barW - 2, _barH - 2, COLOR_MAROON, 1);
		// and for the green bar
		draw_sprite_stretched_ext(sp_11box, 0, _barX + 1, _barY + 1, (_barW - 2) * (hurtHealthSave / healthValueMax), _barH - 2, COLOR_LIME, 1);
	break;
};