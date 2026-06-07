shader_type canvas_item;

uniform vec2 size = vec2(100.0, 100.0); // the rect's pixel size
uniform float radius : hint_range(0.0, 200.0) = 20.0;

void fragment() {
    vec2 pos = UV * size;
    vec2 half_size = size * 0.5;
    vec2 corner = abs(pos - half_size) - (half_size - vec2(radius));
    float dist = length(max(corner, vec2(0.0))) - radius;

    COLOR = texture(TEXTURE, UV);
    COLOR.a *= 1.0 - smoothstep(-1.0, 1.0, dist); // anti-aliased edge
}