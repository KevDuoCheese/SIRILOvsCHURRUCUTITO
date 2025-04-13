
// @description Get value of a flag, if doesn't exists uses the default value
function flagGet(flagId, defV = false) {

// Get value
if (ds_map_exists(global.flagValue, flagId)) {
	return global.flagValue[? flagId];
};

// Set the flag and return default value
global.flagValue[? flagId] = defV;
return defV;

};

/// @description Set a value to a flag
function flagSet(flagId, newV) {

// Set the flag
global.flagValue[? flagId] = newV;

};