shader_type canvas_item;

render_mode blend_mix;

uniform vec4 outline_color = vec4(0.0, 0.0, 1.0, 1.0); // Blue outline
uniform float outline_thickness = 2.0; // Outline thickness

void fragment() {
    vec4 original_color = texture(TEXTURE, UV);

    // If the current pixel is not part of the sprite, check surrounding pixels
    if (original_color.a < 0.1) {
        float max_alpha = 0.0;

        for (float x = -outline_thickness; x <= outline_thickness; x++) {
            for (float y = -outline_thickness; y <= outline_thickness; y++) {
                vec2 offset = vec2(x, y) * SCREEN_PIXEL_SIZE;
                max_alpha = max(max_alpha, texture(TEXTURE, UV + offset).a);
            }
        }

        // If any surrounding pixel is part of the sprite, apply the outline
        if (max_alpha > 0.1) {
            COLOR = outline_color;
        } else {
            discard; // No outline here
        }
    } else {
        // Render the original sprite color
        COLOR = original_color;
    }
}
