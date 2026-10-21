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
    
    float intensidade = (1.0 - uv.y) * 0.15;
    color.g += intensidade;
    
    gl_FragColor = vec4(color.r, color.g, color.b, color.a);
}