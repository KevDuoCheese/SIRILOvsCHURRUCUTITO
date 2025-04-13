
// create debug values struct
global.debugValues = { };

/// @description get debug value 
function debugVGetValue(debugId, defV = false) {

// return it
return structRead(global.debugValues, debugId, defV);

};

/// @description set debug value 
function debugVSetValue(debugId, setValue) {

// set directly
global.debugValues[$ debugId] = setValue;

};

/// @description chang eit
function debugVSwitchBool(debugId) {

// and switch it
global.debugValues[$ debugId] = !debugVGetValue(debugId);

};