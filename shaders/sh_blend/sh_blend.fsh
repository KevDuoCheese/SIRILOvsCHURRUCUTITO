//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec3 color;
uniform float alphaBlend;

vec3 rgbToHSV( vec3 c )
{
	
	vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
	vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
	vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
	
	float d = q.x - min(q.w, q.y);
	float e = 1.0e-10;
	
	return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
	
}

vec3 hsvToRGB( vec3 c )
{
	
	vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
	vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
	return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void main()
{
	vec4 endColor = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
	
	vec3 hsv = rgbToHSV(endColor.rgb);
	
	// Get value of this shit
	float darkValue = hsv.z;
	
	// Convert original color to
	vec3 totalColor = rgbToHSV(color);
	
	// Dark the color
	totalColor.z *= darkValue;
	// Add to saturation
	totalColor.y += (1.0 - darkValue) * 1.0;
	// If it goes out 1.0
	float outBound = totalColor.y - 1.0;
	
	// Is out bound
	if (outBound > 0.0) {
		
		// Add to color HUE
		totalColor.x += outBound * 0.3;
		totalColor.x = mod(totalColor.x, 1.0);
		// Limit it
		totalColor.y = 1.0;
	};
	
	endColor.rgb = hsvToRGB(totalColor);
	
	
	// Has alpha blend
	if (alphaBlend == 1.0) { endColor.rgb *= endColor.a; };
	
	
    gl_FragColor = endColor;
}
