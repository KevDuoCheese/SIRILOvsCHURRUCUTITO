
#extension GL_OES_standard_derivatives : require
precision highp float;


// Get the varying variables
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying vec2 v_vPosition;

varying vec2 vUv;
varying vec2 vRes;

// Uniforms dude
uniform vec2 position;
uniform vec2 size;
uniform float uvs[8];
uniform vec2 sliceSize;

 
void main()
{
	vec2 co;
	
	vec2 pos = v_vPosition - position;
	
	if (pos.x < sliceSize.x)
	    co.x = pos.x / sliceSize.x * 0.25;
	else if (pos.x > size.x - sliceSize.x)
	    co.x = 0.75 + (pos.x - size.x + sliceSize.x) / sliceSize.x * 0.25;
	else
	    co.x = 0.25 + 0.5 * mod((pos.x - sliceSize.x) / sliceSize.x * 0.5, 1.0);
	
	if (pos.y < sliceSize.y)
	    co.y = pos.y / sliceSize.y * 0.25;
	else if (pos.y > size.y - sliceSize.y)
	    co.y = 0.75 + (pos.y - size.y + sliceSize.y) / sliceSize.y * 0.25;
	else
	    co.y = 0.25 + 0.5 * mod((pos.y - sliceSize.y) / sliceSize.y * 0.5, 1.0);
	
	co *= vec2(uvs[2] - uvs[0], uvs[3] - uvs[1]);
	co += vec2(uvs[0], uvs[1]);
	
	vec4 finalCol = v_vColour * texture2D(gm_BaseTexture, co);
	finalCol.rgb *= finalCol.a;
	
	gl_FragColor = finalCol;
}