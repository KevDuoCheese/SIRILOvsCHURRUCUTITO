//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main() {
    vec4 Colour = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
  
    gl_FragColor = vec4(Colour.rgb * Colour.a, Colour.a);
}
