//
// Simple passthrough fragment shader
//
#extension GL_OES_standard_derivatives : require
precision highp float;

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

varying vec2 vUv;
varying vec2 vRes;


vec4 smoothTex2D( sampler2D tex, vec2 UV ){
	
	vec2 alpha = .666 * vec2(abs(dFdx(UV.x)), abs(dFdy(UV.y)));//+0.06;

	vec2 x = fract(UV);
	vec2 x_ =	 clamp(.5 / alpha * x, 0., 0.5) +
				 clamp(.5 / alpha * (x - 1.) + .5, 0., .5);
			
	vec2 texCoord = (floor(UV) + x_) / vRes;//vec2(vW,vH);

	return texture2D( tex, texCoord );
}

uniform vec2 in_Texel;
uniform float outlineSize;
uniform vec3 outlineColor;
uniform float outlineAlpha;
uniform float globalAlpha;
uniform bool isPixelPerfect;
uniform bool coverCorners;

void main()
{
	
	vec4 Colour;
    Colour = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
	if (isPixelPerfect == true) { Colour = v_vColour * smoothTex2D(gm_BaseTexture, vUv); };
	
	vec2 pixelSize = in_Texel * outlineSize;
	
	vec4 newColor;
	
	
	// If alpha its totally invisible
	if (Colour.a <= 0.0) {
		
		float alpha = 0.0;
		float pixelOlength = outlineSize;
		
		if (isPixelPerfect == false) {
		
		// Search a pixel with alpha
		if (v_vTexcoord.x - pixelSize.x >= 0.0)
		{ alpha = max(alpha, texture2D(gm_BaseTexture, vec2(v_vTexcoord.x - pixelSize.x, v_vTexcoord.y)).a); };
		
		if (v_vTexcoord.x + pixelSize.x < 1.0)
		{ alpha = max(alpha, texture2D(gm_BaseTexture, vec2(v_vTexcoord.x + pixelSize.x, v_vTexcoord.y)).a); };
		
		
		if (v_vTexcoord.y + pixelSize.y < 1.0)
		{ alpha = max(alpha, texture2D(gm_BaseTexture, vec2(v_vTexcoord.x, v_vTexcoord.y + pixelSize.y)).a); };
		
		if (v_vTexcoord.y - pixelSize.y >= 0.0)
		{ alpha = max(alpha, texture2D(gm_BaseTexture, vec2(v_vTexcoord.x, v_vTexcoord.y - pixelSize.y)).a); };
		
		
		if (coverCorners == true) {
			
			if (v_vTexcoord.x - pixelSize.x >= 0.0 && v_vTexcoord.y - pixelSize.y >= 0.0)
			{ alpha = max(alpha, texture2D(gm_BaseTexture, vec2(v_vTexcoord.x - pixelSize.x, v_vTexcoord.y - pixelSize.y)).a); };
			
			if (v_vTexcoord.x - pixelSize.x >= 0.0 && v_vTexcoord.y + pixelSize.y < 1.0)
			{ alpha = max(alpha, texture2D(gm_BaseTexture, vec2(v_vTexcoord.x - pixelSize.x, v_vTexcoord.y + pixelSize.y)).a); };
			
			if (v_vTexcoord.x + pixelSize.x < 1.0 && v_vTexcoord.y - pixelSize.y >= 0.0)
			{ alpha = max(alpha, texture2D(gm_BaseTexture, vec2(v_vTexcoord.x + pixelSize.x, v_vTexcoord.y - pixelSize.y)).a); };
			
			if (v_vTexcoord.x + pixelSize.x < 1.0 && v_vTexcoord.y + pixelSize.y < 1.0)
			{ alpha = max(alpha, texture2D(gm_BaseTexture, vec2(v_vTexcoord.x + pixelSize.x, v_vTexcoord.y + pixelSize.y)).a); };//*/
			
		};
		
		} else {
		
		// Search a pixel with alpha
		if (v_vTexcoord.x - pixelSize.x >= 0.0)
		{ alpha = max(alpha, smoothTex2D(gm_BaseTexture, vec2(v_vTexcoord.x - pixelSize.x, v_vTexcoord.y) * vRes).a); };
		
		if (v_vTexcoord.x + pixelSize.x < 1.0)
		{ alpha = max(alpha, smoothTex2D(gm_BaseTexture, vec2(v_vTexcoord.x + pixelSize.x, v_vTexcoord.y) * vRes).a); };
		
		
		if (v_vTexcoord.y + pixelSize.y < 1.0)
		{ alpha = max(alpha, smoothTex2D(gm_BaseTexture, vec2(v_vTexcoord.x, v_vTexcoord.y + pixelSize.y) * vRes).a); };
		
		if (v_vTexcoord.y - pixelSize.y >= 0.0)
		{ alpha = max(alpha, smoothTex2D(gm_BaseTexture, vec2(v_vTexcoord.x, v_vTexcoord.y - pixelSize.y) * vRes).a); };
		
		
		if (coverCorners == true) {
			
			if (v_vTexcoord.x - pixelSize.x >= 0.0 && v_vTexcoord.y - pixelSize.y >= 0.0)
			{ alpha = max(alpha, smoothTex2D(gm_BaseTexture, vec2(v_vTexcoord.x - pixelSize.x, v_vTexcoord.y - pixelSize.y) * vRes).a); };
			
			if (v_vTexcoord.x - pixelSize.x >= 0.0 && v_vTexcoord.y + pixelSize.y < 1.0)
			{ alpha = max(alpha, smoothTex2D(gm_BaseTexture, vec2(v_vTexcoord.x - pixelSize.x, v_vTexcoord.y + pixelSize.y) * vRes).a); };
			
			if (v_vTexcoord.x + pixelSize.x < 1.0 && v_vTexcoord.y - pixelSize.y >= 0.0)
			{ alpha = max(alpha, smoothTex2D(gm_BaseTexture, vec2(v_vTexcoord.x + pixelSize.x, v_vTexcoord.y - pixelSize.y) * vRes).a); };
			
			if (v_vTexcoord.x + pixelSize.x < 1.0 && v_vTexcoord.y + pixelSize.y < 1.0)
			{ alpha = max(alpha, smoothTex2D(gm_BaseTexture, vec2(v_vTexcoord.x + pixelSize.x, v_vTexcoord.y + pixelSize.y) * vRes).a); };//*/
			
		};
		
		};
		
		
		// If others pixels alpha is visible
		if (alpha > 0.0) {
			
			// get new color
			newColor = vec4(outlineColor.x, outlineColor.y, outlineColor.z, alpha * outlineAlpha);
		};//*/
		
	} else if (Colour.a < 1.0) { // A little o totally visible, just put back the outline color
		
		// Dest color is black
		// Source is our pixel
		
		// Alpha of this pixel converted
		float thisAlpha = min(Colour.a / globalAlpha, 1.0);
		// Alpha inverted
		float invAlpha = 1.0 - thisAlpha;
		
		
		
		// get new color
		newColor = vec4(
					(Colour.r * thisAlpha) + (outlineColor.r * invAlpha),
					(Colour.g * thisAlpha) + (outlineColor.g * invAlpha),
					(Colour.b * thisAlpha) + (outlineColor.b * invAlpha),
					(Colour.a * thisAlpha) + (outlineAlpha * invAlpha)
					);
		
	} else {
		
		// set new color
		newColor = Colour;
		
	};
	
	
	
	
	gl_FragColor = vec4(newColor.rgb * newColor.a, newColor.a);
}


