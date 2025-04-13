/// @description Draw the stupid window

// Reset GUI shader
surfaceGUICustomShader();

// Draw the nineslice
draw_d_nineslice(x, y, image_xscale, image_yscale);

// Back to GUI normal thing
surfaceGUIResetShader();