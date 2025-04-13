/// @description Main room events and init change

// Save config
configSave();
// Lookat room
switch (room) {
	
	case rm_init:
		room_goto_next();
		
	break;
};

// Turn off
for (var i = 0; i <= 7; i++) { view_set_visible(i, false); };

#region Add tileset visibly

// Get all layers
var _layerTotal = layer_get_all();

// Loop it
for (var i = 0; i < array_length(_layerTotal); i++) {
	
	// Get this layer ID
	var _layerId = _layerTotal[i];
	// Get tilemap id
	var _layerTilemap = layer_tilemap_get_id(_layerId);
	// Get background id
	var _layerBackground = layer_background_get_id(_layerId);
	
	// Has tilemap
	if (_layerTilemap != -1) {
		// GEt tilemap name
		var _tilemapLayer = layer_get_name(_layerTotal[i]);
		var _useDynamicDepth = false;
		// Has "DE" on start
		if (string_copy(_tilemapLayer, 1, 2) == "de") { _useDynamicDepth = true; };
		
		
		// Create for this layer
		instance_create_depth(0, 0, 0, ob_tilemap_controller, { layerName: layer_get_name(_layerTotal[i]), dynamicDepth : _useDynamicDepth });
		continue;
	};
	// Has background
	if (_layerBackground != -1) {
		
		// Create for this layer
		instance_create_depth(0, 0, 0, ob_background_controller, { layerName: layer_get_name(_layerTotal[i]) });
		continue;
	};
};

#endregion