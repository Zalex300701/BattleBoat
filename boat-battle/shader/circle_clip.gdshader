shader_type canvas_item;

void fragment() {
    vec2 uv = UV;
    float dist = distance(uv, vec2(0.5, 0.5));
    float radius = 0.5;
    if (dist > radius) {
        COLOR.a = 0.0; // Make pixels outside the circle transparent
    }
}