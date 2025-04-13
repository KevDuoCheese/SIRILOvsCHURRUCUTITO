/// @description 
depth = 80;

// And save in here
cpPallete = shader_get_uniform(sh_pallete16, "palleteArr");

// Create a color pallete with all of this
colorPallete15 = 
	array_concat(
		colorToFloatArray(#000018),
		colorToFloatArray(#000030),
		colorToFloatArray(#000048),
		colorToFloatArray(#000060),
		colorToFloatArray(#000078),
		colorToFloatArray(#000098),
		colorToFloatArray(#0000b0),
		colorToFloatArray(#0000c8),
		colorToFloatArray(#0000e0),
		colorToFloatArray(#0000e0),
		colorToFloatArray(#880020),
		colorToFloatArray(#680048),
		colorToFloatArray(#400050),
		colorToFloatArray(#100030),
		colorToFloatArray(#000018));

colorPalleteSurf = -1;

timePlaying = currentFrame();
canPlay = true;

trdsUniforms();