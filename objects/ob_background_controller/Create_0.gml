/// @description Adjust layer and background ID and script for layer

// Has a layer name specified
if (layerName != "") {
	
	// ---- We doesn't init this variables before to create this object with pre-variables struct ----
	
	// Get ID and background ID too
	layerId			 = layer_get_id(layerName);
	backgroundId	 = layer_tilemap_get_id(layerId); // Every tilemap layer has his unique tilemap ID
};

// Begin script for my very own layer
layer_script_begin(layerId, function (lyId = layerId, tlId = backgroundId) {
	// It's draw event
	if (event_type == ev_draw) {
		// Draw event (not GUI or something like that)
	    if (event_number == ev_draw_normal) {
			
			// It's not on first view
			if (!drawCanDraw(viewId.draw) && !drawCanDraw(viewId.world_map) && !drawCanDraw(viewId.arcade)) {
				// Disable this view visibility
				gpu_set_blendmode_ext(bm_zero, bm_one);
				
			} else {
				
			};
	    };
	};
});
// end of draw event
layer_script_end(layerId, function (lyId = layerId, tlId = backgroundId) {
	// It's draw
	if (event_type == ev_draw) {
		// Draw event
	    if (event_number == ev_draw_normal) {
			
			// It's on required view
			if (drawCanDraw(viewId.draw) || drawCanDraw(viewId.world_map) || drawCanDraw(viewId.arcade)) {
				
				
			} else {
				
				// Enable again
				gpu_set_blendmode(bm_normal);
			};
	    };
	};
});

