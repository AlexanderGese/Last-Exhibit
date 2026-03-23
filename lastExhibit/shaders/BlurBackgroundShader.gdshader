shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear_mipmap;
uniform float blur_strength : hint_range(0.0, 10.0) = 2.0;
uniform int blur_samples : hint_range(1, 16) = 8;

void fragment() {
    vec2 pixel_size = blur_strength / vec2(textureSize(screen_texture, 0));

    vec4 color = vec4(0.0);
    float total_weight = 0.0;

    for (int x = -blur_samples; x <= blur_samples; x++) {
        for (int y = -blur_samples; y <= blur_samples; y++) {
            vec2 offset = vec2(float(x), float(y)) * pixel_size;

            // Gaussisches Gewicht
            float weight = exp(-float(x * x + y * y) / (2.0 * float(blur_samples * blur_samples)));

            color += texture(screen_texture, SCREEN_UV + offset) * weight;
            total_weight += weight;
        }
    }

    COLOR = color / total_weight;
}