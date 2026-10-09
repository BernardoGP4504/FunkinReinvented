#pragma header

vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor

void main() {
    vec4 color = flixel_texture2D(bitmap, uv);
    
    // Rosa do flash: 0xFFFF9BF6
    vec3 pinkFlash = vec3(1.0, 0.608, 0.965);
    
    // Intensidade reduzida de 0.6 → 0.35
    color.rgb += (1.0 - uv.y) * pinkFlash * 0.35;
    
    gl_FragColor = color;
}