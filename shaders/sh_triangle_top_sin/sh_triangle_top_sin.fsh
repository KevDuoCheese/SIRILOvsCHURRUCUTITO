//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec2 time;
uniform vec2 frequency;
uniform vec2 Strength;
uniform float distanceMod;
uniform bool alphaSurf;
uniform bool topStretch;
uniform vec4 uvs;

void main()
{
	float myDistMod;
	
	float uvsHeight = (uvs.w - uvs.y);
	float uvsWidth = (uvs.z - uvs.x);
	
	
	
	
	vec2 coordMod = v_vTexcoord.xy;
	// Mod on Y
	coordMod.y = coordMod.y + cos(((v_vTexcoord.x - uvs.x) * frequency.y) + time.y) * Strength.y;
	// Using last, change the value depending on Y position
	float convertedY = ((coordMod.y - uvs.y) / uvsHeight);
	
	// Mod on X
	coordMod.x = coordMod.x + sin(((v_vTexcoord.y - uvs.y) * frequency.x * (topStretch ? convertedY : (1. - convertedY))) + time.x) * Strength.x * (topStretch ? (1. - convertedY) : convertedY);
	
	
	
	
	if (topStretch) {
		myDistMod = ((distanceMod - 1.) * (1. - convertedY)) + 1.;
	} else {
		myDistMod = ((distanceMod - 1.) * convertedY) + 1.;
	};
	
	float uvsMiddle = (uvs.z + uvs.x) / 2.;
	// Modify this
	coordMod.x = ((coordMod.x - uvsMiddle) * (1. / myDistMod)) + uvsMiddle;
	
	float modOcX = (((v_vTexcoord.x) - uvsMiddle) * (1. / myDistMod)) + uvsMiddle;
	
	
	
	vec4 endColor = v_vColour * texture2D( gm_BaseTexture, coordMod );
	// Modeable
	if (mod(floor((modOcX + (time.x * 0.01) - uvs.x) * 1800.), 2.) == 0.) { endColor.rgb = vec3(0.); };
	
	if (alphaSurf) { endColor.rgb *= endColor.a; };
	
    gl_FragColor = endColor;
}
