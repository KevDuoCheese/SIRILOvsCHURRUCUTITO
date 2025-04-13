/// @description Destroy all shit in game

// LOokout for surfaces
var _surfKey = ds_map_find_first(global.surfaceMap);
repeat (ds_map_size(global.surfaceMap)) {
	
	// Check for surface
	if (surface_exists(global.surfaceMap[? _surfKey])) { surface_free(global.surfaceMap[? _surfKey]); };
	// Get next
	_surfKey = ds_map_find_next(global.surfaceMap, _surfKey);
};
// Kill list
ds_list_clear(global.colList);


















