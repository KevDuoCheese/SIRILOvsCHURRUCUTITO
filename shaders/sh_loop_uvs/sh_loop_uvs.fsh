//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying vec3 v_vPosition;

uniform float uvs[4];
uniform vec2 size;
uniform vec2 position;

void main()
{
	// adjust this shit
	vec2 myPos = v_vPosition.xy - position.xy;
	// divice by it
	vec2 mySize = myPos / size;
	
	// adjust x
	mySize = mySize - floor(mySize);
	// multiply to adjust for uvs
	mySize.x = mySize.x * (uvs[2] - uvs[0]);
	mySize.y = mySize.y * (uvs[3] - uvs[1]);
	
	// add to it
	mySize.x = mySize.x + uvs[0];
	mySize.y = mySize.y + uvs[1];
	
    gl_FragColor = v_vColour * texture2D( gm_BaseTexture, mySize );
}
