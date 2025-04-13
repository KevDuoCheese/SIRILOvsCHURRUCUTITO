//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec3 palleteArr[16];

void main()
{
	vec4 thisColor = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
	
	// Get the main color indexed
	float bwColor = (thisColor.r + thisColor.g + thisColor.b) / 3.;
	// Get the int of it
	int indexPart = int(floor(bwColor * 16.));
	
	
	//indexPart = indexPart mod 16;
	if (indexPart == 16) { indexPart = 15; };
	
	
	// Set to that color
	thisColor.r = palleteArr[indexPart].r;
	thisColor.g = palleteArr[indexPart].g;
	thisColor.b = palleteArr[indexPart].b;
	
	
    gl_FragColor = thisColor;
}
