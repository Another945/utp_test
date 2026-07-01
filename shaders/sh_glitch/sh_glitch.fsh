//
// Glitch fragment shader
//
varying vec2 v_vTexcoord;
uniform float u_intensity;
uniform float u_time;

float rand(vec2 co) {
    return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

void main() {
    vec2 uv = v_vTexcoord;

    float row   = floor(uv.y * 224.0);
    float n     = rand(vec2(row, floor(u_time * 15.0)));
    float shift = (n > (1.0 - u_intensity * 0.4))
                  ? (n - 0.6) * u_intensity * 0.12
                  : 0.0;

    float ab = u_intensity * 0.008;
    float r  = texture2D(gm_BaseTexture, uv + vec2(shift + ab, 0.0)).r;
    float g  = texture2D(gm_BaseTexture, uv + vec2(shift,      0.0)).g;
    float b  = texture2D(gm_BaseTexture, uv + vec2(shift - ab, 0.0)).b;

    float block = rand(vec2(floor(uv.x * 32.0), floor(uv.y * 18.0))
                       + floor(u_time * 8.0));
    if (block > 1.0 - u_intensity * 0.08) {
        r = block; g = block * 0.4; b = 0.0;
    }

    gl_FragColor = vec4(r, g, b, 1.0);
}