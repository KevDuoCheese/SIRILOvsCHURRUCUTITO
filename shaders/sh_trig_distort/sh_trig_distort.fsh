//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec2 time;
uniform vec2 frequency;
uniform vec2 Strength;

uniform vec2 alternate; // This for use the same coord as transform to do it

uniform bool alphaSurf;

void main()
{
	vec2 coordMod = v_vTexcoord.xy;
	// Mod on X
	coordMod.x = coordMod.x + sin((v_vTexcoord.y * frequency.x) + time.x) * Strength.x;
	// Mod on Y
	coordMod.y = coordMod.y + cos((v_vTexcoord.x * frequency.y) + time.y) * Strength.y;
	
	// Using alternate?
	if (alternate.x == 1.) { coordMod.x = v_vTexcoord.x; coordMod.x = coordMod.x + sin((v_vTexcoord.x * frequency.x) + time.x) * Strength.x; };
	if (alternate.y == 1.) { coordMod.y = v_vTexcoord.y; coordMod.y = coordMod.y + cos((v_vTexcoord.y * frequency.y) + time.y) * Strength.y; };
	
	vec4 endColor = v_vColour * texture2D( gm_BaseTexture, coordMod );
	if (alphaSurf) { endColor.rgb *= endColor.a; };
	
    gl_FragColor = endColor;
}
