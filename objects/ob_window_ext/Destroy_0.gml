/// @description HAs opwner?
if (instance_exists(depthOwner)) {
	
	// Search on his windows array
	for (var i = 0; i < array_length(depthOwner.windowsDepth[depthLevel]); i++) {
		
		// Found me
		if (depthOwner.windowsDepth[depthLevel][i] == depthId) {
			// GOTCHA
			array_delete(depthOwner.windowsDepth[depthLevel], i, 1);
			break;
		};
	};
};



















