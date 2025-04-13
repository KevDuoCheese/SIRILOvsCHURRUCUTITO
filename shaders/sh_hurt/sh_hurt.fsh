//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float fadeValue;
uniform vec3 color;

uniform float alphaBlend;

void main()
{
	// Da end color
	vec4 endColor = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
	
	// Modify the RGB
	endColor.r = endColor.r + ((color.r - endColor.r) * fadeValue);
	
	endColor.g = endColor.g + ((color.g - endColor.g) * fadeValue);
	
	endColor.b = endColor.b + ((color.b - endColor.b) * fadeValue);
	
	if (alphaBlend == 1.0) { endColor.rgb *= endColor.a; };
	
    gl_FragColor = endColor;
}
