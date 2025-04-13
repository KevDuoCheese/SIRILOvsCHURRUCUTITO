/// @description draw it
if (drawCan(viewId.gui)) {

mainCore.drawCall();

};

if (drawCan(viewId.draw)) {

shader_set(sh_loop_uvs);

// save here the uvs
var _sprUvs = [];
array_copy(_sprUvs, 0, sprite_get_uvs(sp_ae_bg, 0), 0, 4);
// save up the size of the sprite too
var _sprW, _sprH;
_sprW = sprite_get_width(sp_ae_bg);
_sprH = sprite_get_height(sp_ae_bg);

// get the background position
var _bgPosX, _bgPosY, _bgPosW, _bgPosH;
_bgPosW = (ceil(cameraGetWidth() / _sprW) + 1) * _sprW;
_bgPosH = (ceil(cameraGetHeight() / _sprH) + 1) * _sprH;
// loop here the position
_bgPosX = floor(cameraGetX() / _sprW) * _sprW;
_bgPosY = floor(cameraGetY() / _sprH) * _sprH;

shader_set_uniform_f_array(uniformLoopUvsUvs, _sprUvs);
shader_set_uniform_f(uniformLoopUvsSize, 
				_sprW,
				_sprH);
shader_set_uniform_f(uniformLoopUvsPosition, 
				_bgPosX,
				_bgPosX);
// draw all the shit in place
draw_sprite_stretched(sp_ae_bg, 0, _bgPosX, _bgPosY, _bgPosW, _bgPosH);

shader_reset();


draw_set_color(c_white);
draw_set_alpha(0.5);
// get the real position
draw_line(cameraGetX() - 1, 0 - 1, cameraGetX() + cameraGetWidth() + 1, 0 - 1);
draw_line(0 - 1, cameraGetY() - 1, 0 - 1, cameraGetY() + cameraGetHeight() + 1);

draw_set_alpha(1);





// start for each
eAnimDrawStart();

// get all the data
var _objectNames = struct_get_names(objectData);
// one by one
for (var i = 0; i < array_length(_objectNames); i++) {
	// get it
	var _objectId = objectData[$ _objectNames[i]];
	// yup? add it
	eAnimObjectDrawOrder(_objectId, _objectId.x, _objectId.y);
};

// end it
eAnimDrawEnd();

// adjust here
var _camUISize = cameraGetWidth() / surfaceGUIGetWidth();

// updaet this
objectPositionDataUpdate();
// draw it all
objectPositionDataDraw(_camUISize);
// there is a selected obejct?
if (objectPositionDataSelectedExists()) {
	
	// get data
	var _dataOfSelected = objectPositionDataGetSelected();
	
	// object or sprite
	if ((is_struct(_dataOfSelected)) && (_dataOfSelected.type == eAnimType.object || _dataOfSelected.type = eAnimType.sprite)) {
		
		// draw in main thing
		draw_sprite_ext(sp_ae_cursor, 0, _dataOfSelected.mainX, _dataOfSelected.mainY, _dataOfSelected.mainXScale * _camUISize, _dataOfSelected.mainYScale * _camUISize, _dataOfSelected.mainAngle, c_white, 1);
		
		// set color X
		draw_set_color(c_red);
		// draw the arrow
		draw_arrow(	_dataOfSelected.mainX + lengthdir_x(_camUISize * 16, _dataOfSelected.angleOff) - 1,
					_dataOfSelected.mainY + lengthdir_y(_camUISize * 16, _dataOfSelected.angleOff) - 1,
					_dataOfSelected.mainX + lengthdir_x(_camUISize * 48, _dataOfSelected.angleOff) - 1,
					_dataOfSelected.mainY + lengthdir_y(_camUISize * 48, _dataOfSelected.angleOff) - 1,
					8 * _camUISize);
		// set color Y
		draw_set_color(c_lime);
		// draw the arrow
		draw_arrow(	_dataOfSelected.mainX + lengthdir_x(_camUISize * 16, _dataOfSelected.angleOff - 90) - 1,
					_dataOfSelected.mainY + lengthdir_y(_camUISize * 16, _dataOfSelected.angleOff - 90) - 1,
					_dataOfSelected.mainX + lengthdir_x(_camUISize * 48, _dataOfSelected.angleOff - 90) - 1,
					_dataOfSelected.mainY + lengthdir_y(_camUISize * 48, _dataOfSelected.angleOff - 90) - 1,
					8 * _camUISize);
		
		// to rotate
		draw_sprite_ext(sp_ae_rotate, 0,
						_dataOfSelected.mainX - vector2XAngled(16, 16, _dataOfSelected.mainAngle) * _camUISize,
						_dataOfSelected.mainY - vector2YAngled(16, 16, _dataOfSelected.mainAngle) * _camUISize,
						_camUISize, _camUISize,
						_dataOfSelected.mainAngle, c_white, 1)
	};
};

};






