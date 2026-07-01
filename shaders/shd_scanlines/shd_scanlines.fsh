varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_strength;

void main()
{
    float scanline = mod(floor(gl_FragCoord.y), 2.0);
    float dark = 1.0 - u_strength * scanline;
    vec4 color = v_vColour;
    color.rgb *= dark;
    gl_FragColor = color;
}