
/// @description Get trigonometric distortion uniforms
function trdsUniforms(){

// Get uniforms for distortion
tdTime		 = shader_get_uniform(sh_trig_distort, "time");
tdFrequency	 = shader_get_uniform(sh_trig_distort, "frequency");
tdStrength	 = shader_get_uniform(sh_trig_distort, "Strength");
tdAlternate	 = shader_get_uniform(sh_trig_distort, "alternate");
tdAlphaSurf	 = shader_get_uniform(sh_trig_distort, "alphaSurf");

}

/// @description Get trigonometric distortion uniforms
function trdsStart(timeX, timeY, frequencyX, frequencyY, strengthX, strengthY, isAlphaSurf = false, alternateX = false, alternateY = false) {

// Start the shader
shader_set(sh_trig_distort);
shader_set_uniform_f(tdTime, timeX, timeY);
shader_set_uniform_f(tdFrequency, frequencyX, frequencyY);
shader_set_uniform_f(tdStrength, strengthX, strengthY);
shader_set_uniform_f(tdAlternate, real(bool(alternateX)), real(bool(alternateY)));
shader_set_uniform_f(tdAlphaSurf, isAlphaSurf);

}

/// @description End shader function
function trdsEnd() {

// It's just an shader reset XDD
shader_reset();

};