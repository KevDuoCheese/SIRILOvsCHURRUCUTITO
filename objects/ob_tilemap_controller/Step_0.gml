/// @description Update dpth if it's required

// Only if using dynamic depth mode
if (dynamicDepth) {
	// Adjust to using depth
	layer_depth(layerId, -(depthSave - cameraGetY()));
};



















